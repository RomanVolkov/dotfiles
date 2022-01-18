filetype plugin indent on

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
set mousehide "Спрятать курсор мыши когда набираем текст
set mouse=a "Включить поддержку мыши
set termencoding=utf-8 "Кодировка терминала
set novisualbell "Не мигать 
set ve+=onemore

let python_highlight_all = 1
syntax on "Включить подсветку синтаксиса

if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in normal mode
endif

call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'joshdick/onedark.vim'
call plug#end()

source $HOME/.vim/themes/onedark.vim

nnoremap <silent> <leader>; :Files<CR>
