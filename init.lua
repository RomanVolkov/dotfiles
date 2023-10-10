vim.opt.tabstop=4 
vim.opt.laststatus=2
vim.opt.shiftwidth=4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.softtabstop=4
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.backspace=indent,eol,start whichwrap+=<,>,[,]
vim.opt.clipboard+=unnamedplus
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.nobackup = true
vim.opt.noswapfile = true
vim.opt.encoding=utf-8
vim.opt.mouse=a 
vim.opt.termencoding=utf-8
vim.opt.novisualbell = true
vim.opt.updatetime=300
vim.opt.nohlsearch = true
vim.opt.rtp+=/opt/homebrew/opt/fzf
vim.opt.shell=zsh
vim.opt.lazyredraw = true
vim.opt.ignorecase = true
vim.opt.ai --Auto indent
vim.opt.si --Smart indent
-- Finding files - Search down into subfolders
vim.opt.path+=**
vim.opt.so=999
vim.opt.signcolumn=yes
vim.opt.statusline:append(%{coc#status()}%{get(b:,'coc_current_function','')})


vim.cmd('au BufNewFile,BufRead *.md set filetype=markdown')
vim.cmd('au BufNewFile,BufRead *.mdx set filetype=markdown')
vim.cmd('au BufNewFile,BufRead *.swift set filetype=swift')
vim.cmd('au BufNewFile,BufRead *.go set filetype=go')

vim.cmd('syntax on')

--paq-nvim
-- Auto install if not exist
local install_path = fn.stdpath('data')..'/site/pack/paqs/opt/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  vim.cmd('!git clone --depth 1 https://github.com/savq/paq-nvim.git '..install_path)
end

-- Load the plugin manager
-- :PaqInstall, :PaqClean
cmd 'packadd paq-nvim'

-- Set the short hand
local plug = require('paq-nvim').paq

-- Make paq manage it self
plug {'savq/paq-nvim', opt=true}
require('paq-nvim').install()
require('paq-nvim').clean()


plug 'joshdick/onedark.vim'
plug 'vim-airline/vim-airline'
plug 'cjrh/vim-conda'
plug 'vim-airline/vim-airline-themes'
plug 'kyazdani42/nvim-web-devicons'
plug 'nvim-lua/plenary.nvim'
plug 'nvim-telescope/telescope.nvim'
plug 'neovim/nvim-lspconfig'
plug 'prabirshrestha/asyncomplete.vim'
plug 'ray-x/go.nvim'
plug 'nvim-treesitter/nvim-treesitter'
plug 'neoclide/coc.nvim', {'branch': 'release'}
-- comment with 'gc'
plug 'numToStr/Comment.nvim'
plug 'kmontocam/nvim-conda'
plug 'm4xshen/autoclose.nvim'
plug 'mfussenegger/nvim-dap'
plug 'leoluz/nvim-dap-go'

vim.g.mapleader = ' '

require("Comment").setup()
require("autoclose").setup()
require('dap-go').setup()

vim.cmd('source $HOME/.config/nvim/themes/onedark.vim')


-- show buffers at the top of nvim"
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g['airline#extensions#tabline#buffer_nr_show'] = 1


vim.keymap.set('n', '<C-T>', '::Telescope find_files<CR>', {noremap = true})
vim.keymap.set('n', '<silent><expr> <TAB>', 'coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "\<Tab>" : coc#refresh()', {inoremap = true})
vim.keymap.set('n', '<expr><S-TAB>', 'coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"', {inoremap = true})


-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
vim.keymap.set('n', '<silent><expr> <CR>', 'coc#pum#visible() ? coc#pum#confirm() "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"', {inoremap = true})

vim.cmd[[
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
]]

vim.keymap.set('n', '<silent><expr> <c-space>', 'coc#refresh()', {inoremap = true})

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
vim.keymap.set('n', '<silent>[g', 'Plug>(coc-diagnostic-prev)', {})
vim.keymap.set('n', '<silent>]g', 'Plug>(coc-diagnostic-next)', {})

-- GoTo code navigation
vim.keymap.set('n', '<silent> gd', '<Plug>(coc-definition)', {})
vim.keymap.set('n', '<silent> gy', '<Plug>(coc-type-definition)', {})
vim.keymap.set('n', '<silent> gi', '<Plug>(coc-implementation)', {})
vim.keymap.set('n', '<silent> gr', '<Plug>(coc-references)', {})


-- Use K to show documentation in preview window
vim.keymap.set('n', '<silent> K', ':call ShowDocumentation()<CR>', {inoremap = true})

vim.keymap.set('n', '<leader>bw', ':bw<CR>', {inoremap = true})
vim.keymap.set('n', '<leader>bn', ':bn<CR>', {inoremap = true})
vim.keymap.set('n', '<leader>bp', ':bp<CR>', {inoremap = true})

vim.cmd[[
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
]]


-- going into Explore mode
vim.keymap.set('n', '<S-T>', ':Ex<CR>', {inoremap = true})

-- Highlight the symbol and its references when holding the cursor
vim.cmd('autocmd CursorHold * silent call CocActionAsync("highlight")')

-- Add `:Format` command to format current buffer
vim.cmd('command! -nargs=0 Format :call CocActionAsync("format")')
vim.cmd(':autocmd BufWritePost,FileWritePost *.py :call CocAction("format"))

-- Open init.vim to edit
vim.cmd('command! EditVimConfig :e /Users/romanvolkov/.dotfiles/init.vim')
