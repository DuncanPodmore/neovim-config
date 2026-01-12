-- local ffi = require("ffi")
--
-- ffi.cdef[[
-- int add(int a, int b);
-- ]]
--
-- local lib = ffi.load(vim.fn.stdpath("config") .. "/add.so")
--
-- print(lib.add(60, 9))

-- basics
vim.cmd.colorscheme("evening")
vim.opt.termguicolors = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop=2
vim.opt.shiftwidth=2
vim.opt.softtabstop=2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- terminal settings
vim.keymap.set('t', '<ESC>', [[<C-\><C-n>]], { silent = true })

-- language settings
-- general language settings

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})
vim.diagnostic.config({
  virtual_text = true
})
local on_attach = function(_, bufnr)
  local map = vim.keymap.set
  local opts = { buffer = bufnr, silent = true }

  map("n", "gd", vim.lsp.buf.definition, opts)
  map("n", "gi", vim.lsp.buf.implementation, opts)
  map("n", "gr", vim.lsp.buf.references, opts)
  map("n", "K", vim.lsp.buf.hover, opts)
end

-- C
vim.lsp.config("clangd", {
  on_attach = on_attach
})
vim.lsp.enable("clangd")

-- C#
require("roslyn").setup({})
vim.lsp.config("roslyn", {
  on_attach = on_attach,
  cmd = {
    "dotnet",
    "/home/wanted101/.config/nvim/roslyn_server/content/LanguageServer/linux-x64/Microsoft.CodeAnalysis.LanguageServer.dll",
    "--logLevel",
    "Information",
    "--extensionLogDirectory", -- this property is required by the server
    vim.fs.joinpath(vim.uv.os_tmpdir(), "roslyn_ls/logs"),
    "--stdio",
  },
  settings = {
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
  },
})
vim.lsp.enable("roslyn")

-- javascript, typescript, angular
vim.lsp.config("ts_ls", {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
})
vim.lsp.config("eslint", {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
        -- nvim-lspconfig defines a user command 
        -- `LspEslintFixAll` :contentReference[oaicite:5]{index=5}
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "LspEslintFixAll",
    })
  end,
})
vim.lsp.config("angularls", {
    on_new_config = function(new_config, new_root_dir)
      -- Point probe locations at your workspace's node_modules
      local node_modules = new_root_dir .. "/node_modules"
      new_config.cmd = { 
        "ngserver", 
        "--stdio", 
        "--tsProbeLocations", 
        node_modules, 
        "--ngProbeLocations", 
        node_modules 
      }
    end,
  on_attach = on_attach,
})
vim.lsp.enable("ts_ls")
vim.lsp.enable("eslint")
vim.lsp.enable("angularls")
