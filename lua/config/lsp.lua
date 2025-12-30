--------------------------------------------------
-- LSP CONFIGURATION
--------------------------------------------------
local mason = require("mason")

-- Setup mason
mason.setup()

-- LSP servers for JavaScript/TypeScript
local servers = {
  "ts_ls",             -- TypeScript language server (new name)
  "eslint",            -- ESLint for linting
  "jsonls",            -- JSON language server
  "html",              -- HTML language server
  "cssls",             -- CSS language server
}

-- Setup LSP servers using vim.lsp.config
for _, server in ipairs(servers) do
  vim.lsp.config[server] = {
    capabilities = require("config.lsp.capabilities").get_capabilities(),
    on_attach = require("config.lsp.capabilities").on_attach,
  }
end

-- Export setup function
local M = {}
function M.setup()
  -- Mason will auto-install servers when needed
end

return M