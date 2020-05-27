#!/usr/bin/env sh

# bash utils
brew install entr
brew install git
brew install gnuplot
brew install groff
brew install imagemagick
brew install lf
brew install open-babel
brew install pandoc
brew install pandoc-citeproc
brew install pandoc-crossref
brew install python
brew install r
brew install ranger
brew install tmux
brew install tree
brew install vim # should find +python3 with vim --version

# Avoid Ultisnips issues
git config --global core.editor "/usr/local/bin/vim"

# gui programs
brew cask install deckset
brew cask install google-drive-file-stream
brew cask install notion

brew cask install spectacle
curl https://gist.githubusercontent.com/tommason14/324cb37dd7803f3b06b39f53d38301f6/raw/spectacle.json
-o ~/Library/Application\ Support/Spectacle/Shortcuts.json

brew cask install visual-studio-code 
brew cask install zotero

brew tap zegervdv/zathura
brew install zathura
brew install zathura-pdf-poppler

# System setup

brew install yabai
brew install skhd

# Writing

brew install mactex
