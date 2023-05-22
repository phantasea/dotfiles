# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

#dunno why this is not working
if [[ "$TERM" =~ "256color" ]]; then
    eval "$(dircolors /opt/conf/dircolors.256dark)"
else
    eval "$(dircolors /opt/conf/dircolors)"
fi

# MPD daemon start (if no other user instance exists)
[ ! -s ~/.cache/mpd/mpd.pid ] && mpd

# set PATH so it includes user's private bin directories
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

PATH="/opt/util:/opt/util/bins:/opt/util/misc:$PATH"
