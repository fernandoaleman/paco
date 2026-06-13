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

  -- Ensure treesitter parsers paco's bundled features (render-markdown,
  -- snacks.picker, bash highlighting) and common web-dev languages need.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      local extras = {
        "regex",
        "bash",
        "css",
        "html",
        "javascript",
        "scss",
        "svelte",
        "tsx",
        "vue",
      }
      for _, lang in ipairs(extras) do
        table.insert(opts.ensure_installed, lang)
      end
    end,
  },
}
