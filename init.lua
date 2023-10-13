vim.opt.tabstop=4 
vim.opt.laststatus=2
vim.opt.shiftwidth=4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.softtabstop=4
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.backspace="indent,eol,start"
vim.opt.clipboard:append("unnamedplus")
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.encoding="utf-8"
vim.opt.mouse=a 
vim.opt.termencoding="utf-8"
vim.cmd('set novisualbell')
vim.opt.updatetime=300
vim.cmd('set nohlsearch')
vim.opt.rtp:append("/opt/homebrew/opt/fzf")
vim.opt.shell=zsh
vim.opt.lazyredraw = true
vim.opt.ignorecase = true
vim.opt.ai = true --Auto indent
vim.opt.si = true --Smart indent
-- Finding files - Search down into subfolders
vim.opt.path:append("**")
vim.opt.so=999
vim.opt.signcolumn = "yes"
vim.cmd("set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}")


vim.cmd('au BufNewFile,BufRead *.md set filetype=markdown')
vim.cmd('au BufNewFile,BufRead *.mdx set filetype=markdown')
vim.cmd('au BufNewFile,BufRead *.swift set filetype=swift')
vim.cmd('au BufNewFile,BufRead *.go set filetype=go')

vim.cmd('syntax on')

require "paq" {
    "savq/paq-nvim", -- Let Paq manage itself
    'joshdick/onedark.vim',
    'vim-airline/vim-airline',
    'cjrh/vim-conda',
    'vim-airline/vim-airline-themes', 
    'kyazdani42/nvim-web-devicons', 
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'neovim/nvim-lspconfig',
    'prabirshrestha/asyncomplete.vim',
    'ray-x/go.nvim',
    'nvim-treesitter/nvim-treesitter',
    { 'neoclide/coc.nvim', run = "!yarn install --frozen-lockfil"},
    'numToStr/Comment.nvim',
    'kmontocam/nvim-conda',
    'm4xshen/autoclose.nvim',
    'mfussenegger/nvim-dap',
    'leoluz/nvim-dap-go'
}


vim.g.mapleader = ' '

--require("Comment").setup()
-- require("autoclose").setup()
-- require('dap-go').setup()

vim.cmd('source $HOME/.config/nvim/themes/onedark.vim')


-- show buffers at the top of nvim"
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g['airline#extensions#tabline#buffer_nr_show'] = 1


vim.keymap.set('n', '<C-T>', '::Telescope find_files<CR>', {noremap = true})
vim.keymap.set('n', '<silent><expr> <TAB>', 'coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "<Tab>" : coc#refresh()', {})
vim.keymap.set('n', '<expr><S-TAB>', 'coc#pum#visible() ? coc#pum#prev(1) : "<C-h>"', {})


vim.cmd[[
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
]]

vim.keymap.set('n', '<silent><expr> <c-space>', 'coc#refresh()', {})

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
vim.keymap.set('n', '<silent> K', ':call ShowDocumentation()<CR>', {})

vim.keymap.set('n', '<leader>bw', ':bw<CR>', {})
vim.keymap.set('n', '<leader>bn', ':bn<CR>', {})
vim.keymap.set('n', '<leader>bp', ':bp<CR>', {})

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
vim.keymap.set('n', '<S-T>', ':Ex<CR>', {})

-- Highlight the symbol and its references when holding the cursor
vim.cmd('autocmd CursorHold * silent call CocActionAsync("highlight")')

-- Add `:Format` command to format current buffer
vim.cmd('command! -nargs=0 Format :call CocActionAsync("format")')
vim.cmd(':autocmd BufWritePost,FileWritePost *.py :call CocAction("format")')

-- Open init.vim to edit
vim.cmd('command! EditVimConfig :e /Users/romanvolkov/.dotfiles/init.vim')
