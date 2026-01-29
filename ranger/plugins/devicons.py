#!/usr/bin/python
# coding=UTF-8
# These glyphs, and the mapping of file extensions to glyphs
# has been copied from the vimscript code that is present in
# https://github.com/ryanoasis/vim-devicons

import re
import os


# Get the XDG_USER_DIRS directory names from environment variables
xdgs_dirs = {
    os.path.basename(os.getenv(key).rstrip('/')): icon
    for key, icon in (
        ('XDG_DOCUMENTS_DIR', ''),
        ('XDG_DOWNLOAD_DIR', ''),
        ('XDG_CONFIG_DIR', ''),
        ('XDG_MUSIC_DIR', ''),
        ('XDG_PICTURES_DIR', ''),
        ('XDG_PUBLICSHARE_DIR', ''),
        ('XDG_TEMPLATES_DIR', ''),
        ('XDG_VIDEOS_DIR', ''),
    )
    if os.getenv(key)
}


# all those glyphs will show as weird squares if you don't have the correct patched font
# My advice is to use NerdFonts which can be found here:
# https://github.com/ryanoasis/nerd-fonts
file_node_extensions = {
    '7z'       : '',
    'avi'      : '',
    'bat'      : '',
    'bz2'      : '',
    'c'        : '',
    'c++'      : '',
    'cab'      : '',
    'cbr'      : '',
    'cbz'      : '',
    'cc'       : '',
    'cmake'    : '',
    'conf'     : '',
    'cp'       : '',
    'cpp'      : '',
    'cs'       : '',
    'css'      : '',
    'cue'      : '',
    'cvs'      : '',
    'db'       : '',
    'deb'      : '',
    'diff'     : '',
    'dll'      : '',
    'wps'      : '',
    'doc'      : '',
    'docx'     : '',
    'docm'     : '',
    'dotx'     : '',
    'dotm'     : '',
    'epub'     : '',
    'exe'      : '',
    'fifo'     : '',
    'fish'     : '',
    'flac'     : '',
    'flv'      : '',
    'gif'      : '',
    'gz'       : '',
    'gzip'     : '',
    'h'        : '',
    'haml'     : '',
    'hh'       : '',
    'hpp'      : '',
    'htm'      : '',
    'html'     : '',
    'ini'      : '',
    'iso'      : '',
    'java'     : '',
    'jpeg'     : '',
    'jpg'      : '',
    'js'       : '',
    'json'     : '',
    'jsonc'    : '',
    'key'      : '',
    'less'     : '',
    'log'      : '',
    'lua'      : '',
    'm4a'      : '',
    'm4v'      : '',
    'markdown' : '',
    'md'       : '',
    'mkv'      : '',
    'mov'      : '',
    'mp3'      : '',
    'mp4'      : '',
    'mpeg'     : '',
    'mpg'      : '',
    'msi'      : '',
    'o'        : '',
    'ogg'      : '',
    'pdf'      : '',
    'php'      : '',
    'png'      : '',
    'pub'      : '',
    'ppt'      : '',
    'pptx'     : '',
    'pub'      : '',
    'py'       : '',
    'pyc'      : '',
    'pyd'      : '',
    'pyo'      : '',
    'rar'      : '',
    'rc'       : '',
    'rm'       : '',
    'rmvb'     : '',
    'rtf'      : '',
    'so'       : '',
    'sh'       : '',
    'sql'      : '',
    'tar'      : '',
    'tgz'      : '',
    'toml'     : '',
    'torrent'  : '',
    'ts'       : '',
    'vim'      : '',
    'vimrc'    : '',
    'wav'      : '',
    'webm'     : '',
    'wma'      : '',
    'xhtml'    : '',
    'xls'      : '',
    'xlsx'     : '',
    'xml'      : '',
    'xz'       : '',
    'yaml'     : '',
    'yml'      : '',
    'zip'      : '',
    'zsh'      : '',
}


dir_node_exact_matches = {
# English
    'Desktop'                          : '',
    'Documents'                        : '',
    'Downloads'                        : '',
    'Dotfiles'                         : '',
    'Music'                            : '',
    'Pictures'                         : '',
    'Public'                           : '',
    'Templates'                        : '',
    'Videos'                           : '',
# Chinese
    '文档'                             : '',
    '下载'                             : '',
    '音乐'                             : '',
    '图片'                             : '',
    '公共'                             : '',
    '模板'                             : '',
    '视频'                             : '',
}

# Python 2.x-3.4 don't support unpacking syntex `{**dict}`
# XDG_USER_DIRS
dir_node_exact_matches.update(xdgs_dirs)


file_node_exact_matches = {
    '.bash_aliases'                    : '',
    '.bash_history'                    : '',
    '.bash_logout'                     : '',
    '.bash_profile'                    : '',
    '.bashprofile'                     : '',
    '.bashrc'                          : '',
    '.gitconfig'                       : '',
    '.gitignore'                       : '',
    '.inputrc'                         : '',
    '.vim'                             : '',
    '.viminfo'                         : '',
    '.vimrc'                           : '',
    '.Xauthority'                      : '',
    '.Xdefaults'                       : '',
    '.xinitrc'                         : '',
    '.xinputrc'                        : '',
    '.Xresources'                      : '',
    '.zshrc'                           : '',
    'config'                           : '',
    'config.ac'                        : '',
    'config.m4'                        : '',
    'config.mk'                        : '',
    'configure'                        : '',
    'ini'                              : '',
    'ledger'                           : '',
    'license'                          : '',
    'LICENSE'                          : '',
    'LICENSE.md'                       : '',
    'LICENSE.txt'                      : '',
    'Makefile'                         : '',
    'makefile'                         : '',
    'Makefile.ac'                      : '',
    'Makefile.in'                      : '',
    'playlists'                        : '',
    'README'                           : '',
    'README.markdown'                  : '',
    'README.md'                        : '',
    'README.txt'                       : '',
    'user-dirs.dirs'                   : '',
}


def devicon(file):
    if file.is_directory:
        return dir_node_exact_matches.get(file.relative_path, '')

    return file_node_exact_matches.get(os.path.basename(file.relative_path),
                                       file_node_extensions.get(file.extension, ''))
