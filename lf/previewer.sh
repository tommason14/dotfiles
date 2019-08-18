#!/bin/sh
case "$1" in
    *.tar*) tar tf "$1";;
    *.zip) unzip -l "$1";;
    *.rar) unrar l "$1";;
    *.7z) 7z l "$1";;
    *.pdf) pdftotext "$1" -;;
    # *.jpg) imgcat "$1";;
    # *.jpg) montage -tile 7x1 -label %f -background black -fill white "$@" gif:- | convert - -colors 16 sixel:-; ;;
    *) highlight -O ansi "$1" || cat "$1";;
esac
