local options = vim.opt

-- line numbers
options.relativenumber = true
options.number = true

-- tabs & indentation
options.tabstop = 2
options.shiftwidth = 2
options.expandtab = true
options.autoindent = true

-- line wrapping
options.wrap = false

-- search settings
options.ignorecase = true
options.smartcase = true

-- appearance
options.termguicolors = true

-- backspace
options.backspace = "indent,eol,start"

-- clipboard
options.clipboard:append("unnamedplus")

options.iskeyword:append("-")


