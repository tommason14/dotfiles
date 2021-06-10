" Plugins {{{1
let g:notchestercolours = trim(system("grep colorscheme ~/dotfiles/vim/colours.vim | head -1")) != "colorscheme chester"

call plug#begin('~/.config/nvim/autoload/plugged')
Plug 'SirVer/ultisnips'
if g:notchestercolours
  Plug 'itchyny/lightline.vim'
endif
Plug 'tommason14/vim-snippets'
Plug 'tommason14/lammps.vim'
Plug 'tommason14/colours.vim'
Plug 'digitaltoad/vim-pug'
Plug 'junegunn/goyo.vim'               " Perfect for writing
Plug 'godlygeek/tabular'               " Fantastic formatting
Plug 'tomtom/tcomment_vim'             " Comments
Plug 'dylanaraps/wal.vim'
Plug 'chriskempson/base16-vim'
Plug 'daviesjamie/vim-base16-lightline'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'mike-hearn/base16-vim-lightline'
Plug 'tommason14/vim-lighthaus'
Plug 'b4skyx/serenade'
Plug 'voldikss/vim-floaterm'          
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}
Plug 'gaalcaras/ncm-R' " R completion
Plug 'ncm2/ncm2' " integrate with Nvim-R
Plug 'jalvesaq/vimcmdline'
call plug#end()

" Basics {{{1

filetype plugin indent on
syntax enable
set number
set relativenumber
set encoding=utf-8 
set foldmethod=marker
set foldlevelstart=0
set backspace=2 " backspace works like other editors
set visualbell " no beeps!
set belloff=all " no flashes!
set showcmd " visual select shows number of lines
set splitright " automatically place new vertical splits on the right
set expandtab " tabs to spaces
set ruler
set linebreak " don't break words when wrapping to new line
set autoindent
set smarttab
set formatoptions=tcqj
set wildmenu
set autoread " reload a file changed outside of vim
set noshowmode
set laststatus=2
set shortmess+=F " remove line that appears at bottom of file when opening
set mouse=a " move split borders with mouse while allowing the user to copy text with mouse
let g:local = $USER == "tommason" || $USER == "tmas0023"

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
let g:python3_host_prog = '/usr/local/bin/python3'

" Load snippets

function Snippets()
  if g:local
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

au BufWinLeave *.snippets :FloatermNew --autoclose=2 update_snippets.sh

" Remapping {{{1 

let mapleader = ","

" Snippets

nnoremap <Leader>s :call Snippets()<CR>

" Alt-arrow to move splits
map <A-Up> <C-w><Up>
map <A-Down> <C-w><Down>
map <A-Right> <C-w><Right>
map <A-Left> <C-w><Left>

" control + up/down = page up/page down
" so leftmost key on mech. keyboard works as mac function key
" map <C-Up> <PageUp>
" map <C-Down> <PageDown>

" Try out additional escape
inoremap jj <Esc>

" Sort selected text alphabetically
vnoremap <Leader>s :sort<CR>

" Copy/paste to/from clipboard

nnoremap <Leader>y "*y
nnoremap <Leader>b "*p

" Toggle folds
nnoremap <Space> za

" Re-wrap paragraph for markdown
au FileType markdown nnoremap <silent> gq gqip

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

" Evaluate highlighted expression
" (https://vi.stackexchange.com/questions/13602/the-meaning-of-in-vim)
" Yank into register k first so that spaces are retained
" gv to re-select expression
" qkq to clear register
vnoremap <Leader>e "kygv"=<C-r>k<CR>pqkq 

" Run python in vim

" Run on selected text
" vnoremap <Leader>p3 y`]o<Esc>o<Esc>iOutput:<Esc>p`[v`]:!python3<CR>
vnoremap <Leader>p3 y`]o<Esc>p`[v`]:!python3<CR>
vnoremap <Leader>p2 y`]o<Esc>o<Esc>iOutput:<Esc>p`[v`]:!python<CR>

" Run on selected text, no output
vnoremap <Leader>n3 y`]o<Esc>p`[v`]:!python3<CR>
vnoremap <Leader>n2 y`]o<Esc>p`[v`]:!python<CR>

" Run on entire buffer
nnoremap <Leader>p3 :norm ggVG$,p3<CR>0:norm <C-v><C-v>GI# <CR>
nnoremap <Leader>p2 :norm ggVG$,p2<CR>0:norm <C-v><C-v>GI# <CR>

" vimcmdline open vertically
let cmdline_follow_colorscheme = 1
" let cmdline_vsplit=1
" let cmdline_external_term_cmd='kitty %s &'
" Float term commands
function LFfloaterm(command)
  let g:floaterm_open_command = a:command
  FloatermNew lf
endfunction

nnoremap <Leader>l :call LFfloaterm('edit')<CR>
nnoremap <Leader>t :call LFfloaterm('tabe')<CR>

nnoremap <Leader>fp :set ft=python<CR>i
nnoremap <Leader>b :set ft=sh<CR>i

" open vimrc
nnoremap <Leader>v :tabnew ~/.config/nvim/init.vim<CR>

" Format csv files in buffer
au BufRead,BufNewFile *csv nnoremap <Leader>r :Tabularize /,<CR>gg

" Remove spaces and return to original csv.
" For first line, remove double space ,\s or \s, but not between words
au BufRead,BufNewFile *csv nnoremap <Leader>x ggV:s/\s\s//g<CR>V:s/,\s/,/g<CR>V:s/\s*,/,/g<CR>jVG:s/\s//g<CR>gg

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
    \ let g:formatters_python=['black']              |
    \ let g:black_linelength=100                     |
    \ set filetype=python                            |
    \ set formatoptions=tcqj                         |

" italic docstrings
au FileType python syn region Comment start=/"""/ end=/"""/ 

" Langauge server setup {{{1
" for python3: pip3 install 'python-language-server[yapf]'
" then remove pycodestyle and autopep8
" for perl: cpan install Perl::LanguageServer (no executable...)
" for R 

set hidden

" Automatically start language servers.
" let g:LanguageClient_autoStart = 1

let g:LanguageClient_serverCommands = {
  \ 'python': ['/usr/local/bin/pyls'],
  \ 'R': ['R', '--slave', '-e', 'languageserver::run()'],
  \ }

" disable preview window
set completeopt-=preview

" use omni completion provided by lsp
au FileType python,R set omnifunc=lsp#omnifunc

au FileType python nnoremap <silent> gd :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>

" autoformat on save
au BufWritePost *.py,*.R :call LanguageClient_textDocument_formatting()

" hide bar that appears at the side when linter detects an error
au FileType python,R set signcolumn=no

" gq to format
au FileType python,R nnoremap gq :call LanguageClient#textDocument_formatting()<CR>

" hide [LC] Project root: on startup
let g:LanguageClient_echoProjectRoot = 0

let g:deoplete#enable_at_startup = 1

" Perl {{{1

au BufNewFile,BufRead *.pl,*pm
    \ set tabstop=2  |
    \ set expandtab  |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set textwidth=100 |
    \ set filetype=perl |

" \ set complete-=i | " don't search /usr/local/Cellar/Perl5 when C-n autocompleting

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
    \ nnoremap <Leader>rp :w<CR>:!Rscript --slave % 2>/dev/null<CR>:!preview Rplots.pdf && rm Rplots.pdf<CR><CR> |
    \ vnoremap <Leader>r y`]o<Esc>p`[v`]:!R --slave 2>/dev/null<CR> |

" Nvim-R settings

" R output is highlighted with current colorscheme
let g:rout_follow_colorscheme = 1
" R commands in R output are highlighted
let g:Rout_more_colors = 1
" Disable the automatic _ to <- in insert mode
let R_assign = 0

 " Jade, HTML, JS, CSS, Sass, SCSS {{{1
au BufNewFile,BufRead *.jade
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set textwidth=79                      |
    \ set filetype=pug                      |

au BufWritePost *.jade :!jade -P %

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
    \ set filetype=markdown                 |

au FileType markdown let b:coc_suggest_disable = 1 " turn off suggestions when writing- it's distracting.

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

" au FileType tex let g:LanguageClient_diagnosticsEnable=0 

au Filetype tex setl updatetime=1
let g:tex_flavor = 'latex'
let g:vimtex_quickfix_open_on_warning = 0 " don't open quickfix window after compiling

 " Shell {{{1

au BufNewFile,BufRead *.sh,bash*,*lfrc*,*alias*
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    " \ set textwidth=79                      |
    \ set filetype=sh                       |
    \ set syntax=zsh                        |
" different syntax highlighting to filetypes, sh highlighting
" doesn't accept $(...)

" if ft=sh set on the fly
au FileType sh set syntax=zsh

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

" YAML {{{1
au BufNewFile,BufRead *.yml
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set textwidth=79                      |
    \ set filetype=yaml                     |

" Chem files {{{1
au BufNewFile,BufRead *.inp,*.ok,*.job,*.out,*.log
    \ set tabstop=2                         |
    \ set softtabstop=2                     |
    \ set expandtab                         |
    \ set shiftwidth=2                      |
    \ set filetype=sh                       | 

" LAMMPS comment style, for the Tcomment plugin
au Filetype lammps set commentstring=#%s

" remove blank line at the end of xyzs causing errors
au BufWritePost *xyz :%s#\($\n\s*\)\+\%$##

" Kitty conf {{{1
au BufRead kitty.conf set filetype=kitty
let g:tcomment_types={'kitty': '# %s'}

" Visuals {{{1

source ~/dotfiles/vim/colours.vim

hi Normal ctermbg=none " Use terminal background 
hi NonText ctermbg=none
hi Folded ctermbg=none " Same for folds
hi Statement cterm=none " keywords not in bold (normally cterm=bold)
" Italic comments
" First vim needs to know which characters to see to 
" switch to italic mode
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
" then set italics
hi Comment cterm=italic
hi Folded cterm=italic " Italic and use terminal colours

" Changes style of highlighting
hi clear SpellBad
hi SpellBad cterm=underline
set spellcapcheck=""
hi clear SpellLocal
hi clear Error 

" Statusline hidden by lightline, shows if lightline not in use
source ~/dotfiles/vim/statusline.vim
