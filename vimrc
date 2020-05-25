" Plugins {{{1

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-syntastic/syntastic'         " Syntax highlighting
Plugin 'psf/black'
Plugin 'SirVer/ultisnips'
Plugin 'tommason14/vim-snippets'
Plugin 'tommason14/lammps.vim'
Plugin 'junegunn/goyo.vim'               " Perfect for writing
Plugin 'godlygeek/tabular'               " Fantastic formatting
Plugin 'matze/vim-tex-fold' 
Plugin 'tomtom/tcomment_vim'             " Comments
Plugin 'digitaltoad/vim-pug'             " Jade syntax highlighting
Plugin 'dylanaraps/wal.vim'
Plugin 'chriskempson/base16-vim'

call vundle#end()

" Basics {{{1

set nocompatible
filetype plugin on
syntax enable
set encoding=utf-8 
set foldmethod=marker
set foldlevelstart=0
set backspace=2 " backspace works like other editors
set visualbell " no beeps!
set expandtab
set ruler
set linebreak " don't break words when wrapping to new line
set autoindent
set smartindent

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

" Ultisnips {{{1

let g:UltiSnipsUsePythonVersion = 3

" Load snippets

function Snippets()
  if $USER == "tommason" || $USER == "tmas0023"
    execute "tabnew ~/Documents/repos/vim-snippets/UltiSnips/".&ft.".snippets"
  else
    execute "tabnew ~/vim-snippets/UltiSnips/".&ft.".snippets"
  endif
endfunction

let g:snips_author="Tom Mason"
let g:snips_email="tommason14@gmail.com"
let g:snips_github="https:github.com/tommason14"

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

function GetAllSnippets()
  call UltiSnips#SnippetsInCurrentScope(1)
  let list = []
  for [key, info] in items(g:current_ulti_dict_info)
    let parts = split(info.location, ':')
    echo key
    " call add(list, {
    "   \"key": key,
    "   \"path": parts[0],
    "   \"linenr": parts[1],
    "   \"description": info.description,
    "   \})
  endfor
  return list
endfunction

au BufWritePost *.snippets !update_snippets.sh 

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

" Autocomplete - could clash with Ultisnips?
" inoremap <Leader><Tab> <C-n>
" " if in autocomplete, tab through
" inoremap <expr> <Tab> pumvisible ? "<C-n>" : "<Tab>"  
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<TAB>"

" Snippets

nnoremap <Leader>s :call Snippets()<CR>
nnoremap ls :call GetAllSnippets()<CR>

" Tabnew 

nnoremap <Leader>t :tabnew 

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
vnoremap <Leader>p3 y`]o<Esc>o<Esc>iOutput:<Esc>p`[v`]:!python3<CR>
vnoremap <Leader>p2 y`]o<Esc>o<Esc>iOutput:<Esc>p`[v`]:!python<CR>

" Run on selected text, no output
vnoremap <Leader>n3 y`]o<Esc>p`[v`]:!python3<CR>
vnoremap <Leader>n2 y`]o<Esc>p`[v`]:!python<CR>

" Run on entire buffer
nnoremap <Leader>p3 :norm ggVG$,p3<CR>
nnoremap <Leader>p2 :norm ggVG$,p2<CR>

" Select R plot and run with ,z<letter>
" small, large, mega
vnoremap <Leader>zs 
  \ y:tabnew tmpR.R<CR> 
  \ ipng('tmpR.png', width=1200, height=1200,res=300)<Esc>
  \ o<Esc>PGidev.off()<Esc>:wq<CR>
  \ :!Rscript tmpR.R<CR>
  \ :!qlmanage -p tmpR.png &> /dev/null <CR>
  \ :!rm tmpR.R tmpR.png<CR><CR>

vnoremap <Leader>zl y:tabnew tmpR.R<CR>ipng('tmpR.png', width=3000, height=2400, res=300)<Esc>o<Esc>PGidev.off()<Esc>:wq<CR>:!Rscript tmpR.R<CR>:!qlmanage -p tmpR.png &> /dev/null <CR>
 \:!rm tmpR.R tmpR.png<CR><CR>

vnoremap <Leader>zm y:tabnew tmpR.R<CR>ipng('tmpR.png', width=5000, height=4000, res=300)<Esc>o<Esc>PGidev.off()<Esc>:wq<CR>:!Rscript tmpR.R<CR>:!open tmpR.png && sleep 3<CR>:!rm tmpR.R tmpR.png<CR><CR>

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
    \ let g:black_linelength = 90                    |
    \ set filetype=python                            |
    \ set formatoptions=tcqj                         |

au BufWritePost *.py :Black
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
    \ nnoremap <Leader>p :tabnew $HOME/.rprofile<CR> |

au BufNewFile,BufRead *.R,*Rprofile
    \ set tabstop=2                                  |
    \ set expandtab                                  |
    \ set softtabstop=2                              |
    \ set shiftwidth=2                               |
    \ set textwidth=80                               |
    \ set filetype=R                                 |
    \ nnoremap <Leader>p :tabnew $HOME/.rprofile<CR> |
    \ nnoremap <Leader>r :w<CR>:!Rscript % <CR>:!open Rplots.pdf &<CR><CR> |

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
    \ set spell spelllang=en_gb             |
    \ nnoremap <Leader>r :!compile_latex % <CR> |
    \ nnoremap <Leader>o :!open %:r.pdf <CR> |

au Filetype tex setl updatetime=1
let g:livepreview_previewer = 'open -a Skim'
let g:livepreview_engine = 'xelatex'

 " Bash {{{1

au BufNewFile,BufRead *.sh,bash*,*lfrc*
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set textwidth=79                      |
    \ set filetype=sh                       |

"  C++ {{{
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

" LAMMPS comment style, for the Tcomment plugin
" au FileType lammps let g:tcomment#filetype#syntax_map_user = {'lammps': 'python'}
let g:tcomment_types={'lammps': '# %s'}

" Visuals {{{1

set number
set relativenumber

if $USER == "tommason" || $USER == "tmas0023"
  colo wal
else
  colo default
endif

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

hi Normal ctermbg=none " Use terminal background 
hi Folded ctermbg=none " Same for folds
hi Statement cterm=none " keywords not in bold (normally cterm=bold)
hi Folded cterm=none " Remove bold text from folds

" Changes style of highlighting
hi clear SpellBad
hi SpellBad cterm=underline
set spellcapcheck=""
hi clear SpellLocal
hi clear Error 

" set list
" set listchars=tab:→\ ,eol:↲
" " hi NonText ctermfg=DarkGrey

" Change cursor to thin line on insert
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
" lag when escaping from insert mode
set ttimeout
set ttimeoutlen=1
set ttyfast
