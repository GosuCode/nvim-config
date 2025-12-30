--------------------------------------------------
-- BOOTSTRAP lazy.nvim
--------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------
-- PLUGINS (ESSENTIAL SET)
--------------------------------------------------
require("lazy").setup({

  -- Telescope (file/search brain)
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
    
      telescope.setup({
        defaults = {
          file_ignore_patterns = {
            "node_modules",
            "%.git/",
            "dist",
            "build",
            "android/build",
            ".expo",
            "ios/build",
          },
          preview = {
            treesitter = false,
          },
        },
      })
    
      -- keymaps
      vim.keymap.set("n", "<Space><Space>", builtin.find_files, { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep,     { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fb", builtin.buffers,       { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags,     { noremap = true, silent = true })
    end,    
  },

  -- Which-key (remember your own keymaps)
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end,
  },

  -- -- Terminal integration for Expo / React Native
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup{
        size = 15,
        open_mapping = [[<leader>t]],
        direction = "float",
        insert_mappings = false
      }
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- File explorer (Neo-tree)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
config = function()
  require("neo-tree").setup({
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,

    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      hijack_netrw_behavior = "open_default",
    },

    window = {
      position = "left",
      width = 30,
      mappings = {
        ["<CR>"] = "open",           -- Enter opens file
        ["l"] = "open",              -- l opens file / expands dir
        ["h"] = "close_node",        -- h collapses dir
        ["o"] = "open",
        ["a"] = "add",
        ["A"] = "add_directory",
        ["d"] = "delete",
        ["r"] = "rename",
        ["q"] = "close_window",
      },
    },

 -- Auto close tree after opening a file
    event_handlers = {
      {
        event = "file_opened",
        handler = function()
          vim.cmd("Neotree close")
        end,
      },
    },
  })

  -- Toggle explorer
  vim.keymap.set("n", "<leader>e", ":Neotree toggle left<CR>", { silent = true })
  end,
 },

  -- Japanese style colorscheme
  {
    "rebelot/kanagawa.nvim",
    config = function()
      vim.cmd("colorscheme kanagawa")
    end,
  },

  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "javascript", "typescript", "python", "rust", "go", "java" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Code formatter
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          rust = { "rustfmt" },
          go = { "gofmt" },
          java = { "google-java-format" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })

      -- Format keymaps
      vim.keymap.set("n", "<leader>fm", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format file" })
    end,
  },

  -- Opencode ai
{
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for `snacks` provider.
    ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    -- Recommended/example keymaps.
    vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
    vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })

    vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { expr = true, desc = "Add range to opencode" })
    vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { expr = true, desc = "Add line to opencode" })

    vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "opencode half page up" })
    vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "opencode half page down" })

    -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
  end,
}

})
