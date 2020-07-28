set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set guicursor=n-v-c-sm:block,i-ci-ve:ver25-Cursor,r-cr-o:hor20

" Language servers

" Automatically start language servers.
let g:LanguageClient_autoStart = 1

let g:LanguageClient_serverCommands = {
  \ 'python': ['/usr/local/bin/pyls'],
  \ }

" disable preview window
set completeopt-=preview

" use omni completion provided by lsp
set omnifunc=lsp#omnifunc

" autoformat on save
au BufWritePost *.py :call LanguageClient_textDocument_formatting()

" hide [LC] Project root: on startup
let g:LanguageClient_echoProjectRoot = 0

" Slow autocomplete
let g:pymode_rope = 0
let g:jedi#completions_enabled = 0
