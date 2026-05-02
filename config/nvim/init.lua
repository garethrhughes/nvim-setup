-- Entry point: load core settings, then hand off to lazy.nvim

require("core.options")
require("core.keymaps")
require("core.autocmds")
require("lazy")
