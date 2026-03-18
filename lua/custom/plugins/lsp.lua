return {
    { --Autocompletion
        'saghen/blink.cmp',
        dependencies = {
            'rafamadriz/friendly-snippets',
        },
        version = '1.*',
        opts = {
            cmdline = { enabled = false },
            keymap = {
                preset = 'super-tab',
            },
            appearance = {
                nerd_font_variant = 'mono',
            },
            completion = {
                keyword = { range = 'full' },
                ghost_text = { enabled = true },
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
            },
            sources = {
                default = { 'snippets', 'lsp', 'path', 'buffer' },
            },
            signature = { enabled = true }
        }
    },
    -- TODO : folky/lazydev
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'mason-org/mason.nvim', opts = {} },
            'mason-org/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            { 'j-hui/fidget.nvim', opts = {} },
            'saghen/blink.cmp',
        },
        opts = {
            servers = {
                lua_ls = {},

                clangd = {
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                        "--fallback-style=llvm",
                    },
                },

                svlangserver = {},

                rust_analyzer = {
                    root_markers = { 'Cargo.toml' },
                },

                pyright = {},
            },
        },

        config = function(_, opts)
            local telescope = require('telescope.builtin')
            local pax = require('pax')

            -- Merge pax-specific server overrides
            for server, pax_config in pairs(pax.servers) do
                opts.servers[server] = vim.tbl_deep_extend('force', opts.servers[server] or {}, pax_config)
            end

            pax.setup()

            vim.lsp.config('*', {
                capabilities = {
                    textDocument = {
                        semanticTokens = {
                            multilineTokenSupport = true
                        }
                    }
                },
                root_markers = { '.git' }
            })

            for server, config in pairs(opts.servers) do
                config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
                vim.lsp.config(server, config)
                vim.lsp.enable(server)
            end

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    map('grr', telescope.lsp_references, 'goto references')
                    map('gri', telescope.lsp_implementations, 'goto implementations')
                    map('grd', telescope.lsp_definitions, 'goto definitions')
                    map('grD', vim.lsp.buf.declaration, 'goto declaration')
                    map('grt', telescope.lsp_type_definitions, 'goto type definition')

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight',
                            { clear = false })
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer   = event.buf,
                            group    = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })
                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer   = event.buf,
                            group    = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })
                        vim.api.nvim_create_autocmd('LspDetach', {
                            group    = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                            end,
                        })
                    end
                end,
            })

            vim.diagnostic.config {
                severity_sort = true,
                float = { border = 'rounded', source = 'if_many' },
                virtual_text = false,
            }

            vim.keymap.set('n',
                '<leader>l',
                function()
                    local current_virtual_text_state = vim.diagnostic.config().virtual_text
                    if (current_virtual_text_state == false) then
                        vim.diagnostic.config({ virtual_text = true })
                    else
                        vim.diagnostic.config({ virtual_text = false })
                    end
                end,
                { desc = 'Toggle virtual text' }
            )

            vim.keymap.set('n',
                '<leader>d',
                function()
                    vim.diagnostic.jump({ count = 1, float = true })
                end,
                { desc = 'Jump to next diagnostic with float' }
            )

            vim.keymap.set('n',
                '<leader>D',
                function()
                    vim.diagnostic.jump({ count = -1, float = true })
                end,
                { desc = 'Jump to prev diagnostic with float' }
            )
        end
    },
}
