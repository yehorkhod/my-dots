-- General options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.undodir"
vim.opt.wrap = false
vim.opt.guicursor = ""
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 5
vim.opt.colorcolumn = "80"

vim.g.mapleader = " "


-- Clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P')
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d')


-- Packages
vim.pack.add({
    { src = "https://github.com/rose-pine/neovim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/Vigemus/iron.nvim" },
    { src = "https://github.com/laytan/cloak.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/norcalli/nvim-colorizer.lua" },
})

-- 1
require("rose-pine").setup({ styles = { transperency = true } })
vim.cmd("colorscheme rose-pine-moon")

-- 2
require("oil").setup({ view_options = { show_hidden = true } })
vim.keymap.set("n", "-", ":Oil<CR>")

-- 3
require("iron.core").setup({
	config = {
		scratch_repl = true,
		repl_definition = {
			sh = { command = { "bash" } },
			python = {
				command = { "ipython", "--no-autoindent", "-i" },
				format = require("iron.fts.common").bracketed_paste_python,
			},
		},
		repl_open_cmd = require("iron.view").split.rightbelow(0.3),
	},
	keymaps = {
		visual_send = "<leader>is",
		send_file = "<leader>if",
		send_line = "<leader>il",
		send_until_cursor = "<leader>iu",
	},
	highlight = { italic = true },
	ignore_blank_lines = true,
})
vim.keymap.set("n", "<leader>iS", ":IronRepl<CR>")
vim.keymap.set("n", "<leader>iF", ":IronFocus<CR>")
vim.keymap.set("n", "<leader>iH", ":IronHide<CR>")

-- 4
require("cloak").setup({
    enabled = true;
    cloak_character = "*",
	highlight_group = "Comment",
	patterns = {
		{ file_pattern = ".env*", cloak_pattern = "=.+", replace = nil },
	},
})

-- 5
local pick = require("mini.pick")
pick.setup()
vim.keymap.set("n", "<leader>f", pick.builtin.files)
vim.keymap.set("n", "<leader>/", pick.builtin.grep_live)

-- 6
local gitsigns = require("gitsigns")
gitsigns.setup()
vim.keymap.set("n", "<leader>gd", gitsigns.diffthis)
vim.keymap.set("n", "<leader>gb", gitsigns.blame_line)

-- 7
require("colorizer").setup()


-- Terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.opt.nu = false
		vim.opt.relativenumber = false
	end,
})


-- Latex
local zathura_launched = false

vim.keymap.set('n', '<leader>l', function()
  vim.cmd("w")
  local file = vim.fn.expand('%:p')
  if file == "" then
    print("No file to compile!")
    return
  end

  local pdf_file = vim.fn.expand('%:r') .. ".pdf"
  local cmd = "xelatex " .. file
  print("Running: " .. cmd)
  vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    print("Compilation failed! Check the output.")
  else
    print("Compilation successful!")
    if zathura_launched == false then
      local open_cmd = "zathura " .. pdf_file .. " &"
      os.execute(open_cmd)
      print("Opened PDF in Zathura!")
      zathura_launched = true
    end
  end
end)
