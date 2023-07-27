local M = {}
M.exec_path = vim.fn.stdpath('data') .. '/alias.nvim/'
M.functions = {}

local function write_shell_script(path, script)
    local handle = io.open(M.exec_path .. path, "w")
    assert(handle)
    handle:write([[nvim --server $NVIM --remote-send "<cmd>]] .. script .. [[<cr>"]])
    handle:close();
end

local function bind_command(binding, command)
    write_shell_script(binding, [[lua vim.cmd(']] .. command .. [[')]])
end

local function bind_function(binding, func)
    M.functions[binding] = func
    write_shell_script(binding, [[lua require('alias-nvim').exec(']] .. binding .. [[')]])
end

M.setup = function(options)
    M.exec_path = options.exec_path or M.exec_path

    os.execute('mkdir -p ' .. M.exec_path)
    local path = vim.fn.getenv('PATH')
    vim.fn.setenv('PATH', M.exec_path .. ':' .. path)

    for command, binding in pairs(options.commands) do
        bind_command(command, binding)
    end

    for func, binding in pairs(options.functions) do
        bind_function(func, binding)
    end
    os.execute('chmod +x' .. M.exec_path .. '*')
end

M.exec = function(binding)
    M.functions[binding]()
end

return M
