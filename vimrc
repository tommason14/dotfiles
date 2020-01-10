" Plugins {{{1

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/dotfiles/vim/bundle')

Plugin 'vim-syntastic/syntastic'         " Syntax highlighting
Plugin 'psf/black'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'              " Stores all snippets in xxx.snippets
Plugin 'junegunn/goyo.vim'               " Perfect for writing
Plugin 'godlygeek/tabular'               " Fantastic formatting
Plugin 'matze/vim-tex-fold' 
Plugin 'tomtom/tcomment_vim'             " Comments
Plugin 'digitaltoad/vim-pug'             " Jade syntax highlighting
Plugin 'dylanaraps/wal.vim'
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
set visualbell " no beeps!
set expandtab
set ruler
set linebreak " don't break words when wrapping to new line

" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/dotfiles/.vim'

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

" Ultisnips {{{1

let g:UltiSnipsUsePythonVersion = 3"
let g:snips_author="Tom Mason"
let g:snips_email="tommason14@gmail.com"
let g:snips_github="https:github.com/tommason14"

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" let g:snips_trigger_key = '<tab>'
" let g:snips_trigger_key_backwards = '<s-tab>'

autocmd Filetype tex nnoremap <Leader>s :tabnew ~/.vim/bundle/vim-snippets/snippets/tex.snippets<CR>
autocmd Filetype python nnoremap <Leader>s :tabnew ~/.vim/bundle/vim-snippets/snippets/python.snippets<CR>

" LF command {{{1

function! LF()
    let temp = tempname()
    exec 'silent !lf -selection-path=' . shellescape(temp)
    if !filereadable(temp)
        redraw!
        return
    endif
    let names = readfile(temp)
    if empty(names)
        redraw!
        return
    endif
    exec 'edit ' . fnameescape(names[0])
    for name in names[1:]
        exec 'argadd ' . fnameescape(name)
    endfor
    redraw!
endfunction
command! -bar LF call LF()

" Remapping {{{1 

let mapleader = ","

" LF key mapping

nnoremap <Leader>l :LF<CR>

" Try out additional escape
inoremap jj <Esc>

" Sort selected text alphabetically
vnoremap <Leader>s :sort<CR>

" Copy/paste to/from clipboard

nnoremap <Leader>y "*y
nnoremap <Leader>b "*p

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

" Run on selected text, no output
vnoremap <Leader>n y`]o<Esc>p`[v`]:!python3<CR>

" Run on entire buffer
nnoremap <Leader>p :norm ggVG$,p<CR>

" Run R in vim

" Run on selected text
vnoremap <Leader>E y`]o<Esc>o<Esc>iOutput:<Esc>p`[v`]:!Rscript <CR>

" Run on entire buffer
nnoremap <Leader>R :norm ggVG$,E<CR>

" Set filetype to allow above command whenever
nnoremap <Leader>f :set ft=python<CR>i

" open vimrc
nnoremap <Leader>v :tabnew $MYVIMRC<CR>
nnoremap sv :so $MYVIMRC<CR>

" Format csv files in buffer
nnoremap <Leader>r :Tabularize /,<CR>gg

" Remove spaces.
" For first line, remove double space ,\s or \s, but not between words
nnoremap <Leader>x ggV:s/\s\s//g<CR>V:s/,\s/,/g<CR>V:s/\s,/,/g<CR>jVG:s/\s//g<CR>gg

" Toggle comments - <Command>-/ mapped to ,c in iterm2
noremap <silent> <Leader>c :TComment<CR>

" Remove the highlighting after search, by removing after enter key is pressed
" regardless. <backspace> removes the :noh at bottom of editor
nnoremap <CR> :noh<CR>:<backspace>

" Reapply the custom spellcheck look
nnoremap <Leader>h :hi clear SpellBad<CR>:hi SpellBad cterm=underline<CR><CR>

" Compiling
au FileType markdown nnoremap <Leader>r :w<CR>:! pandoc --filter pandoc-crossref --filter pandoc-citeproc --filter pandoc-mustache --pdf-engine xelatex % -o %:r.pdf<CR><CR>

au FileType rmd nnoremap <Leader>r :w<CR>:!Rscript -e "require(rmarkdown); render('%')"<CR>


" Python  {{{1 

au BufNewFile,BufRead *.py
    \ set tabstop=4                                  |
    \ set expandtab                                  |
    \ set softtabstop=4                              |
    \ set shiftwidth=4                               |
    \ set textwidth=100                              |
    \ let g:black_linelength = 110                   |
    \ set filetype=python                            |

" autocmd BufWritePost *.py :Black
au FileType python nnoremap <Leader>r :!python3 %<CR>

" Perl {{{1

au BufNewFile,BufRead *.pl
    \ set tabstop=4  |
    \ set expandtab  |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=100 |
    \ set filetype=perl |
    \ nnoremap <Leader>r :!perl %<CR>

" R {{{1

au BufNewFile,BufRead *.Rmd,*.rmd
    \ set tabstop=2                                  |
    \ set expandtab                                  |
    \ set softtabstop=2                              |
    \ set shiftwidth=2                               |
    \ set spell spelllang=en_gb                      |
    \ set textwidth=80                               |
    \ set filetype=rmd                               |
    \ nnoremap <Leader>o :!open %:r.html<CR>         |

au BufNewFile,BufRead *.R,*Rprofile
    \ set tabstop=2                                  |
    \ set expandtab                                  |
    \ set softtabstop=2                              |
    \ set shiftwidth=2                               |
    \ set textwidth=80                               |
    \ set filetype=R                                 |

 " Jade, HTML, JS, CSS, Sass, SCSS {{{1
au BufNewFile,BufRead *.jade
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set textwidth=79                      |
    \ set filetype=pug                      |

au BufNewFile,BufRead *.html
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set textwidth=79                      |
    \ set filetype=html                     |

au BufNewFile,BufRead *.js
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set textwidth=79                      |
    \ set filetype=javascript               |

au BufNewFile,BufRead *.json
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set textwidth=79                      |
    \ set filetype=json                     |

au BufNewFile,BufRead *.css
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set textwidth=79                      |
    \ set filetype=css                      |

au BufNewFile,BufRead *.sass
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set textwidth=79                      |
    \ set filetype=sass                     |

au BufNewFile,BufRead *.scss
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set textwidth=79                      |
    \ set filetype=scss                     |

" Markdown/text files {{{1

au BufNewFile,BufRead *.md
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set textwidth=79                      |
    \ set spell spelllang=en_gb             |
    \ syn match markdownError "\w\@<=\w\@=" | " Stops highlighting after subscripting in equations

au BufNewFile,BufRead *.txt
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set textwidth=79                      |
    \ set spell spelllang=en_gb             |
    \ set filetype=plain                    |

" LaTeX {{{1

au BufNewFile,BufRead *.tex
    \ set formatoptions=tc                  |
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set textwidth=79                      |
    \ set filetype=tex                      |
    \ set syntax=latex-rewrite              |
    \ set spell spelllang=en_gb             |
    \ nnoremap <Leader>r :!compile_latex % <CR>   |

 " Bash {{{1

au BufNewFile,BufRead *.sh,bash*,*lfrc*
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set textwidth=79                      |
    \ set filetype=sh                       |

"  C++ {{{1
au BufNewFile,BufRead *.cpp
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set textwidth=79                      |
    \ set filetype=cpp                      |

" Compile when writing to a file
au BufWritePost *.cpp !g++ --std=c++17  % -o %:r

" Config with Makefiles {{{1

function Compile_on_save()
  if filereadable('Makefile')
    ! make install
  endif
endfunction

au BufWritePost config.h call Compile_on_save()

" Chem files {{{1
au BufNewFile,BufRead *.inp,*.ok,*.job,*.out,*.log
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set filetype=sh                       | 

" Visuals {{{1

set number
set relativenumber

" colo slate
colo wal
hi Normal ctermbg=none " Use terminal background 

" Changes style of highlighting
hi clear SpellBad
hi SpellBad cterm=underline
set spellcapcheck=""
hi clear SpellLocal
hi clear Error 

" if ssh, set dark background
let g:remoteSession = ($SSH_CLIENT != "")
if g:remoteSession
  set bg=dark
endif

" set list listchars=eol:$
" hi NonText ctermfg=DarkGrey
