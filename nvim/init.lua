-- Plain Neovim 0.12+ config. Plugins via built-in vim.pack, LSP via vim.lsp.config/enable.
-- Ported from old kickstart.nvim setup (~/old-dotfiles/.config/nvim/init.lua).

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- [[ Options ]]
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.showmode = false
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10

-- Completion: built-in autocompletion. "o" = omnifunc, which LSP sets to vim.lsp.omnifunc.
vim.o.autocomplete = true
vim.o.complete = "o,.^5,w^5,b^5,u^5"
vim.o.completeopt = "menu,menuone,noinsert,popup"

-- Nvim 0.11+ no longer shows diagnostics as virtual text by default; restore old behavior.
vim.diagnostic.config({ virtual_text = true })

-- [[ Keymaps ]]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Snippet jumps (same keys as the old nvim-cmp/LuaSnip setup; <Tab>/<S-Tab> also work by default)
vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if vim.snippet.active({ direction = 1 }) then
    vim.snippet.jump(1)
  end
end, { desc = "Snippet: jump forward" })
vim.keymap.set({ "i", "s" }, "<C-h>", function()
  if vim.snippet.active({ direction = -1 }) then
    vim.snippet.jump(-1)
  end
end, { desc = "Snippet: jump backward" })

-- Copy `path:line` (or `path:start-end` in visual mode) to the clipboard, to paste into an agent prompt.
-- Path is relative to nvim's cwd.
vim.keymap.set({ "n", "x" }, "<leader>y", function()
  local path = vim.fn.expand("%:.")
  if path == "" then
    return
  end
  local first, last = vim.fn.line("v"), vim.fn.line(".")
  if first > last then
    first, last = last, first
  end
  local ref = (vim.fn.mode():match("[vV\22]") and first ~= last) and ("%s:%d-%d"):format(path, first, last)
    or ("%s:%d"):format(path, last)
  vim.fn.setreg("+", ref)
  if vim.fn.mode():match("[vV\22]") then
    vim.cmd("normal! \27")
  end
  vim.notify("Copied " .. ref)
end, { desc = "[Y]ank file:line reference" })

-- [[ Autocmds ]]
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  desc = "Reload files changed outside nvim (e.g. by an agent)",
  group = vim.api.nvim_create_augroup("user-checktime", { clear = true }),
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("user-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Plugins ]]
-- Build hooks must be registered before vim.pack.add() so they also run on install.
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("user-pack-hooks", { clear = true }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  "https://github.com/rktjmp/lush.nvim",
  "https://github.com/zenbones-theme/zenbones.nvim",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/tpope/vim-sleuth",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/nvim-lua/plenary.nvim", -- required by yazi.nvim
  "https://github.com/mikavilpas/yazi.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
}, { confirm = false })

-- Colorscheme
vim.g.zenbones_darken_comments = 45
vim.cmd.colorscheme("zenbones")

-- Git signs in the gutter
require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    vim.keymap.set("n", "]h", function()
      gs.nav_hunk("next")
    end, { buffer = bufnr, desc = "Next git [h]unk" })
    vim.keymap.set("n", "[h", function()
      gs.nav_hunk("prev")
    end, { buffer = bufnr, desc = "Previous git [h]unk" })
  end,
})

-- Pending keybind hints
require("which-key").setup({
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { "<leader>s", group = "[S]earch" },
    { "<leader>t", group = "[T]oggle" },
  },
})

-- [[ mini.nvim ]]
require("mini.icons").setup()
require("mini.ai").setup({ n_lines = 500 })
require("mini.surround").setup()

local statusline = require("mini.statusline")
statusline.setup({ use_icons = vim.g.have_nerd_font })
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return "%2l:%-2v"
end

-- Fuzzy finder (replaces telescope). Also replaces vim.ui.select.
require("mini.pick").setup()
require("mini.extra").setup()
local pick, extra = MiniPick.builtin, MiniExtra.pickers
local map = vim.keymap.set
map("n", "<leader>sh", pick.help, { desc = "[S]earch [H]elp" })
map("n", "<leader>sk", extra.keymaps, { desc = "[S]earch [K]eymaps" })
map("n", "<leader>sf", pick.files, { desc = "[S]earch [F]iles" })
map("n", "<leader>sw", function()
  pick.grep({ pattern = vim.fn.expand("<cword>") })
end, { desc = "[S]earch current [W]ord" })
map("n", "<leader>sg", pick.grep_live, { desc = "[S]earch by [G]rep" })
map("n", "<leader>sd", extra.diagnostic, { desc = "[S]earch [D]iagnostics" })
map("n", "<leader>sr", pick.resume, { desc = "[S]earch [R]esume" })
map("n", "<leader>s.", extra.oldfiles, { desc = "[S]earch Recent Files" })
map("n", "<leader><leader>", pick.buffers, { desc = "[ ] Find existing buffers" })
map("n", "<leader>/", function()
  extra.buf_lines({ scope = "current" })
end, { desc = "[/] Fuzzily search in current buffer" })
map("n", "<leader>s/", function()
  extra.buf_lines({ scope = "all" })
end, { desc = "[S]earch [/] in Open Buffers" })
map("n", "<leader>sn", function()
  pick.files(nil, { source = { cwd = vim.fn.stdpath("config") } })
end, { desc = "[S]earch [N]eovim files" })

-- [[ File explorer: yazi (binary in ~/.local/bin) ]]
-- `\` opens it at the current file; `q` closes, <F1> shows yazi.nvim's keys.
-- Also opens for directories (`nvim .`, `:e dir/`) instead of netrw. Per yazi.nvim's README
-- (no lazy.nvim): disable netrw up front and run setup on UIEnter.
vim.g.loaded_netrwPlugin = 1
vim.api.nvim_create_autocmd("UIEnter", {
  group = vim.api.nvim_create_augroup("user-yazi", { clear = true }),
  once = true,
  callback = function()
    require("yazi").setup({
      open_for_directories = true,
      integrations = {
        -- yazi.nvim defaults to telescope for <c-s>; use mini.pick instead. Paths are relative to cwd.
        grep_in_directory = function(directory)
          MiniPick.builtin.grep_live(nil, { source = { cwd = directory } })
        end,
        grep_in_selected_files = function(files)
          MiniPick.builtin.grep_live({ globs = files })
        end,
      },
    })
  end,
})
vim.keymap.set({ "n", "v" }, "\\", function()
  require("yazi").yazi()
end, { desc = "File explorer (yazi)" })

-- [[ Treesitter ]]
local parsers = {
  "bash",
  "c",
  "css",
  "diff",
  "html",
  "javascript",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
}

-- Needs the `tree-sitter` CLI (installed by mason below) and a C compiler. No-op when already installed.
local function install_parsers()
  if vim.fn.executable("tree-sitter") == 1 then
    require("nvim-treesitter").install(parsers)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable treesitter highlighting and indent when a parser exists",
  group = vim.api.nvim_create_augroup("user-treesitter", { clear = true }),
  callback = function(args)
    if pcall(vim.treesitter.start, args.buf) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- [[ Mason: external tools (LSP servers, formatters, tree-sitter CLI) ]]
-- Adds mason's bin dir to PATH, so this must run before any LSP server starts.
require("mason").setup()

local mason_packages = {
  "tree-sitter-cli",
  "lua-language-server",
  "stylua",
  "basedpyright",
  "ruff",
  "typescript-language-server",
  "html-lsp",
  "css-lsp",
  "eslint-lsp",
  "prettier",
}

-- Run :InstallTools once on a new machine (and after adding entries above). Nothing is checked at startup.
vim.api.nvim_create_user_command("InstallTools", function()
  local registry = require("mason-registry")
  registry.refresh(function()
    for _, name in ipairs(mason_packages) do
      local pkg = registry.get_package(name)
      if not pkg:is_installed() and not pkg:is_installing() then
        pkg:install(
          {},
          vim.schedule_wrap(function(success, err)
            if not success then
              vim.notify(("mason: failed to install %s: %s"):format(name, vim.inspect(err)), vim.log.levels.ERROR)
            elseif name == "tree-sitter-cli" then
              install_parsers()
            end
          end)
        )
      end
    end
  end)
  install_parsers()
end, { desc = "Install missing mason tools and treesitter parsers" })

-- [[ LSP ]]
require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      completion = { callSnippet = "Replace" },
    },
  },
})

-- basedpyright only speaks UTF-16 positions; make ruff use the same on shared Python buffers.
vim.lsp.config("ruff", {
  capabilities = { general = { positionEncodings = { "utf-16" } } },
})

vim.lsp.enable({ "lua_ls", "basedpyright", "ruff", "ts_ls", "html", "cssls", "eslint" })

-- Built-in defaults already cover: grn rename, gra code action, grr references,
-- gri implementation, grt type definition, gO document symbols, CTRL-S signature help.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
  callback = function(event)
    local buf = event.buf
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
    local function lmap(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = buf, desc = "LSP: " .. desc })
    end

    lmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    lmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    lmap("<leader>ws", function()
      extra.lsp({ scope = "workspace_symbol_live" })
    end, "[W]orkspace [S]ymbols")

    -- Lets <C-y> apply snippets, auto-imports and other side effects of a completion item.
    if client:supports_method("textDocument/completion", buf) then
      vim.lsp.completion.enable(true, client.id, buf)
      vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get, { buffer = buf, desc = "LSP: Trigger completion" })
    end

    if client:supports_method("textDocument/documentHighlight", buf) then
      local hl_group = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = buf,
        group = hl_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = buf,
        group = hl_group,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "user-lsp-highlight", buffer = event2.buf })
        end,
      })
    end

    if client:supports_method("textDocument/inlayHint", buf) then
      lmap("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }))
      end, "[T]oggle Inlay [H]ints")
    end
  end,
})

-- [[ Formatting ]]
-- Format on save only in projects that have the formatter's own config file, and never via LSP.

-- conform's default ruff root also accepts a pyproject.toml without any ruff config; require [tool.ruff].
local function ruff_root(_, ctx)
  return vim.fs.root(ctx.dirname, function(name, path)
    if name == "ruff.toml" or name == ".ruff.toml" then
      return true
    end
    if name == "pyproject.toml" then
      for line in io.lines(vim.fs.joinpath(path, name)) do
        if line:match("^%[tool%.ruff") then
          return true
        end
      end
    end
    return false
  end)
end

local prettier = { "prettier" }
require("conform").setup({
  notify_on_error = false,
  format_on_save = { timeout_ms = 500, lsp_format = "never" },
  formatters = {
    prettier = { require_cwd = true }, -- .prettierrc*, prettier.config.*, or "prettier" key in package.json
    stylua = { require_cwd = true }, -- stylua.toml / .stylua.toml
    ruff_format = { cwd = ruff_root, require_cwd = true },
  },
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    javascript = prettier,
    javascriptreact = prettier,
    typescript = prettier,
    typescriptreact = prettier,
    html = prettier,
    css = prettier,
    json = prettier,
  },
})
vim.keymap.set("", "<leader>f", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })
