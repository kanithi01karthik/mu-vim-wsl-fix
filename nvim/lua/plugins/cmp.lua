-- =============================================================================
--                           AUTOCOMPLETE SETTINGS (CMP)
-- =============================================================================
-- Sets up the popup menu for autocomplete suggestions.
-- Combines recommendations from the active LSP server, open buffer contents,
-- file paths, and snippet expansions.
-- =============================================================================

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- source: LSP suggestions
      "hrsh7th/cmp-buffer",   -- source: text within current file
      "hrsh7th/cmp-path",     -- source: file system paths
      "L3MON4D3/LuaSnip",     -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- adapter to bind luasnip into cmp
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          }),
        },
        mapping = cmp.mapping.preset.insert({
          -- Move down in the completion menu
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          -- Move up in the completion menu
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          -- Scroll docs window
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          -- Close completion menu
          ["<C-e>"] = cmp.mapping.abort(),
          -- Confirm selection (CR / Enter)
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          
          -- Tab navigation behavior
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Shift-Tab navigation behavior
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "copilot",  priority = 1000 }, -- Copilot completions (when enabled)
          { name = "nvim_lsp", priority = 900 },  -- LSP completions
          { name = "luasnip",  priority = 750 },  -- snippets
          { name = "path",     priority = 500 },  -- file path autocomplete
        }, {
          { name = "buffer",   priority = 250 },  -- buffer words
        }),
      })
    end,
  },
}
