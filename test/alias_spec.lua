describe("generating function bindings", function ()
    it ('can load alias', function ()
        require('alias-nvim')
    end)

    it ('can bind an empty function alias', function ()
        local a = require('alias-nvim')
        local rhs = function() end
        a.test_setup {
            functions = { test = rhs }
        }

        assert.equals(rhs, a.functions.test)
        assert.equals([[lua require('alias-nvim').exec('test', { cwd = '$PWD', })]] , a.bindings.test)
    end)

    it ('can bind a function alias that uses environment info', function ()
        local a = require('alias-nvim')
        local cwd = 'cwd'
        local rhs = function(opts) assert.equals(opts.cwd, cwd) end
        a.test_setup {
            functions = { test = rhs }
        }
        assert.equals(rhs, a.functions.test)
        assert.equals([[lua require('alias-nvim').exec('test', { cwd = '$PWD', })]] , a.bindings.test)
        a.exec('test', { cwd = cwd })
    end)

    it ('can bind a parameterized function alias', function ()
        local a = require('alias-nvim')
        local arg = 'argument'
        local rhs = function(_, farg) assert.equals(farg, arg) end
        a.test_setup {
            functions = { test = rhs }
        }
        assert.equals(rhs, a.functions.test)
        assert.equals([[lua require('alias-nvim').exec('test', { cwd = '$PWD', }, '$1')]] , a.bindings.test)
        a.exec('test', nil, arg)
    end)

    it ('can bind a vim function', function ()
        local a = require('alias-nvim')
        local arg = 'argument'
        a.test_setup {
            commands = { test = "test" }
        }
        assert.equals([[lua vim.cmd('test')]] , a.bindings.test)
        a.exec('test', nil, arg)
    end)
end)
