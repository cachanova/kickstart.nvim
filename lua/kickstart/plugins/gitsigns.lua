-- Alternatively, use `config = function() ... end` for full control over the configuration.
-- If you prefer to call `setup` explicitly, use:
--    {
--        'lewis6991/gitsigns.nvim',
--        config = function()
--            require('gitsigns').setup({
--                -- Your gitsigns configuration here
--            })
--        end,
--    }
--
-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`.
--
-- See `:help gitsigns` to understand what the configuration keys do
return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode (range-based operations)
        map('v', '<leader>gs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>gr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [r]eset hunk' })
        map('v', '<leader>gu', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [u]ndo stage hunk' })
        map('v', '<leader>gc', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [c]heckout selected lines' })
        map('v', '<leader>gC', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [C]heckout selected hunk' })
        -- normal mode
        map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>gu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>gc', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line '.' }
        end, { desc = 'git [c]heckout current line' })
        map('n', '<leader>gC', gitsigns.reset_hunk, { desc = 'git [C]heckout current hunk' })
        -- both modes
        map({ 'n', 'v' }, '<leader>gS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map({ 'n', 'v' }, '<leader>gR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map({ 'n', 'v' }, '<leader>gp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map({ 'n', 'v' }, '<leader>gb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map({ 'n', 'v' }, '<leader>gd', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [d]iff against last commit' })
        map({ 'n', 'v' }, '<leader>gD', function()
          gitsigns.diffthis 'main'
        end, { desc = 'git [D]iff against main' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
