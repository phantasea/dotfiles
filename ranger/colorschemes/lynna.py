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
        fg = 185

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.error:
                bg = 198
                fg = black
            if context.empty:
                attr |= bold
                fg = black
            if context.border:
                attr |= bold
                fg = blue
            if context.media:
                if context.image:
                    fg = 108
                elif context.audio:
                    fg = 187
                elif context.video:
                    fg = 146
                else:
                    fg = 185
            if context.container:
                fg = 206
            if context.mimetext:
                fg = 185
            if context.document:
                fg = 217
            if context.ebooks:
                fg = 183
            if context.www:
                fg = 147
            if context.special:
                fg = 198
                attr |= bold
            if context.directory:
                #attr |= bold
                fg = 39
            elif context.executable and not \
                    any((context.media, context.container,
                        context.fifo, context.socket)):
                #attr |= bold
                fg = 115
            if context.socket:
                fg = 207
                attr |= bold
            if context.fifo or context.device:
                fg = 185
                if context.device:
                    attr |= bold
            if context.link:
                attr |= bold
                if context.good:
                    fg = 207
                else:
                    fg = 241
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (198, 207):
                    fg = white
                else:
                    fg = 198
            if context.line_number:
                fg = white
                if not context.selected:
                    attr &= ~bold
                else:
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
                    bg = 207
                else:
                    fg = 207
            #if not context.selected and (context.cut or context.copied):
            if context.cut or context.copied:
                fg = 240
                attr |= bold
            if context.inactive_pane:
                if context.selected:
                    attr |= reverse
                    fg = 246
                    bg = 254

        elif context.in_titlebar:
            #attr |= bold
            if context.username:
                attr |= bold
                bg = context.bad and red   or green
                fg = context.bad and white or black
            elif context.hostname:
                attr |= bold
                bg = context.bad and red   or magenta
                fg = context.bad and white or black
            elif context.separator:
                attr |= bold
                fg = black
                bg = white
            elif context.link:
                fg = black
                bg = 207
            elif context.directory:
                fg = black
                bg = 39
            elif context.file:
                fg = black
                bg = 185
            elif context.keybuffer:
                bg = 115
                fg = black
            elif context.tab:
                attr |= bold
                fg = white
                if context.good:
                    bg = 198

        elif context.in_statusbar:
            #attr |= bold
            if context.permissions:
                bg = 198
                fg = black
            elif context.owner or context.group:
                bg = 207
                fg = black
            elif context.mtime:
                bg = 115
                fg = black
            elif context.link:
                bg = 63
                fg =white
                attr |= bold
            elif context.lspace:
                bg = white
                fg = black
            elif context.mspace:
                bg = 63
                fg = black
            elif context.rspace:
                bg = white
                fg = black
            elif context.flat:
                bg = 115
                fg = black
            elif context.filter:
                bg = 185
                fg = black
            elif context.size:
                bg = 168
                fg = black
            elif context.stars:
                bg = 207
                fg = black
            elif context.ruler or context.percentage or context.top or context.bot or context.all:
                bg = 202
                fg = black
            elif context.marked:
                bg = 198
                fg = black
            elif context.systime:
                bg = 115
                fg = black
            elif context.frozen:
                attr |= bold | reverse
                fg = 39
                fg += BRIGHT
            elif context.loaded:
                bg = white
                fg = black
                attr |= bold
            elif context.message:
                fg = 115
                if context.bad:
                    fg = 198
                attr |= reverse
                fg += BRIGHT
            elif context.vcsinfo:
                bg = 63
                fg = black
                attr &= ~bold
            elif context.vcscommit:
                bg = 185
                fg = black
                attr &= ~bold
            elif context.vcsdate:
                bg = 39
                fg = black
                attr &= ~bold

        elif context.in_console:
            bg = 198
            fg = white
            attr |= bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 39

            if context.selected:
                attr |= reverse

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = 207
            elif context.vcsuntracked:
                fg = 198
            elif context.vcschanged:
                fg = 198
            elif context.vcsunknown:
                fg = 198
            elif context.vcsstaged:
                fg = 115
            elif context.vcssync:
                fg = 115
            elif context.vcsignored:
                fg = white

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync or context.vcsnone:
                fg = 115
            elif context.vcsbehind:
                fg = 198
            elif context.vcsahead:
                fg = 63
            elif context.vcsdiverged:
                fg = 207
            elif context.vcsunknown:
                fg = 198

        return fg, bg, attr
