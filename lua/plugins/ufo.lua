return {
  {
    'kevinhwang91/nvim-ufo',

    dependencies = {
      'kevinhwang91/promise-async',
    },

    event = 'BufReadPost',

    config = function()
      -- Folding appearance and behaviour
      vim.opt.foldcolumn = '1'
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true

      local ufo = require 'ufo'

      ufo.setup {
        provider_selector = function(_, filetype, _)
          -- Use Tree-sitter for HTML and other supported languages.
          -- If Tree-sitter folding is unavailable, use indentation.
          return { 'treesitter', 'indent' }
        end,
      }

      -- Open all folds
      vim.keymap.set('n', 'zR', ufo.openAllFolds, {
        desc = 'Open all folds',
      })

      -- Close all folds
      vim.keymap.set('n', 'zM', ufo.closeAllFolds, {
        desc = 'Close all folds',
      })

      -- Peek inside a folded block
      vim.keymap.set('n', 'zK', function()
        local window_id = ufo.peekFoldedLinesUnderCursor()

        if not window_id then
          vim.lsp.buf.hover()
        end
      end, {
        desc = 'Peek folded block',
      })
    end,
  },
}
