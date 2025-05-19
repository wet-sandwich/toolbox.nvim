# toolbox.nvim

> "A man is only as good as his tools."
>
> -- <cite>Emmert Wolf</cite>

# Features

- Semantic Version Incrementer
    - searches the current line for a semantic version and quickly increases the major, minor, or patch version
    - automatically resets the lower versions as needed
    - accepts a count as the increment by which to increase (default 1)
- Npm Install
    - shortcut to run `npm i` from within a `package.json` file
    - runs the command from the current file's directory
    - has a `package` mode that will prompt the user for a space-separated list of packages
- Multi-Language Variable Logger
    - quickly add a log/print statement of the current word under the cursor below the current line
    - configurable for different languages based on file type
        - can configure a mapping to point different file types to the desired language (e.g jsx -> js)
    - supports configuring print statements of different log levels within a language [debug|info|warn|error]

# Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{ 
  'wet-sandwich/toolbox.nvim'
}
```

# Setup

Currently only the variable logging tool has any configuration.

```lua
require("toolbox").setup({
  logger = {
    print_statements = {
      lua = {
        info = 'print("%s:", vim.inspect(%s))',
        debug = 'print("***DEBUG*** %s:", vim.inspect(%s))',
        warn = 'vim.notify("%s:" .. vim.inspect(%s), vim.log.levels.WARN)',
        error = 'vim.notify("%s:" .. vim.inspect(%s), vim.log.levels.ERROR)',
      },
    },
  },
})
```

# Usage

`toolbox.nvim` creates the following user commands:

```vim
:TBIncSemver
:TBNpmInstall
:TBLogVariable
```

Commands can be called directly with the appropriate arguments or used to create keymaps in your config.

```lua
vim.keymap.set("n", "<C-M-m>", "<cmd>TBIncSemver major<cr>", { desc = "Increment [M]ajor version" })
vim.keymap.set("n", "<C-M-n>", "<cmd>TBIncSemver minor<cr>", { desc = "Increment mi[N]or version" })
vim.keymap.set("n", "<C-M-p>", "<cmd>TBIncSemver patch<cr>", { desc = "Increment [P]atch version" })

vim.keymap.set("n", "<leader>ni", "<cmd>TBNpmInstall all<cr>", { desc = "Run [N]pm [I]nstall" })
vim.keymap.set("n", "<leader>np", "<cmd>TBNpmInstall package<cr>", { desc = "Run [N]pm install [P]ackage" })

vim.keymap.set("n", "<leader>li", "<cmd>TBLogVariable info<cr>", { desc = "[L]og variable [I]nfo" })
vim.keymap.set("n", "<leader>ld", "<cmd>TBLogVariable debug<cr>", { desc = "[L]og variable [D]ebug" })
vim.keymap.set("n", "<leader>lw", "<cmd>TBLogVariable warn<cr>", { desc = "[L]og variable [W]arn" })
vim.keymap.set("n", "<leader>le", "<cmd>TBLogVariable error<cr>", { desc = "[L]og variable [E]rror" })
```
