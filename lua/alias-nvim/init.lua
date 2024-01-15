local M = {}
M.exec_path = vim.fn.stdpath('data') .. '/alias.nvim/'
M.functions = {}
M.bindings = {}

local setup_path = function()
    os.execute('mkdir -p ' .. M.exec_path)
    local path = vim.fn.getenv('PATH')
    local _, count = string.gsub(path, M.exec_path .. ':', '')
    if count == 0 then
        vim.fn.setenv('PATH', M.exec_path .. ':' .. path)
    end
end

local teardown_path = function()
    local path = vim.fn.getenv('PATH')
    path = string.gsub(path, M.exec_path .. ':', '')
    vim.fn.setenv('PATH', path)
end

local write_shell_script = function(path, script)
    local handle = io.open(M.exec_path .. path, "w")
    assert(handle)
    handle:write("#!/usr/bin/env sh\n")
    handle:write("if [[ ! -S \"$NVIM\" ]]; then\n")
    handle:write("  export PATH=$(echo $PATH | sed -e 's|" .. M.exec_path .. ":||g')\n")
    handle:write("  exec $(basename $0) $@\n")
    handle:write("fi\n")
    handle:write([[nvim --server $NVIM --remote-send "<cmd>]] .. script .. [[<cr>"]])
    handle:close();
end

local bind_command = function(_, command)
    local script = [[lua vim.cmd(']] .. command .. [[')]]
    return script
end

local function get_shell_parameter_placeholders(func)
    local arity = debug.getinfo(func, 'u').nparams
    local n_pos_args = arity - 1
    if n_pos_args < 0 then n_pos_args = 0 end
    local res = ""
    for i=1, n_pos_args, 1 do
        res = res .. ", '$" .. i .. "'"
    end
    -- TODO: support variadic arguments
    -- local variadic = debug.getinfo(func, 'u').isvararg
    -- if variadic then res = res .. [[, $(printf ', \\\'%s\\\'' $@)]] end
    return res
end

local function bind_function(binding, func)
    M.functions[binding] = func
    local pos_args = get_shell_parameter_placeholders(func)
    local env_args = [[, { cwd = '$PWD', }]]
    local script = [[lua require('alias-nvim').exec(']] .. binding .. [[']] .. env_args .. pos_args .. [[)]]
    return script
end

M.test_setup = function (options)
    write_shell_script = function(path, script)
        M.bindings[path] = script
    end
    setup_path = function() end
    M.setup(options)
end

M.setup = function(options)
    M.exec_path = options.exec_path or M.exec_path

    setup_path()

    if options.commands then
        for binding, command in pairs(options.commands) do
            local script = bind_command(binding, command)
            write_shell_script(binding, script)
        end
    end

    if options.functions then
        for binding, func in pairs(options.functions) do
            local script = bind_function(binding, func)
            write_shell_script(binding, script)
        end
    end
    os.execute('chmod +x ' .. M.exec_path .. '*')

    vim.api.nvim_create_augroup('AliasNvim', { clear = true })
    vim.api.nvim_create_autocmd('VimLeave', {
        group = 'AliasNvim',
        callback = teardown_path,
    })
end

M.exec = function(binding, ...)
    M.functions[binding](...)
end

return M
