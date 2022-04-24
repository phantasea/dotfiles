# This file is part of ranger, the console file manager.
# License: GNU GPL version 3, see the file "AUTHORS" for details.

from __future__ import (absolute_import, division, print_function)

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    black, blue, cyan, green, magenta, red, white, yellow, default,
    normal, bold, reverse, dim, BRIGHT,
    default_colors,
)


class Chris(ColorScheme):
    def use(self, context):
        fg, bg, attr = default_colors
        fg = yellow

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.error:
                bg = red
                fg = black
            if context.empty:
                attr |= bold
                fg = black
            if context.border:
                fg = default
            if context.media:
                if context.image:
                    fg = yellow
                elif context.audio:
                    fg = yellow
                elif context.video:
                    fg = yellow
                else:
                    fg = yellow
            if context.container:
                fg = red
            if context.mimetext:
                fg = yellow
            if context.document:
                fg = yellow
            if context.special:
                fg = red
                attr |= bold
            if context.directory:
                #attr |= bold
                fg = cyan
            elif context.executable and not \
                    any((context.media, context.container,
                        context.fifo, context.socket)):
                #attr |= bold
                fg = green
            if context.socket:
                fg = magenta
                attr |= bold
            if context.fifo or context.device:
                fg = yellow
                if context.device:
                    attr |= bold
            if context.link:
                attr |= bold
                if context.good:
                    fg = magenta
                else:
                    fg = black
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (red, magenta):
                    fg = white
                else:
                    fg = red
            if context.line_number:
                fg = white
                if not context.selected:
                    attr &= ~bold
                else:
                    fg = white
                    attr |= bold | reverse
            if context.line_number_separator:
                fg, bg, attr = default_colors
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = white
            if context.badinfo:
                if attr & reverse:
                    bg = magenta
                else:
                    fg = magenta
            #if not context.selected and (context.cut or context.copied):
            if context.cut or context.copied:
                fg = black
                attr |= bold

        elif context.in_titlebar:
            #attr |= bold
            if context.hostname:
                attr |= bold
                fg = context.bad and red or green
                bg = red
                fg = white
            elif context.link:
                fg = black
                bg = magenta
            elif context.directory:
                fg = black
                bg = cyan
            elif context.file:
                fg = black
                bg = yellow
            elif context.keybuffer:
                bg = green
                fg = black
            elif context.tab:
                attr |= bold
                fg = white
                if context.good:
                    bg = red

        elif context.in_statusbar:
            #attr |= bold
            if context.permissions:
                bg = red
                fg = black
            elif context.owner or context.group:
                bg = magenta
                fg = black
            elif context.mtime:
                bg = green
                fg = black
            elif context.link:
                bg = blue
                fg =white
                attr |= bold
            elif context.lspace:
                bg = white
                fg = black
            elif context.mspace:
                bg = blue
                fg = black
            elif context.rspace:
                bg = white
                fg = black
            elif context.flat:
                bg = green
                fg = black
            elif context.filter:
                bg = yellow
                fg = black
            elif context.size:
                bg = yellow
                fg = black
            elif context.stars:
                bg = magenta
                fg = black
            elif context.ruler or context.percentage or context.top or context.bot or context.all:
                bg = yellow
                fg = black
            elif context.marked:
                bg = red
                fg = black
            elif context.systime:
                bg = green
                fg = black
            elif context.frozen:
                attr |= bold | reverse
                fg = cyan
                fg += BRIGHT
            elif context.loaded:
                bg = white
                fg = black
                attr |= bold
            elif context.message:
                fg = green
                if context.bad:
                    fg = red
                attr |= reverse
                fg += BRIGHT
            elif context.vcsinfo:
                bg = blue
                fg = black
                attr &= ~bold
            elif context.vcscommit:
                bg = yellow
                fg = black
                attr &= ~bold
            elif context.vcsdate:
                bg = cyan
                fg = black
                attr &= ~bold

        elif context.in_console:
            bg = red
            fg = white
            attr |= bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = cyan

            if context.selected:
                attr |= reverse

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = magenta
            elif context.vcsuntracked:
                fg = red
            elif context.vcschanged:
                fg = red
            elif context.vcsunknown:
                fg = red
            elif context.vcsstaged:
                fg = green
            elif context.vcssync:
                fg = green
            elif context.vcsignored:
                fg = white

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync or context.vcsnone:
                fg = green
            elif context.vcsbehind:
                fg = red
            elif context.vcsahead:
                fg = blue
            elif context.vcsdiverged:
                fg = magenta
            elif context.vcsunknown:
                fg = red

        return fg, bg, attr
