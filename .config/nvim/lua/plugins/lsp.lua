return {
  "neovim/nvim-lspconfig",
  event = { "BufNewFile", "BufRead", "BufWritePost", "BufReadPost", "InsertLeave" },
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "b0o/schemastore.nvim" },
    { "onsails/lspkind.nvim" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
  },
  config = function()
    ----------------------------------
    -- nvim-cmp
    ----------------------------------
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_snipmate").lazy_load()

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<F5>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({
          select = true,
        }),
        ["<C-p>"] = cmp.mapping.abort(),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        {
          name = "nvim_lsp",
          option = {
            markdown_oxide = {
              keyword_pattern = [[\(\k\| \|\/\|#\)\+]],
            },
          },
        },
        { name = "copilot" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        { name = "lazydev", group_index = 0 },
      }),
      formatting = {
        format = function(entry, item)
          local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
          item = require("lspkind").cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
            show_labelDetails = true,
            symbol_map = { Copilot = "" }
          })(entry, item)
          if color_item.abbr_hl_group then
            item.kind_hl_group = color_item.abbr_hl_group
            item.kind = color_item.abbr
          end
          return item
        end,
      },
    })

    cmp.setup.cmdline(":", {
      completion = {
        completeopt = "menu,menuone,noinsert,noselect",
      },
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    -- VueだけでなくTypeScriptやReactもVolarを使う
    lspconfig.volar.setup({
      capabilities = capabilities,
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      init_options = {
        vue = {
          hybridMode = false,
        },
      },
    })
    lspconfig.tailwindcss.setup({
      capabilities = capabilities,
      root_dir = util.root_pattern(
        "tailwind.config.js",
        "tailwind.config.cjs",
        "tailwind.config.mjs",
        "tailwind.config.ts"
      ),
    })
    lspconfig.denols.setup({
      capabilities = capabilities,
      root_dir = util.root_pattern("deno.json", "deno.jsonc"),
    })
    -- astro.js
    lspconfig.astro.setup({
      capabilities = capabilities,
    })
    -- Go
    lspconfig.gopls.setup({
      capabilities = capabilities,
      filetypes = { "go" },
      settings = {
        gopls = {
          gofumpt = true,
        },
      },
    })
    lspconfig.golangci_lint_ls.setup({ capabilities = capabilities })
    -- Lua
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostic = {
            globals = { "vim" },
          },
        },
      },
    })
    -- LSP key bindings
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        local opts = { buffer = ev.buf }
        -- 定義をホバー
        vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
        -- 定義に移動 (Lspsaga goto_definition は期待しない定義に飛んでしまうことがある)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        -- 実装へ移動
        vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
        -- 参照元へ移動
        vim.keymap.set("n", "gr", "<cmd>Lspsaga finder ref<cr>", opts)
        -- シンボルリネーム
        vim.keymap.set("n", "cr", "<cmd>Lspsaga rename<cr>", opts)
        -- コードアクション
        vim.keymap.set("n", "ga", "<cmd>Lspsaga code_action<cr>", opts)
        vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
        vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client == nil then
          return
        end

        -- inlay hint
        if client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable()
        end

        -- 深刻度が高い方を優先して表示
        vim.diagnostic.config({ severity_sort = true })
      end,
    })
  end,
}
