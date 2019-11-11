#!/usr/bin/env sh

# if [[ $USER == "tommason" ]]
# then
  # wal -i "$1"
# else
wal -ni "$1"
/usr/bin/osascript << END
tell application "Finder" to set desktop picture to POSIX file "$1"
END
# fi
