" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc
"
" " Stop weird characters being entered into command mode 
" " when opening files
" set guicursor=
"
"     ██▒   █▓ ██▓ ███▄ ▄███▓ ██▀███   ▄████▄
"    ▓██░   █▒▓██▒▓██▒▀█▀ ██▒▓██ ▒ ██▒▒██▀ ▀█
"     ▓██  █▒░▒██▒▓██    ▓██░▓██ ░▄█ ▒▒▓█    ▄
"      ▒██ █░░░██░▒██    ▒██ ▒██▀▀█▄  ▒▓▓▄ ▄██▒
"       ▒▀█░  ░██░▒██▒   ░██▒░██▓ ▒██▒▒ ▓███▀ ░
"       ░ ▐░  ░▓  ░ ▒░   ░  ░░ ▒▓ ░▒▓░░ ░▒ ▒  ░
"       ░ ░░   ▒ ░░  ░      ░  ░▒ ░ ▒░  ░  ▒
"         ░░   ▒ ░░      ░     ░░   ░ ░
"          ░   ░         ░      ░     ░ ░
"         ░                           ░

" if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
" 	silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
" 	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" 	autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
" endif

let mapleader=","
set encoding=utf-8
scriptencoding utf-8

" call plug#begin(stdpath('data') . '/plugged')
" Plug 'Sheerun/vim-polyglot'
" Plug 'fehawen/cs.vim'
" call plug#end()

" set background=light
" colorscheme cs

set list
set listchars=
set listchars+=tab:›\ ,
set listchars+=trail:·,
set fillchars+=eob:\ ,
set fillchars+=vert:\ ,
set title

set nowrap
set noshowmode
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set incsearch
set hlsearch
set ignorecase
set smartcase
set clipboard=unnamedplus
set nostartofline
set notimeout
set nottimeout
set backspace=indent,eol,start
set undofile
set noswapfile
set nu
set signcolumn=no
set autoread
set magic
set lazyredraw

set updatetime=300
set shortmess+=c
set cmdheight=1
set hidden

set ffs=unix,dos,mac
set pumheight=10
set maxmempattern=20000
set completeopt-=preview
set wildmenu
set wildignore+=**/node_modules/**

autocmd BufWritePre * %s/\s\+$//e
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
map <Tab> :noh<CR>
