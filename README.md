# 🧰 toolbox.nvim

> "A man is only as good as his tools."
>
> -- <cite>Emmert Wolf</cite>

# 🛠️ Tools

- Semantic Version Incrementer
    - searches the current line for a semantic version and quickly increases the major, minor, or patch version
    - automatically resets the lower versions as needed
    - accepts a count as the increment by which to increase the version (default 1)
- Npm Install/Run
    - shortcut to run `npm i` from within a `package.json` file
    - runs the command from the current file's directory
    - has a `package` mode that will prompt the user for a space-separated list of packages
    - adds a telescope picker to choose a script to run in a split terminal
- Multi-Language Variable Logger
    - quickly add a log/print statement below the current line for the selected text or the current word under the cursor
    - configurable for different languages based on file type
        - can configure a mapping to point different file types to the desired language (e.g jsx -> js)
    - supports configuring print statements for different log levels within a language [debug|info|warn|error]
- JSON Formatter
    - format, parse, or stringify JSON
    - supports character/line visual selection, defaults to entire buffer when not in visual mode
- Diff Checker
    - opens two floating windows to compare text with
    - can toggle diff mode on/off to paste or edit text
    - avoid sharing sensitive data with sketchy websites
- Floaterminal*
    - open a floating window with persistent terminal for running cli commands
    - *shamelessly taken from TJ

# Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{ 
  'wet-sandwich/toolbox.nvim',
  dependencies = {
      "L3MON4D3/LuaSnip",
      "nvim-telescope/telescope.nvim",
  },
}
```

# Setup

Currently only the variable logging tool has any configuration.

```lua
require("toolbox").setup({
  logger = {
    language_map = {
      javascriptreact = "javascript",
      typescript = "javascript",
      typescriptreact = "javascript",
    },
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
:TBNpmRun
:TBLogVariable
:TBJson
:TBDiffChecker
:TBFloaterminal
```

Commands can be called directly with the appropriate arguments or used to create keymaps in your config.

```lua
vim.keymap.set("n", "<C-M-m>", "<cmd>TBIncSemver major<cr>", { desc = "Increment [M]ajor version" })
vim.keymap.set("n", "<C-M-n>", "<cmd>TBIncSemver minor<cr>", { desc = "Increment mi[N]or version" })
vim.keymap.set("n", "<C-M-p>", "<cmd>TBIncSemver patch<cr>", { desc = "Increment [P]atch version" })

vim.keymap.set("n", "<leader>ni", "<cmd>TBNpmInstall all<cr>", { desc = "Run [N]pm [I]nstall" })
vim.keymap.set("n", "<leader>np", "<cmd>TBNpmInstall package<cr>", { desc = "Run [N]pm install [P]ackage" })
vim.keymap.set("n", "<leader>nr", "<cmd>TBNpmRun<cr>", { desc = "[N]pm [R]un script" })

vim.keymap.set({"n", "v"}, "<leader>li", "<cmd>TBLogVariable info<cr>", { desc = "[L]og variable [I]nfo" })
vim.keymap.set({"n", "v"}, "<leader>ld", "<cmd>TBLogVariable debug<cr>", { desc = "[L]og variable [D]ebug" })
vim.keymap.set({"n", "v"}, "<leader>lw", "<cmd>TBLogVariable warn<cr>", { desc = "[L]og variable [W]arn" })
vim.keymap.set({"n", "v"}, "<leader>le", "<cmd>TBLogVariable error<cr>", { desc = "[L]og variable [E]rror" })

vim.keymap.set({ "n", "v" }, "<leader>jf", "<cmd>TBJson format<cr>", { desc = "[J]SON [F]ormat" })
vim.keymap.set({ "n", "v" }, "<leader>jp", "<cmd>TBJson parse<cr>", { desc = "[J]SON [P]arse" })
vim.keymap.set({ "n", "v" }, "<leader>js", "<cmd>TBJson stringify<cr>", { desc = "[J]SON [S]tringify" })

vim.keymap.set("n", "<leader>dc", "<cmd>TBDiffChecker<cr>", { desc = "Open [D]iff [C]hecker" })

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
vim.keymap.set({ "n", "t" }, "<leader>te", "<cmd>TBFloaterminal<cr>", { desc = "[T]oggle t[E]rminal" })
```
