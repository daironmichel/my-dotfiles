return {
    {
      "nvim-cmp",
      opts = function(_, opts)
        -- opts.completion = {
        --   autocomplete = false,
        -- }
        opts.experimental.ghost_text = false
        local cmp = require("cmp")
        opts.window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        }
      end,
    },
  }