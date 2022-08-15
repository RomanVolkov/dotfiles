set tabstop=4 
set laststatus=2
set shiftwidth=4
set smarttab
set expandtab "Ставим табы пробелами
set softtabstop=4 "4 пробела в табе
set autoindent
set number
set backspace=indent,eol,start whichwrap+=<,>,[,]
set clipboard+=unnamedplus
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
set rtp+=/opt/homebrew/opt/fzf
set shell=zsh
set lazyredraw
" Ignore case when searching
set ignorecase
set ai "Auto indent
set si "Smart indent
" Finding files - Search down into subfolders
set path+=**
set so=999

au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.mdx set filetype=markdown

au BufNewFile,BufRead *.swift set filetype=swift

syntax on "Включить подсветку синтаксиса

call plug#begin('~/.config/nvim/autoload/plugged')
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'jmcantrell/vim-virtualenv'
Plug 'vim-airline/vim-airline-themes'
Plug 'keith/xcconfig.vim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'gfontenot/vim-xcode'
call plug#end()

source $HOME/.config/nvim/themes/onedark.vim

nnoremap <C-T> :Telescope find_files<CR>
