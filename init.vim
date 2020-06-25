set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Stop weird characters being entered into command mode 
" when opening files
" set guicursor=
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0
