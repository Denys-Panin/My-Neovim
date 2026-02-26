return {
  {
    "kylechui/nvim-surround",
    version = "*",         -- use the latest stable release
    event = "VeryLazy",    -- load on a safe lazy event
    config = function()
      require("nvim-surround").setup({
        -- leave empty to use defaults, or customize below
        -- keymaps = {
        --   -- add your custom keymaps if you want
        -- },
        -- surrounds = {
        --   -- define custom surrounds if needed
        -- },
      })
    end,
  },
}

