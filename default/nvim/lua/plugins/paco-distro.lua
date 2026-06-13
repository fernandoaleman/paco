return {
  -- <leader>dd opens lazydocker via snacks terminal (Q21)
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>dd",
        function()
          Snacks.terminal({ "lazydocker" })
        end,
        desc = "Lazydocker",
      },
    },
  },

  -- Stay in visual mode after indent (Q12)
  {
    "LazyVim/LazyVim",
    keys = {
      { "<", "<gv", mode = "v", desc = "Indent left + stay in visual" },
      { ">", ">gv", mode = "v", desc = "Indent right + stay in visual" },
    },
  },

  -- Ensure the `regex` treesitter parser is installed; LazyVim extras use it
  -- for embedded regex highlighting inside JS/markdown/json string literals.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "regex")
    end,
  },
}
