#!/bin/sh

# Images

FILE="${1}"
HEIGHT="${2}"
if [[ $USER =~ (tommason|tmas0023) ]]
then
  case "$1" in
      *.tar*) tar tf "$1";;
      *.zip) unzip -l "$1";;
      *.rar) unrar l "$1";;
      *.7z) 7z l "$1";;
      *.pdf) pdftotext "$1" -;;
      # *.jpg) feh --borderless "$1";;
      *lf*|*rc*|*sh) highlight -O ansi "$1" --syntax sh;;
      *) highlight -O ansi "$1" || cat "$1";;
  esac
fi
