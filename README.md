# `alias.nvim`

Neovim plugin that makes integration between the nvim shell and nvim more lean and mean. 

# Installation

Lazy.nvim

```lua
{ 'fredeeb/alias.nvim' }
```

# Usage

The plugin adds a directory to your PATH environment when you start it up, so all aliases take precedence over the rest of your path, making it very useful if you want to override programs or scripts only when you are in neovim.

Some usages examples can be found below

```lua
require('alias').setup{
    -- open a file in the current neovim session to avoid nested sessions
    -- shell variable expansion works just like normal $1, $#, $@, etc.
    nvim = 'e $@'

    -- simple binding of gl to telescopes git commit log
    gl = 'Telescope git_commits',

    -- launch neogit with gs
    gs = 'Neogit'

    -- use system man or nvim man
    man = 'e man://$@'
}
```

The above config allows calling those aliases as scripts from within the neovim terminal.

```bash
$ v init.lua # opens init.lua in your current nvim session
$ gl # runs :Telescope git_commits
$ gs # runs :Neogit
$ man socket $ overrides the normal man program, due to path precedence, and calls :e man://socket
```

# Ideas

Add support for calling lua functions

# Contributing

You're always welcome to make a PR for this plugin if you have an idea for a new feature or a fix for one of my trademark bugs.
