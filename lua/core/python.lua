local M = {}

local function set_colorcolumn_style()
  vim.api.nvim_set_hl(0, "ColorColumn", {
    bg = "#70e570",
  })
end

function M.setup()
  set_colorcolumn_style()

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_colorcolumn_style,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
      vim.opt_local.colorcolumn = "90,120"
      -- vim.opt_local.colorcolumn = "90"
      vim.opt_local.textwidth = 90

      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.softtabstop = 4
      vim.opt_local.expandtab = true

      vim.opt_local.cursorline = true
    end,
  })
end

return M
