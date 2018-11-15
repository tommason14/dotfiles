" Plugins {{{1

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/dotfiles/vim/bundle')

Plugin 'vim-syntastic/syntastic'         " Syntax highlighting
Plugin 'Chiel92/vim-autoformat'
Plugin 'garbas/vim-snipmate'             " Tab for snippets, UltiSnipsExpandTrigger
Plugin 'MarcWeber/vim-addon-mw-utils'    " Snipmate dependency
Plugin 'tomtom/tlib_vim'                 " Snipmate dependency
Plugin 'honza/vim-snippets'              " Stores all snippets in xxx.snippets
Plugin 'junegunn/goyo.vim'               " Perfect for writing
Plugin 'godlygeek/tabular'               " Fantastic formatting
Plugin 'tomtom/tcomment_vim'             " Comments
call vundle#end()

" Basics {{{1

set nocompatible
filetype off
filetype plugin on
syntax enable
set encoding=utf-8 
set foldmethod=marker
set foldlevelstart=0
set clipboard=unnamed " system-wide copy
set backspace=2 " backspace works like other editors
set spell " spell-checker
set visualbell " no beeps!

" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif


" Searching {{{1
set ignorecase " ignore case while searching
set smartcase
set hlsearch   " highlight results
set incsearch  " search as you type

" Statusline {{{1

"set laststatus=2

" Ultisnips {{{1

let g:snips_author="Tom Mason"
let g:snips_email="tommason14@gmail.com"
let g:snips_github="https:github.com/tommason14"

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" autocmd {{{1 

function! NewPython()
  silent! 0r ~/.vim/templates/skeleton.py
  %s/filename/\=expand("%:t")/
  norm gg8j$a 
  startinsert
endfunction

function! NewR()
  silent! 0r ~/.vim/templates/skeleton.R
  norm ggG$o
  startinsert
endfunction

autocmd BufNewFile *.py call NewPython()
autocmd BufNewFile *.R call NewR()

autocmd Filetype tex nnoremap <Leader>s :tabnew ~/.vim/bundle/vim-snippets/snippets/tex.snippets<CR>
autocmd Filetype python nnoremap <Leader>s :tabnew ~/.vim/bundle/vim-snippets/snippets/python.snippets<CR>
" Remapping {{{1

let mapleader = ","

"Try out additional escape
inoremap jj <Esc>
inoremap ;; <Esc>

" Sort selected text alphabetically
vnoremap <Leader>s :sort<CR>

" Toggle folds
nnoremap <Space> za

" Re-wrap paragraph
nnoremap <silent> gq gqip

" Easy save
nnoremap <leader>w :w<CR>

" New lines
nnoremap o o<Esc>

" Navigation unaffected when soft wrapping
nnoremap j gj
nnoremap <Down> gj
inoremap <Down> <C-o>gj
nnoremap k gk
nnoremap <Up> gk
inoremap <Up> <C-o>gk

" Spell check - offer replacement
nnoremap <Leader><Space> z=

" Run python in vim

" Run on selected text
vnoremap <Leader>p y`]o<Esc>o<Esc>iOutput:<Esc>p`[v`]:!python3<CR>

" Visually select entire buffer, then run python 
nnoremap <Leader>p :norm ggVG$,p<CR>

" Set filetype to allow above command whenever
nnoremap <Leader>f :set ft=python<CR>i

" open vimrc
nnoremap <Leader>v :tabnew $MYVIMRC<CR>
nnoremap sv :so $MYVIMRC<CR>

vnoremap <Leader>a :Tabularize /&<CR>

" Format csv files in buffer
nnoremap <Leader>r ggVG:s/,/,    /g<CR>:noh<CR>

" Toggle comments - <Command>-/ mapped to ,c in iterm2
noremap <silent> <Leader>c :TComment<CR>

" Remove the highlighting after search, by removing after enter key is pressed
" regardless. <backspace> removes the :noh at bottom of editor
nnoremap <CR> :noh<CR>:<backspace>
" Visuals {{{1

set number
set relativenumber

" Changes style of highlighting
hi clear SpellBad
hi SpellBad cterm=underline

" Python  {{{1

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set expandtab |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=100 |
    \ set filetype=python |
" Jade, HTML, JS, CSS, Sass, SCSS {{{1
au BufNewFile,BufRead *.jade 
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set expandtab |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set filetype=jade |

au BufNewFile,BufRead *.html 
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set expandtab |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set filetype=html |

au BufNewFile,BufRead *.js 
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set expandtab |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set filetype=js |

au BufNewFile,BufRead *.json 
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set expandtab |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set filetype=json |

au BufNewFile,BufRead *.css 
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set expandtab |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set filetype=css |

au BufNewFile,BufRead *.sass 
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set expandtab |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set filetype=sass |

au BufNewFile,BufRead *.scss 
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set expandtab |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set filetype=scss |

" Markdown/text files {{{1

au BufNewFile,BufRead *.md 
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set expandtab |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set filetype=md |

au BufNewFile,BufRead *.txt 
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set expandtab |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set filetype=plain |
