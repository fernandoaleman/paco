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
}
