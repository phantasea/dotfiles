#!/usr/bin/env bash

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

# If the option `use_preview_script` is set to `true`,
# then this script will be called and its output will be displayed in ranger.
# ANSI color codes are supported.
# STDIN is disabled, so interactive scripts won't work properly

# This script is considered a configuration file and must be updated manually.
# It will be left untouched if you upgrade ranger.

# Meanings of exit codes:
# code | meaning    | action of ranger
# -----+------------+-------------------------------------------
# 0    | success    | Display stdout as preview
# 1    | no preview | Display no preview at all
# 2    | plain text | Display the plain content of the file
# 3    | fix width  | Don't reload when width changes
# 4    | fix height | Don't reload when height changes
# 5    | fix both   | Don't ever reload
# 6    | image      | Display the image `$IMAGE_CACHE_PATH` points to as an image preview
# 7    | image      | Display the file directly as an image

# Script arguments
FILE_PATH="${1}"         # Full path of the highlighted file
PV_WIDTH="${2}"          # Width of the preview pane (number of fitting characters)
PV_HEIGHT="${3}"         # Height of the preview pane (number of fitting characters)
IMAGE_CACHE_PATH="${4}"  # Full path that should be used to cache image preview
PV_IMAGE_ENABLED="${5}"  # 'True' if image previews are enabled, 'False' otherwise.

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER=$(echo ${FILE_EXTENSION} | tr '[:upper:]' '[:lower:]')

# Settings
HIGHLIGHT_SIZE_MAX=262143  # 256KiB
HIGHLIGHT_TABWIDTH=8
HIGHLIGHT_STYLE='pablo'
PYGMENTIZE_STYLE='autumn'


handle_extension() {
    case "${FILE_EXTENSION_LOWER}" in
        # Archive
        a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
        rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)
            atool --list -- "${FILE_PATH}" && exit 5
            als "${FILE_PATH}" && exit 5
            exit 1;;
        rar)
            # Avoid password prompt by providing empty password
            als --option=use_rar_for_unpack=0 "${FILE_PATH}" && exit 5
            unrar v -- "${FILE_PATH}" && exit 5
            exit 1;;
        7z)
            # Avoid password prompt by providing empty password
            als "${FILE_PATH}" && exit 5
            7z l -p -- "${FILE_PATH}" && exit 5
            exit 1;;

        # PDF
        pdf)
            # Preview as text conversion
            pdftotext -l 3 -nopgbrk -q -- "${FILE_PATH}" - | fmt -w ${PV_WIDTH} && exit 5
            exit 1;;

        # MS documents:
        doc)
            antiword "${FILE_PATH}" | fmt -w ${PV_WIDTH} && exit 5
            catdoc   "${FILE_PATH}" | fmt -w ${PV_WIDTH} && exit 5
            exit 1;;

        # BitTorrent
        torrent)
            transmission-show -- "${FILE_PATH}" && exit 5
            exit 1;;

        # OpenDocument
        odt|ods|odp|sxw)
            # Preview as text conversion
            odt2txt "${FILE_PATH}" && exit 5
            exit 1;;

        # HTML
        htm|html|xhtml)
            # Preview as text conversion
            w3m -dump -T text/html "${FILE_PATH}" && exit 5
            elinks -dump "${FILE_PATH}" && exit 5
            exit 1;;

        # C/C++ files
        c|cpp)
            highlight -S c -O ansi -s dante "${FILE_PATH}" | fmt -s -w ${PV_WIDTH} && exit 5
            exit 1;;

        # Python script
        py)
            highlight -S python -O ansi -s dante "${FILE_PATH}" | fmt -s -w ${PV_WIDTH} && exit 5
            exit 1;;

        # GnuPG files
        asc)
            gpg --quiet --no-tty --no-use-agent --no-verbose -d "${FILE_PATH}" | fmt -s -w ${PV_WIDTH} && exit 5
            exit 1;;

        # ISO files
        iso)
            isoinfo -l -i "${FILE_PATH}" | fmt -s -w ${PV_WIDTH} && exit 5
            exit 1;;

        # Audio files
        mp3|wav|flac|ogg|ape|wma)
            mediainfo "${FILE_PATH}" | fmt -s -w ${PV_WIDTH} && exit 5
            exit 1;;

        # Media files
        rmvb|rmb|swf|avi|mp4|wmv|3gp|ogv|mkv|mpg|vob|flv|rmvb|rmb|vdat|webm)
            mediainfo "${FILE_PATH}" | fmt -s -w ${PV_WIDTH} && exit 5
            exit 1;;

        # Image files
        bmp|jpg|jpeg|png|gif|xpm|ppm)
            mediainfo "${FILE_PATH}" | fmt -s -w ${PV_WIDTH} && exit 5
            exit 1;;

        # Log files
        log)
            tail -n100 "${FILE_PATH}" | fmt -s -w ${PV_WIDTH} && exit 5
            exit 1;;

        # JSON files
        json)
            jq '.' "${FILE_PATH}" | fmt -s -w ${PV_WIDTH} && exit 5
            exit 1;;
    esac
}

handle_image() {
    local mimetype="${1}"
    case "${mimetype}" in
        image/*)
            local orientation
            orientation="$( identify -format '%[EXIF:Orientation]\n' -- "${FILE_PATH}" )"
            # If orientation data is present and the image actually
            # needs rotating ("1" means no rotation)...
            if [[ -n "$orientation" && "$orientation" != 1 ]]; then
                # ...auto-rotate the image according to the EXIF data.
                convert -- "${FILE_PATH}" -auto-orient "${IMAGE_CACHE_PATH}" && exit 6
            fi

            # `w3mimgdisplay` will be called for all images (unless overriden as above),
            # but might fail for unsupported types.
            exit 7;;
    esac
}

handle_mime() {
    local mimetype="${1}"
    case "${mimetype}" in
        # Text
        text/* | */xml)
            # Syntax highlight
            if [[ "$( stat --printf='%s' -- "${FILE_PATH}" )" -gt "${HIGHLIGHT_SIZE_MAX}" ]]; then
                exit 2
            fi
            if [[ "$( tput colors )" -ge 256 ]]; then
                local pygmentize_format='terminal256'
                local highlight_format='xterm256'
            else
                local pygmentize_format='terminal'
                local highlight_format='ansi'
            fi
            highlight --replace-tabs="${HIGHLIGHT_TABWIDTH}" --out-format="${highlight_format}" \
                --style="${HIGHLIGHT_STYLE}" --force -- "${FILE_PATH}" && exit 5
            # pygmentize -f "${pygmentize_format}" -O "style=${PYGMENTIZE_STYLE}" -- "${FILE_PATH}" && exit 5
            exit 2;;

        # Image Video and audio
        image/* | video/* | audio/*)
            mediainfo "${FILE_PATH}" && exit 5
            exiftool "${FILE_PATH}" && exit 5
            exit 1;;

        # Directory
        inode/directory)
            tree -F -L 3 --dirsfirst "${FILE_PATH}" && exit 5
            exit 1;;
    esac
}

handle_fallback() {
    echo '----- File Type Classification -----' && file --dereference --brief -- "${FILE_PATH}" && exit 5
    exit 1
}


#MIMETYPE="$( file --dereference --brief --mime-type -- "${FILE_PATH}" )"
MIMETYPE="$( mimetype -L --output-format %m "${FILE_PATH}" )"
if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
    handle_image "${MIMETYPE}"
fi
handle_extension
handle_mime "${MIMETYPE}"
handle_fallback

exit 1
