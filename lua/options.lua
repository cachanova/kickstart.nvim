-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'nosplit'
vim.o.cursorline = true
vim.o.scrolloff = 15
vim.o.confirm = true

vim.cmd("highlight Normal guibg=none")

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.expandtab = true
vim.o.termguicolors = true
local hybrid_numbers_augroup = vim.api.nvim_create_augroup("HybridNumbersAuGroup", { clear = true })

vim.api.nvim_create_autocmd(
  { "BufEnter", "FocusGained", "InsertLeave", "WinEnter" },
  {
    group = hybrid_numbers_augroup,
    callback = function()
      vim.o.relativenumber = true
    end
  }
)

vim.api.nvim_create_autocmd(
  { "BufLeave", "FocusLost", "InsertEnter", "WinLeave" },
  {
    group = hybrid_numbers_augroup,
    callback = function()
      vim.o.relativenumber = false
    end
  }
)

vim.api.nvim_create_autocmd('VimResized', {
  desc = "Resize splits proportionally when window is resized",
  group = vim.api.nvim_create_augroup('auto-resize-splits', { clear = true }),
  command = 'wincmd =',
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = "Highlight when copying text",
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end
})

