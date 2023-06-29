set tabstop=4 
set laststatus=2
set shiftwidth=4
set smarttab
set expandtab
set softtabstop=4
set autoindent
set number
set backspace=indent,eol,start whichwrap+=<,>,[,]
set clipboard+=unnamedplus
set wrap
set linebreak
set nobackup
set noswapfile
set encoding=utf-8
set mouse=a 
set termencoding=utf-8
set novisualbell
set updatetime=300
set nohlsearch
set rtp+=/opt/homebrew/opt/fzf
set shell=zsh
set lazyredraw
set ignorecase
set ai "Auto indent
set si "Smart indent
" Finding files - Search down into subfolders
set path+=**
set so=999

au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.mdx set filetype=markdown
au BufNewFile,BufRead *.swift set filetype=swift

syntax on

call plug#begin('~/.config/nvim/autoload/plugged')
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'cjrh/vim-conda'
Plug 'vim-airline/vim-airline-themes'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'ray-x/go.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" show buffers at the top of nvim"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1


source $HOME/.config/nvim/themes/onedark.vim
nnoremap <C-T> :Telescope find_files<CR>


inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')
:autocmd BufWritePost python Format

set signcolumn=yes
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
