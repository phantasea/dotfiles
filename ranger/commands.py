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


class empty(Command):
    """
    Warning: [^.] is an essential part of the above command.
    Without it, all files and directories of the form ..* will be deleted,
    wiping out everything in your home directory.
    """

    def execute(self):
        #self.fm.run("rm -rf /home/simone/.Trash/{*,.[^.]*}")
        #self.fm.run("rm -rf /home/simone/.Trash/{*,.[^.]+}")
        self.fm.run("rm -rf /home/simone/.Trash/*")


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


class fzf_select(Command):
    """
    :fzf_select

    With a prefix argument select only directories.
    """
    def execute(self):
        import subprocess
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
        import subprocess
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
        import subprocess
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
        import subprocess
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
        import subprocess
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
    def execute(self):
        if not self.arg(1):
            self.fm.notify("Usage: fzf_open <directory>", bad=True)
            return

        import subprocess
        from os.path import join, expanduser, lexists

        dirname = join(self.fm.thisdir.path, expanduser(self.rest(1)))
        if not lexists(dirname):
            self.fm.notify("directory doesn't exists", bad=True)
            return

        if not os.path.isdir(dirname):
            self.fm.notify("this isn't a directory!", bad=True)
            return

        command="fd -d=1 -t=f . '%s' | fzf --height=0 --bind 'ctrl-o:execute(fzfopen {})' | \
                sed 's/ /\\ /g' | xargs -r fileopen" % dirname
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

        import subprocess
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
        import subprocess
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

        import subprocess
        #import os.path
        #from ranger.container.file import File
        #command="rga '%s' . --rga-adapters=pandoc,poppler | fzf +m | awk -F':' '{print $1}'" % search_string
        command="rg '%s' . | fzf +m --height=0 --bind 'ctrl-o:execute(fzfopen -sd: {})' | \
                xargs -r fzfopen -sd: " % search_string
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        #stdout, stderr = fzf.communicate()
        #if fzf.returncode == 0:
        #    fzf_file = os.path.abspath(stdout.rstrip('\n'))
        #    self.fm.execute_file(File(fzf_file))

