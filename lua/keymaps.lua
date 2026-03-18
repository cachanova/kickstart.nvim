vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', 'H', ':bp<CR>')
map('n', 'L', ':bn<CR>')

map('n', 'Y', 'y$')
map('n', 'C', 'c$')
map('n', 'D', 'd$')

map('n', '<leader>w', ':w!<CR>')
map('n', '<leader>Q', ':qa!<CR>')
map('n', '<leader>x', ':w<CR>:bd<CR>')
map('n', '<leader>q', ':bd<CR>')

map('n', '<C-l>', '<C-w>l')
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')

-- Vertical splits
map('n', '<leader>V', ':rightbelow vsplit<CR>', { desc = 'Vsplit same file' })
map('n', '<leader>v', function()
  vim.cmd('rightbelow vsplit')
  require('telescope.builtin').find_files()
end, { desc = 'Vsplit with Telescope' })

-- Horizontal splits
map('n', '<leader>H', ':rightbelow split<CR>', { desc = 'Hsplit same file' })
map('n', '<leader>h', function()
  vim.cmd('rightbelow split')
  require('telescope.builtin').find_files()
end, { desc = 'Hsplit with Telescope' })

