local M = {}

M.PAX_DIR = '/Users/leela/code/pax'

function M.find_root(bufpath)
    return bufpath:match('(' .. M.PAX_DIR .. '/[^/]+)/')
end

-- Pax-specific LSP server overrides (merged on top of generic defaults)
M.servers = {
    svlangserver = {
        settings = {
            systemverilog = {
                launchConfiguration =
                "verilator --sv --lint-only --Wall --Wno-link -Wno-fatal **/*.svh **/*.vh **/*_pkg.sv **/*.v **/*.sv",
            }
        }
    },

    rust_analyzer = {
        settings = {
            ['rust-analyzer'] = {
                check = {
                    command = 'clippy',
                    extraArgs = {
                        '--exclude', 'live-hw',
                        '--features', 'mock-fpga',
                        '--all-targets', '--',
                        '-A', 'clippy::len_zero',
                        '-A', 'clippy::identity-op',
                        '-A', 'clippy::bool-comparison',
                        '-A', 'clippy::assign-op-pattern',
                        '-A', 'clippy::redundant_field_names',
                        '-A', 'clippy::uninlined_format_args',
                    },
                },
                cargo = { features = { 'mock-fpga' } },
                diagnostics = {
                    disabled = { 'unlinked-file' },
                },
            },
        },
    },
}

function M.verilator_include_args()
    local bufpath = vim.api.nvim_buf_get_name(0)
    local pax_root = M.find_root(bufpath)
    if not pax_root then return {} end
    local args = {}
    for _, dir in ipairs(vim.fn.glob(pax_root .. '/hw/src/*/', false, true)) do
        table.insert(args, '-I' .. dir)
    end
    table.insert(args, '-I' .. pax_root .. '/gen/sv')
    -- Package files must be passed as positional args for `import Pkg::*` to resolve
    for _, pkg in ipairs(vim.fn.glob(pax_root .. '/gen/sv/*Pkg.sv', false, true)) do
        table.insert(args, pkg)
    end
    for _, pkg in ipairs(vim.fn.glob(pax_root .. '/hw/src/**/*Pkg.sv', false, true)) do
        table.insert(args, pkg)
    end
    return args
end

-- Set up pax-specific autocmds
function M.setup()
    vim.api.nvim_create_autocmd('BufWritePost', {
        group = vim.api.nvim_create_augroup('pax-align-ws', { clear = true }),
        pattern = '*.rs',
        callback = function(ev)
            local bufpath = vim.api.nvim_buf_get_name(ev.buf)
            local pax_root = M.find_root(bufpath)
            if not pax_root then return end
            local bin = pax_root .. '/sw/src/target/release/align-ws'
            if vim.fn.executable(bin) == 1 then
                vim.system({ bin, bufpath }):wait()
                vim.cmd('checktime')
            end
        end,
    })
end

return M
