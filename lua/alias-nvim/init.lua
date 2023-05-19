local function setup(bindings)
    local exec_path = vim.fn.stdpath('data') .. '/alias.nvim/'
    os.execute('mkdir -p ' .. exec_path)
    local path = vim.fn.getenv('PATH')
    vim.fn.setenv('PATH', exec_path .. ':' .. path)
    for program, binding in pairs(bindings) do
        local handle = io.open(exec_path .. program, "w")
        if (handle == nil) then
            assert(false)
        end
        handle:write('nvim --server $NVIM --remote-send "<cmd>lcd $PWD | ', binding, '<cr>"')
        handle:close();
    end
    os.execute('chmod +x -R ' .. exec_path .. '*')
end

return {
    setup = setup,
}
