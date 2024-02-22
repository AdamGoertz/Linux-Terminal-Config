return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require('dap')

            vim.keymap.set("n", "<leader>bp", function() require('dap').toggle_breakpoint() end)
            -- vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
            -- vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
            -- vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
            -- vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
            -- vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
            -- vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
            -- vim.keymap.set('n', '<leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
            -- vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
            -- vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
            -- vim.keymap.set({'n', 'v'}, '<leader>dh', function()
            --   require('dap.ui.widgets').hover()
            -- end)
            -- vim.keymap.set({'n', 'v'}, '<leader>dp', function()
            --   require('dap.ui.widgets').preview()
            -- end)
            -- vim.keymap.set('n', '<leader>df', function()
            --   local widgets = require('dap.ui.widgets')
            --   widgets.centered_float(widgets.frames)
            -- end)
            -- vim.keymap.set('n', '<leader>ds', function()
            --   local widgets = require('dap.ui.widgets')
            --   widgets.centered_float(widgets.scopes)
            -- end)

            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "-i", "dap" }
            }
            dap.configurations.cpp = {
                {
                    name = "Launch",
                    type = "gdb",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ' .. vim.fn.getcwd() .. '/')
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtBeginningOfMainSubprogram = false,
                },
            }
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        config = function()
            require("dapui").setup()

            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end,
    },
}
