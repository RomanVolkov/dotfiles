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

let python_highlight_all = 1
syntax on "Включить подсветку синтаксиса

call plug#begin('~/.config/nvim/autoload/plugged')
Plug 'joshdick/onedark.vim'
call plug#end()

source $HOME/.config/nvim/themes/onedark.vim

set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:ver20-blinkwait400-blinkoff400-blinkon400
augroup END
