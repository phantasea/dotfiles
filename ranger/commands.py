# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import *
from collections import deque

# https://github.com/SL-RU/ranger_udisk_menu
from udisk_menu.mounter import mount

# You can import any python module as needed.
import os
import re

import time
import subprocess
import json
import atexit
import socket

from shlex import quote
from pathlib import Path
from subprocess import Popen, PIPE, run

import logging
logger = logging.getLogger(__name__)
import traceback

from ranger.ext.img_display import ImageDisplayer, register_image_displayer


class empty(Command):
    """
    Warning: [^.] is an essential part of the above command.
    Without it, all files and directories of the form ..* will be deleted,
    wiping out everything in your home directory.
    """

    def execute(self):
        #self.fm.run("rm -rf /home/simone/.Trash/{*,.[^.]*}")
        #self.fm.run("rm -rf /home/simone/.Trash/{*,.[^.]+}")
        self.fm.run("rm -rf $HOME/.Trash/*")


class filter_ext_type(Command):
    """
    filter files with extention type of the current file
    """

    def execute(self):
        ext = os.path.splitext(self.fm.thisfile.relative_path)[-1]
        if not ext:
            return

        cmd = "scout -fps " + ext
        self.fm.execute_console(cmd)
        self.fm.ui.redraw_window()


class subst(Command):
    """
    :subst <pattern> [replace]
    """

    def execute(self):
        from ranger.ext.shell_escape import shell_escape as esc

        if not self.arg(1):
            self.fm.notify("subst <pattern> [replace]")
            return

        pattern = self.arg(1)
        replace = self.rest(2)
        #regexobj = re.compile(pattern)
        #regexobj = re.compile(pattern, re.IGNORECASE)

        for file in self.fm.thistab.get_selection():
            filename = esc(file.basename)
            #newfilename = regexobj.sub(replace, filename)
            #newfilename = re.sub(pattern, replace, filename, flags=re.IGNORECASE)
            newfilename = re.sub(pattern, replace, filename)
            try:
                self.fm.notify(filename + ' -> ' + newfilename)
                self.fm.run('mv ' + filename + ' ' + newfilename)
            except OSError as err:
                self.fm.notify(err)


class display_ratings(Command):
    """
    :display_ratings

    display rating star info of favorite files
    """

    def execute(self):
        lines = []
        for entry in self.fm.rating_info:
            line = str(entry['star']) + ':' + entry['path']
            lines.append(line)

        if lines:
            pager = self.fm.ui.open_pager()
            pager.set_source(lines)
        else:
            self.fm.notify("There is no rating info to display!", bad=False)


class vidplay(Command):
    """
    :vidplay [anything]

    Play video file with mpv or mplayer
    """

    def execute(self):
        from ranger.ext.shell_escape import shell_escape as esc

        #command = 'mplayer -vo fbdev2 -xy 1024 -fs -zoom -really-quiet '
        if self.arg(1):
            command = 'mpv '
        else:
            command = 'mplayer -vo x11 '

        filename = esc(self.fm.thisfile.path)
        self.fm.run(command + filename)


class paste_as_root(Command):
    def execute(self):
        if self.fm.do_cut:
            self.fm.execute_console('shell sudo mv %c .')
        else:
            self.fm.execute_console('shell sudo cp -r %c .')


class mkcd(Command):
    """
    :mkcd <dirname>

    Creates a directory with the name <dirname> and enters it.
    """

    def execute(self):
        from os.path import join, expanduser, lexists
        from os import makedirs
        import re

        dirname = join(self.fm.thisdir.path, expanduser(self.rest(1)))
        if not lexists(dirname):
            makedirs(dirname)

            match = re.search('^/|^~[^/]*/', dirname)
            if match:
                self.fm.cd(match.group(0))
                dirname = dirname[match.end(0):]

            for m in re.finditer('[^/]+', dirname):
                s = m.group(0)
                if s == '..' or (s.startswith('.') and not self.fm.settings['show_hidden']):
                    self.fm.cd(s)
                else:
                    ## We force ranger to load content before calling `scout`.
                    self.fm.thisdir.load_content(schedule=False)
                    self.fm.execute_console('scout -ae ^{}$'.format(s))
        else:
            self.fm.notify("file/directory exists!", bad=True)


class goto_music_file(Command):
    """
    Go to currently played song in mocp/mpd
    """
    def execute(self):
        if not self.arg(1):
            self.fm.notify("goto_music_file <moc|mpc>", bad=True)
            return

        from ranger.ext import spawn
        from os.path import join, expanduser

        curr_music = ""
        if self.rest(1) == "moc":
            curr_music = spawn.check_output(["mocp", '-Q', '%file']).strip()
            if not curr_music:
                self.fm.notify("mocp might be in STOP mode!", bad=True)
                return
        elif self.rest(1) == "mpc":
            curr_music = spawn.check_output('mpc -f %file% | head -1').strip()
            curr_music = expanduser(join('~/auds', curr_music))
            if ".mp3" not in curr_music:
                self.fm.notify("mpd might be in STOP mode!", bad=True)
                return
        else:
            self.fm.notify("goto_music_file <moc/mpc>", bad=True)
            return

        self.fm.notify(curr_music, bad=False)
        self.fm.select_file(curr_music)


class fzf_select(Command):
    """
    :fzf_select

    With a prefix argument select only directories.
    """
    def execute(self):
        if self.quantifier:
            # match only directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
                    -o -type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m --height=0"
        else:
            # match files and directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
                    -o -print 2> /dev/null | sed 1d | cut -b3- | fzf +m --height=0"
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)


class fzf_locate(Command):
    def execute(self):
        if self.quantifier:
            command="cat ~/.favedirs | sed \"s%\~%$HOME%\" | xargs locate | \
                    fzf --height=0 --bind 'ctrl-o:execute(fzfopen {})' | xargs -r fileopen"
        else:
            command="cat ~/.favedirs | sed \"s%\~%$HOME%\" | xargs locate | \
                    fzf --height=0 --bind 'ctrl-o:execute(fzfopen {})' | xargs -r fileopen"
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)


class fzf_edit(Command):
    def execute(self):
        command="fd -t=f -t=l -H -E .git --size=-800k . | \
                fzf --height=0 --bind 'ctrl-o:execute(fzfopen {})' | xargs -r fileopen"
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)


class fzf_fave(Command):
    def execute(self):
        command="cat ~/.favedirs | sed \"s%\~%$HOME%\" | xargs fd -a -t=f -t=l . | \
                fzf --height=0 --bind 'ctrl-o:execute(fzfopen {})' | xargs -r fileopen"
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)


class fzf_exec(Command):
    def execute(self):
        if not self.arg(1):
            self.fm.notify("fzf_exec <fd cmd>", bad=True)
            return

        command = self.rest(1).strip('"') + ' | fzf --height=0'
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)


class fzf_open(Command):
    '''
    fzf_open [directory] [depth]
    '''
    def execute(self):
        from os.path import join, expanduser, lexists

        if not self.arg(1):
            dirname = self.fm.thisdir.path
            depth = 1
        else:
            if self.arg(1)[0] == '/' or self.arg(1)[0] == '~':
                dirname = expanduser(self.arg(1))
            if self.arg(1) == '.':
                dirname = self.fm.thisdir.path
            else:
                dirname = join(self.fm.thisdir.path, expanduser(self.arg(1)))

            if not self.arg(2):
                depth = 1
            else:
                depth = self.rest(2)
                if not str(depth).isnumeric:
                    self.fm.notify("depth must be an integer!", bad=True)
                    return

        if not lexists(dirname):
            self.fm.notify("directory doesn't exists", bad=True)
            return

        if not os.path.isdir(dirname):
            self.fm.notify("this isn't a directory!", bad=True)
            return

        command="fd -d=%s -t=f . '%s' | fzf --height=0 --bind 'ctrl-o:execute(fzfopen {})' | \
                sed 's/ /\\ /g' | xargs -r fileopen" % (str(depth), dirname)
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)

    def tab(self, tabnum):
        return self._tab_directory_content()


class fzf_iptv(Command):
    def execute(self):
        if not self.arg(1):
            self.fm.notify("Usage: fzf_iptv <m3u>", bad=True)
            return

        from os.path import join, expanduser, lexists

        iptv_m3u = self.rest(1)
        command="cat '%s' | fzf -d, --with-nth -1 --height=0 | \
                xargs -r vidplay -x 2>/dev/null" % iptv_m3u
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)

    def tab(self, tabnum):
        return self._tab_directory_content()


fd_deq = deque()
class fd_find(Command):
    """:fd_find [-d<depth>] <query>

    Executes "fd -d<depth> <query>" in the current directory and focuses the
    first match. <depth> defaults to 2, i.e. only the contents of the current
    directory.
    """

    def execute(self):
        from ranger.ext.get_executables import get_executables
        if not 'fd' in get_executables():
            self.fm.notify("Couldn't find fd on the PATH.", bad=True)
            return
        if self.arg(1):
            if self.arg(1)[:2] == '-d':
                depth = self.arg(1)
                target = self.rest(2)
            else:
                depth = '-d1'
                target = self.rest(1)
        else:
            self.fm.notify(":fd_find [-d<depth>] <query>", bad=True)
            return

        # For convenience, change which dict is used as result_sep to change
        # fd's behavior from splitting results by \0, which allows for newlines
        # in your filenames to splitting results by \n, which allows for \0 in
        # filenames.
        null_sep = {'arg': '-0', 'split': '\0'}
        nl_sep = {'arg': '', 'split': '\n'}
        result_sep = null_sep

        process = subprocess.Popen(['fd', result_sep['arg'], depth, target],
                    universal_newlines=True, stdout=subprocess.PIPE)
        (search_results, _err) = process.communicate()
        global fd_deq
        fd_deq = deque((self.fm.thisdir.path + os.sep + rel for rel in
            sorted(search_results.split(result_sep['split']), key=str.lower)
            if rel != ''))
        if len(fd_deq) > 0:
            self.fm.select_file(fd_deq[0])


class fd_next(Command):
    """:fd_next

    Selects the next match from the last :fd_search.
    """

    def execute(self):
        if len(fd_deq) > 1:
            fd_deq.rotate(-1)  #rotate left
            self.fm.select_file(fd_deq[0])
        elif len(fd_deq) == 1:
            self.fm.select_file(fd_deq[0])


class fd_prev(Command):
    """:fd_prev

    Selects the next match from the last :fd_search.
    """

    def execute(self):
        if len(fd_deq) > 1:
            fd_deq.rotate(1)  #rotate right
            self.fm.select_file(fd_deq[0])
        elif len(fd_deq) == 1:
            self.fm.select_file(fd_deq[0])


class fzf_rga(Command):
    """
    :fzf_rga <string>

    Search in PDFs, E-Books and Office documents in current directory.
    Allowed extensions: .epub, .odt, .docx, .fb2, .ipynb, .pdf.
    """
    def execute(self):
        if self.arg(1):
            search_string = self.rest(1)
        else:
            self.fm.notify("Usage: fzf_rga <search string>", bad=True)
            return

        #import os.path
        #from ranger.container.file import File
        #command="rga '%s' . --rga-adapters=pandoc,poppler | fzf +m | awk -F':' '{print $1}'" % search_string
        command="rg --smart-case '%s' . | fzf +m --height=0 --bind 'ctrl-o:execute(fzfopen -sd: {})' | \
                xargs -r fzfopen -sd: " % search_string
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        #stdout, stderr = fzf.communicate()
        #if fzf.returncode == 0:
        #    fzf_file = os.path.abspath(stdout.rstrip('\n'))
        #    self.fm.execute_file(File(fzf_file))


class nav_dir_hist(Command):
    def execute(self):
        lst = []
        for d in reversed(self.fm.tabs[self.fm.current_tab].history.history):
            lst.append(d.path)

        selected = self._select_with_fzf(["fzf"], "\n".join(lst))
        self._navigate_path(selected)

    def _navigate_path(self, selected):
        if not selected:
            return

        selected = os.path.abspath(selected)
        if os.path.isdir(selected):
            self.fm.cd(selected)
        elif os.path.isfile(selected):
            self.fm.select_file(selected)
        else:
            self.fm.notify(f"Neither dir nor file: {selected}", bad=True)
            return

    def _select_with_fzf(self, fzf_cmd, input):
        self.fm.ui.suspend()
        try:
            # stderr is used to open to attach to /dev/tty
            proc = subprocess.Popen(fzf_cmd, stdout=subprocess.PIPE, stdin=subprocess.PIPE, text=True)
            stdout, _ = proc.communicate(input=input)

            # ESC gives 130
            if proc.returncode not in [0, 130]:
                raise Exception(f"Bad process exit code: {proc.returncode}, stdout={stdout}")
        finally:
            self.fm.ui.initialize()
        return stdout.strip()


class fzf_mark(Command):
    """
    `:fzf_mark` refer from `:fzf_select`  (But Just in `Current directory and Not Recursion`)
        so just `find` is enough instead of `fdfind`)

    `:fzf_mark` can One/Multi/All Selected & Marked files of current dir that filterd by `fzf extended-search mode`
        fzf extended-search mode: https://github.com/junegunn/fzf#search-syntax
        eg:    py    'py    .py    ^he    py$    !py    !^py
    In addition:
        there is a delay in using `get_executables` (So I didn't use it)
        so there is no compatible alias.
        but find is builtin command, so you just consider your `fzf` name
    Usage
        :fzf_mark

        shortcut in fzf_mark:
        <CTRL-a>      : select all
        <CTRL-e>      : deselect all
        <TAB>         : multiple select
        <SHIFT+TAB>   : reverse multiple select
        ...           : and some remap <Alt-key> for movement
    """

    def execute(self):
        # from pathlib import Path  # Py3.4+
        import os
        import subprocess

        fzf_name = "fzf"

        hidden = ('-false' if self.fm.settings.show_hidden else r"-path '*/\.*' -prune")
        exclude = r"\( -name '\.git' -o -iname '\.*py[co]' -o -fstype 'dev' -o -fstype 'proc' \) -prune"
        only_directories = ('-type d' if self.quantifier else '')
        fzf_default_command = 'find -L . -mindepth 1 -type d -prune {} -o {} -o {} -print | cut -b3-'.format(
            hidden, exclude, only_directories
        )

        env = os.environ.copy()
        env['FZF_DEFAULT_COMMAND'] = fzf_default_command

        # you can remap and config your fzf (and your can still use ctrl+n / ctrl+p ...) + preview
        env['FZF_DEFAULT_OPTS'] = '\
        --multi \
        --reverse \
        --bind ctrl-a:select-all,ctrl-e:deselect-all,alt-n:down,alt-p:up,alt-o:backward-delete-char,alt-h:beginning-of-line,alt-l:end-of-line,alt-j:backward-char,alt-k:forward-char,alt-b:backward-word,alt-f:forward-word \
        --height 95% \
        --layout reverse \
        --border \
        --preview "cat {}  | head -n 100"'
        # if use bat instead of cat, you need install it
        # --preview "bat --style=numbers --color=always --line-range :500 {}"'

        fzf = self.fm.execute_command(fzf_name, env=env, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, _ = fzf.communicate()

        if fzf.returncode == 0:
            filename_list = stdout.strip().split()
            for filename in filename_list:
                # Python3.4+
                # self.fm.select_file( str(Path(filename).resolve()) )
                self.fm.select_file( os.path.abspath(filename) )
                self.fm.mark_files(all=False,toggle=True)


class YankContent(Command):
    """
    Copy the content of image file and text file with xclip
    """

    def execute(self):
        from ranger.ext.get_executables import get_executables
        if 'xclip' not in get_executables():
            self.fm.notify('xclip is not found.', bad=True)
            return

        arg = self.rest(1)
        if arg:
            if not os.path.isfile(arg):
                self.fm.notify('{} is not a file.'.format(arg))
                return
            from ranger.container.file import File
            file = File(arg)
        else:
            file = self.fm.thisfile
            if not file.is_file:
                self.fm.notify('{} is not a file.'.format(file.relative_path))
                return

        relative_path = file.relative_path
        cmd = ['xclip', '-selection', 'clipboard']
        if not file.is_binary():
            with open(file.path, 'rb') as fd:
                subprocess.check_call(cmd, stdin=fd)
        elif file.image:
            cmd += ['-t', file.mimetype, file.path]
            subprocess.check_call(cmd)
            self.fm.notify('Content of {} is copied to x clipboard'.format(relative_path))
        else:
            self.fm.notify('{} is not an image file or a text file.'.format(relative_path))

    def tab(self, tabnum):
        return self._tab_directory_content()


@register_image_displayer("mpv")
class MPVImageDisplayer(ImageDisplayer):
    """Implementation of ImageDisplayer using mpv, a general media viewer.
    Opens media in a separate X window.

    mpv 0.25+ needs to be installed for this to work.
    """

    def _send_command(self, path, sock):

        message = '{"command": ["raw","loadfile",%s]}\n' % json.dumps(path)
        s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        s.connect(str(sock))
        logger.info('-> ' + message)
        s.send(message.encode())
        message = s.recv(1024).decode()
        logger.info('<- ' + message)

    def _launch_mpv(self, path, sock):

        proc = subprocess.Popen([
            * os.environ.get("MPV", "mpv").split(),
            "--no-terminal",
            "--force-window",
            "--input-ipc-server=" + str(sock),
            "--image-display-duration=inf",
            "--loop-file=inf",
            "--no-osc",
            "--no-input-default-bindings",
            "--keep-open",
            "--idle",
            "--",
            path,
        ])

        @atexit.register
        def cleanup():
            proc.terminate()
            sock.unlink()

    def draw(self, path, start_x, start_y, width, height):

        path = os.path.abspath(path)
        cache = Path(os.environ.get("XDG_CACHE_HOME", "~/.cache")).expanduser()
        cache = cache / "ranger"
        cache.mkdir(exist_ok=True)
        sock = cache / "mpv.sock"

        try:
            self._send_command(path, sock)
        except (ConnectionRefusedError, FileNotFoundError):
            logger.info('LAUNCHING ' + path)
            self._launch_mpv(path, sock)
        except Exception as e:
            logger.exception(traceback.format_exc())
            sys.exit(1)
        logger.info('SUCCESS')


@register_image_displayer("imv")
class IMVImageDisplayer(ImageDisplayer):
    """
    Implementation of ImageDisplayer using imv
    """
    is_initialized = False

    def __init__(self):
        self.process = None

    def initialize(self):
        """ start imv """
        if (self.is_initialized and self.process.poll() is None and
                not self.process.stdin.closed):
            return

        self.process = Popen(['imv'], cwd=self.working_dir,
                             stdin=PIPE, universal_newlines=True)
        self.is_initialized = True
        time.sleep(1)

    def draw(self, path, start_x, start_y, width, height):
        self.initialize()
        run(['imv-msg', str(self.process.pid), 'close'])
        run(['imv-msg', str(self.process.pid), 'open', path])

    def clear(self, start_x, start_y, width, height):
        self.initialize()
        run(['imv-msg', str(self.process.pid), 'close'])

    def quit(self):
        if self.is_initialized and self.process.poll() is None:
            self.process.terminate()


@register_image_displayer("wezterm-image-display-method")
class WeztermImageDisplayer(ImageDisplayer):
    def draw(self, path, start_x, start_y, width, height):
        print("\033[%d;%dH" % (start_y, start_x+1))
        path = quote(path)
        draw_cmd = "wezterm imgcat {} --width {} --height {}".format(path, width, height)
        subprocess.run(draw_cmd.split(" "))
    def clear(self, start_x, start_y, width, height):
        cleaner = " "*width
        for i in range(height):
            print("\033[%d;%dH" % (start_y+i, start_x+1))
            print(cleaner)
