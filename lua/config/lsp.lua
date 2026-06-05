--------------------------------------------------
-- LSP CONFIGURATION
--------------------------------------------------
local M = {}

function M.setup()
  vim.filetype.add({
    pattern = {
      [".*docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
      [".*gitlab%-ci.*%.ya?ml"] = "yaml.gitlab",
      ["values%.ya?ml"] = "yaml.helm-values",
      [".*%.astro"] = "astro",
      [".*%.edge"] = "edge",
      [".*%.ejs"] = "ejs",
      [".*%.erb"] = "erb",
      [".*%.gohtml"] = "gohtml",
      [".*%.hbs"] = "handlebars",
      [".*%.heex"] = "heex",
      [".*%.jade"] = "jade",
      [".*%.leaf"] = "leaf",
      [".*%.mdx"] = "markdown.mdx",
      [".*%.njk"] = "njk",
      [".*%.nunjucks"] = "nunjucks",
      [".*%.slim"] = "slim",
      [".*%.pcss"] = "postcss",
      [".*%.postcss"] = "postcss",
      [".*%.sss"] = "sugarss",
      [".*%.cshtml"] = "aspnetcorerazor",
      [".*%.razor"] = "aspnetcorerazor",
      [".*%.re"] = "reason",
    },
    extension = {
      djangohtml = "django-html",
      gohtmltmpl = "gohtmltmpl",
      hbs = "hbs",
      mdx = "mdx",
      ["astro-markdown"] = "astro-markdown",
      ["html-eex"] = "html-eex",
    },
  })

  local servers = {
    -- MERN Core
    "ts_ls",             -- TypeScript/JavaScript (Node.js, React, etc.)
    "eslint",            -- Linting
    "tailwindcss",       -- Tailwind CSS intellisense
    "nextls",            -- Next.js
    "prismals",          -- Prisma ORM
    "graphql",           -- GraphQL
    "sqlls",             -- SQL
    "html",              -- HTML
    "cssls",             -- CSS
    "jsonls",            -- JSON

    -- DevOps Essentials
    "dockerls",          -- Dockerfiles
    "yamlls",            -- YAML (Kubernetes, CI/CD configs)
    "bashls",            -- Shell scripts

    -- Scripting & Config
    "pyright",           -- Python
    "lua_ls",            -- Lua (Neovim config)
    "vimls",             -- Vimscript

    -- Docs & Infrastructure
    "marksman",          -- Markdown
    "docker_compose_language_service", -- Docker Compose
    "terraformls",       -- Terraform

    -- Java
    "jdtls",             -- Java (Eclipse JDT LS)
  }

  for _, server in ipairs(servers) do
    vim.lsp.config[server] = {
      capabilities = require("config.lsp.capabilities").get_capabilities(),
      on_attach = require("config.lsp.capabilities").on_attach,
    }
  end

  vim.lsp.enable(servers)
end

return M
