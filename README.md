# `alias.nvim`

Neovim plugin that makes integration between the nvim shell and nvim more lean and mean. 

# Installation

Lazy.nvim

```lua
{ 'fredeeb/alias.nvim' }
```

# Usage

This plugin adds the ability to call neovim commands and functions from your shell. Simply add a mapping between a shell script name and a neovim command or function, restart neovim, and you'll have the commands available in your PATH.

Some usages examples can be found below

```lua
require('alias-nvim').setup {
    commands = {
        -- running v in your shell will cd into your 
        -- current directory and open the file in your current editor
        v = 'cd $PWD | e ${1:-.}',
        -- running m in your shell will open the nvim man pager in your current editor
        m = 'Man $1',
    },
    functions = {
        -- run arbitrary function with positional args
        -- $ echo test
        echo = function (arg, opts) vim.print(arg) end,
        -- open neogit in current shell directory using opts.cwd
        -- $ gs
        gs = function (opts) require('neogit').open { cwd = opts.cwd } end,
        -- run diffview
        -- $ gd
        gd = function () require('diffview').open { cwd = '$PWD' } end,
        -- list git commits using fzf-lua
        -- $ gl
        gl = function () require('fzf-lua').git_commits() end,
    }
}
```

The plugin adds a directory to your PATH environment when you start it up, so all aliases take precedence over the rest of your path, making it very useful if you want to override programs or scripts only when you are in neovim.

# Configuration

```lua
require('alias-nvim').setup {
    -- Vim style commands, default is empty
    commands = {},
    -- Lua function bindings, default is empty
    -- they can take any number of parameters which will be passed from the terminal
    functions = {},
    -- default path for storing the scripts. will be created if it doesn't exist. Always prepended to PATH
    exec_path = vim.fn.stdpath('data') .. '/alias.nvim/'
}
```

# Contributing

You're always welcome to make a PR for this plugin if you have an idea for a new feature or a fix for one of my trademark bugs.
