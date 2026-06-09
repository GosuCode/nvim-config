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
			vim.keymap.set("n", "<Space><Space>", function()
				builtin.find_files({ hidden = true, no_ignore = true })
			end, { noremap = true, silent = true, desc = "Find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { noremap = true, silent = true, desc = "Live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { noremap = true, silent = true, desc = "Buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { noremap = true, silent = true, desc = "Help tags" })
		end,
	},

	-- Which-key (remember your own keymaps)
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({
				icons = {
					provider = "nvim-web-devicons",
				},
				preset = "helix",
				layout = {
					align = "left",
					spacing = 1,
				},
				win = {
					border = "rounded",
					padding = { 1, 2 },
					wo = {
						winblend = 10,
					},
				},
			})
			require("which-key").add({
				{ "<leader>f", group = "Find" },
				{ "<leader>g", group = "Git" },
				{ "<leader>d", group = "Debug" },
				{ "<leader>r", group = "Run" },
				{ "<leader>o", group = "Open" },
				{ "<leader>x", group = "Diagnostics" },
				{ "<leader>h", group = "Harpoon" },
				{ "<leader>m", group = "Markdown" },
				{ "<leader>z", group = "Zen" },
				{ "<leader>u", group = "Toggle" },
			})
		end,
	},

	-- -- Terminal integration for Expo / React Native
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = 15,
				open_mapping = [[<leader>t]],
				direction = "float",
				insert_mappings = false,
			})
		end,
	},

	-- Git signs
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- Git UI (LazyGit inside Neovim)
	{
		"kdheepak/lazygit.nvim",
		dependencies = { "akinsho/toggleterm.nvim" },
		config = function()
			vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })
		end,
	},

	-- Side-by-side diff view
	{
		"sindrets/diffview.nvim",
		config = function()
			vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Open Diffview" })
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
					filtered_items = {
						visible = true,
						show_hidden_count = true,
						hide_dotfiles = false,
						hide_gitignored = true,
						never_show = {
							".git",
							"node_modules",
							"dist",
							".vite",
							".next",
							".vscode",
						},
					},
				},

				window = {
					position = "left",
					width = 30,
					mappings = {
						["<CR>"] = "open", -- Enter opens file
						["l"] = "open", -- l opens file / expands dir
						["h"] = "close_node", -- h collapses dir
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
			vim.keymap.set("n", "<leader>fe", ":Neotree toggle left<CR>", { silent = true, desc = "File explorer" })
		end,
	},

	-- Japanese style colorscheme
	{
		"rebelot/kanagawa.nvim",
		config = function()
			vim.cmd("colorscheme kanagawa")
		end,
	},

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("lualine").setup({
				options = {
					theme = "kanagawa",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	-- Tabline (file tabs at top)
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers",
					separator_style = "slant",
					show_buffer_close_icons = false,
					show_close_icon = false,
				},
			})
			vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
			vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
			vim.keymap.set("n", "<C-Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
			vim.keymap.set("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
		end,
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		config = function()
			require("ibl").setup({
				indent = { char = "│" },
				scope = { enabled = false },
			})
		end,
	},

	-- Better command line + notifications
	{
		"folke/noice.nvim",
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		event = "VeryLazy",
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						"vim.lsp.util.convert_input_to_markdown_lines",
						"vim.lsp.util.stylize_markdown",
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					lsp_doc_border = true,
				},
				views = {
					cmdline_popup = {
						position = {
							row = 5,
							col = "50%",
						},
						size = {
							min_width = 60,
							width = "auto",
							height = "auto",
						},
					},
					popupmenu = {
						relative = "editor",
						position = {
							row = 8,
							col = "50%",
						},
						size = {
							width = 60,
							max_width = 80,
							height = "auto",
							max_height = 15,
						},
						border = {
							style = "rounded",
							padding = { 0, 1 },
						},
						win_options = {
							winhighlight = { Normal = "NormalFloat", FloatBorder = "FloatBorder" },
						},
					},
				},
			})
		end,
	},

	-- Diagnostics list (Trouble)
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("trouble").setup()
			vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Toggle Trouble" })
		end,
	},

	-- Treesitter for better syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.config").setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"javascript",
					"typescript",
					"python",
					"rust",
					"go",
					"java",
					"markdown",
					"markdown_inline",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- LSP server manager
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	-- Auto-install LSP servers via Mason
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls",
					"eslint",
					"tailwindcss",
					"nextls",
					"prismals",
					"graphql",
					"sqlls",
					"html",
					"cssls",
					"jsonls",
					"dockerls",
					"yamlls",
					"bashls",
					"pyright",
					"lua_ls",
					"vimls",
					"marksman",
					"docker_compose_language_service",
					"terraformls",
					"jdtls",
				},
				automatic_installation = true,
			})
		end,
	},

	-- LSP configurations
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("config.lsp").setup()
		end,
	},

	-- Debugger
	{
		"mfussenegger/nvim-dap",
		config = function()
			vim.keymap.set("n", "<leader>db", function()
				require("dap").toggle_breakpoint()
			end, { desc = "Toggle breakpoint" })
			vim.keymap.set("n", "<leader>dc", function()
				require("dap").continue()
			end, { desc = "Debug continue" })
			vim.keymap.set("n", "<leader>do", function()
				require("dap").step_over()
			end, { desc = "Debug step over" })
			vim.keymap.set("n", "<leader>di", function()
				require("dap").step_into()
			end, { desc = "Debug step into" })
			vim.keymap.set("n", "<leader>du", function()
				require("dap").step_out()
			end, { desc = "Debug step out" })
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()
			dap.listeners.before.attach.dapui = dapui.open
			dap.listeners.before.launch.dapui = dapui.open
			dap.listeners.before.event_terminated.dapui = dapui.close
			dap.listeners.before.event_exited.dapui = dapui.close
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "node2", "python" },
				automatic_installation = true,
			})
		end,
	},

	-- Commenting (super fast toggle with gcc, gc in visual, etc.)
	{
		"numToStr/Comment.nvim",
		event = "BufReadPost", -- Lazy-load after reading a file
		config = true, -- Uses default setup, which is perfect
	},

	-- Autopairs (auto-close (), [], {}, "", etc.)
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
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
					go = { "gofmt" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
				-- Enable automatic line breaking
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
				formatters = {
					prettier = {
						args = { "--tab-width=2", "--use-tabs=false", "--print-width=80" },
					},
					stylua = {
						args = { "--column-width=120", "--line-endings=Unix" },
					},
				},
			})

			-- Format keymaps
			vim.keymap.set("n", "<leader>fm", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "Format file" })

			-- Toggle auto-format
			vim.keymap.set("n", "<leader>uf", function()
				vim.g.autoformat = not vim.g.autoformat
				local msg = vim.g.autoformat and "Auto-format enabled" or "Auto-format disabled"
				vim.notify(msg, vim.log.levels.INFO)
			end, { desc = "Toggle auto-format" })
		end,
	},

	-- Opencode ai
	{
		"NickvanDyke/opencode.nvim",
		dependencies = {
			-- Recommended for `ask()` and `select()`.
			-- Required for `snacks` provider.
			---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
			{ "folke/snacks.nvim", lazy = false, priority = 1000, opts = { input = {}, picker = {}, terminal = {} } },
		},
		config = function()
			---@type opencode.Opts
			vim.g.opencode_opts = {
				-- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
			}

			-- Required for `opts.events.reload`.
			vim.o.autoread = true

			-- Recommended/example keymaps.
			vim.keymap.set({ "n", "x" }, "<C-a>", function()
				require("opencode").ask("@this: ", { submit = true })
			end, { desc = "OpenCode ask" })
			vim.keymap.set({ "n", "x" }, "<C-x>", function()
				require("opencode").select()
			end, { desc = "OpenCode action" })
			vim.keymap.set({ "n", "t" }, "<C-.>", function()
				require("opencode").toggle()
			end, { desc = "OpenCode toggle" })

			vim.keymap.set({ "n", "x" }, "go", function()
				return require("opencode").operator("@this ")
			end, { expr = true, desc = "OpenCode add range" })
			vim.keymap.set("n", "goo", function()
				return require("opencode").operator("@this ") .. "_"
			end, { expr = true, desc = "OpenCode add line" })

			vim.keymap.set("n", "<S-C-u>", function()
				require("opencode").command("session.half.page.up")
			end, { desc = "OpenCode half page up" })
			vim.keymap.set("n", "<S-C-d>", function()
				require("opencode").command("session.half.page.down")
			end, { desc = "OpenCode half page down" })

			-- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
			vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
			vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
		end,
	},

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():append()
			end, { desc = "Harpoon add" })
			vim.keymap.set("n", "<leader>hh", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Harpoon menu" })

			vim.keymap.set("n", "<leader>1", function()
				harpoon:list():select(1)
			end, { desc = "Harpoon 1" })
			vim.keymap.set("n", "<leader>2", function()
				harpoon:list():select(2)
			end, { desc = "Harpoon 2" })
			vim.keymap.set("n", "<leader>3", function()
				harpoon:list():select(3)
			end, { desc = "Harpoon 3" })
			vim.keymap.set("n", "<leader>4", function()
				harpoon:list():select(4)
			end, { desc = "Harpoon 4" })
		end,
	},

	-- Highlight TODO/FIXME/HACK comments
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufReadPost",
		config = function()
			require("todo-comments").setup({
				signs = true,
				keywords = {
					FIX = { icon = "", color = "error" },
					TODO = { icon = "", color = "info" },
					HACK = { icon = "", color = "warning" },
					NOTE = { icon = "", color = "hint" },
				},
			})
		end,
	},

	-- Lightning-fast cursor jumps
	{
		url = "https://codeberg.org/andyg/leap.nvim",
		config = function()
			vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap forward" })
			vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward" })
			vim.keymap.set("n", "gs", "<Plug>(leap-from-window)", { desc = "Leap from window" })
		end,
	},

	-- Code outline sidebar
	{
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup({
				backends = { "lsp", "treesitter", "markdown" },
				show_guides = true,
			})
			vim.keymap.set("n", "<leader>os", "<cmd>AerialToggle<CR>", { desc = "Toggle Outline" })
		end,
	},

	-- HTTP / REST client
	{
		"rest-nvim/rest.nvim",
		ft = "http",
		config = function()
			require("rest-nvim").setup({
				result_split_in_place = true,
				stick_with_host = true,
			})
		end,
	},

	-- Task runner (npm test, docker build, terraform plan, etc.)
	{
		"stevearc/overseer.nvim",
		config = function()
			require("overseer").setup({
				task_list = { direction = "bottom", bindings = { ["q"] = "Close" } },
			})
			vim.keymap.set("n", "<leader>rr", "<cmd>OverseerRun<CR>", { desc = "Run Task" })
			vim.keymap.set("n", "<leader>rl", "<cmd>OverseerToggle<CR>", { desc = "Task List" })
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				completion = { completeopt = "menu,menuone,noinsert" },

				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),

					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					["<CR>"] = cmp.mapping.confirm({ select = true }),

					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),

					["<C-Space>"] = cmp.mapping.complete(),

					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),

					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),

				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				},
			})
		end,
	},

	-- Inline markdown rendering
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		config = function()
			local render = require("render-markdown")
			render.setup({
				file_types = { "markdown" },
			})
			vim.keymap.set("n", "<leader>md", function()
				render.toggle()
			end, { desc = "Markdown render toggle" })
			local group = vim.api.nvim_create_augroup("RenderMarkdownUser", { clear = true })
			vim.api.nvim_create_autocmd("InsertEnter", {
				group = group,
				pattern = "*.md",
				callback = function()
					render.disable()
				end,
			})
			vim.api.nvim_create_autocmd("InsertLeave", {
				group = group,
				pattern = "*.md",
				callback = function()
					render.enable()
				end,
			})
		end,
	},

	{
		"folke/snacks.nvim",
		opts = {
			scroll = { enabled = false },
			dashboard = {
				preset = {
					header = [[
░█▀▀░█▀█░█▀▀░█░█░█▀▀░█▀█░█▀▄░█▀▀
░█░█░█░█░▀▀█░█░█░█░░░█░█░█░█░█▀▀
░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀▀░░▀▀▀
   ]],
				},
			},
		},
		keys = {},
	},
})
