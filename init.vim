set tabstop=4 
set laststatus=2
set shiftwidth=4
set smarttab
set expandtab "Ставим табы пробелами
set softtabstop=4 "4 пробела в табе
set autoindent
set number
set backspace=indent,eol,start whichwrap+=<,>,[,]
set clipboard=unnamed
set wrap
set linebreak
set nobackup
set noswapfile
set encoding=utf-8 " Кодировка файлов по умолчанию
set mouse=a "Включить поддержку мыши
set termencoding=utf-8 "Кодировка терминала
set novisualbell "Не мигать 
set updatetime=300
set nohlsearch

syntax on "Включить подсветку синтаксиса

call plug#begin('~/.config/nvim/autoload/plugged')
Plug 'joshdick/onedark.vim'
Plug 'preservim/nerdtree'
call plug#end()

source $HOME/.config/nvim/themes/onedark.vim

set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:ver20-blinkwait400-blinkoff400-blinkon400
augroup END

nnoremap <C-O> :NERDTreeFocus<CR>
let NERDTreeQuitOnOpen=1
" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
