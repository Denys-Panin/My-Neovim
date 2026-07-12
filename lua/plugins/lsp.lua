return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'hrsh7th/cmp-nvim-lsp',
    'b0o/SchemaStore.nvim',
  },

  config = function()
    vim.filetype.add {
      extension = {
        tf = 'terraform',
        tfvars = 'terraform-vars',
      },
      pattern = {
        ['.*%.blade%.php'] = 'blade',
      },
    }

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, {
            buffer = event.buf,
            desc = 'LSP: ' .. desc,
          })
        end

        local builtin = require 'telescope.builtin'

        map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
        map('gr', builtin.lsp_references, '[G]oto [R]eferences')
        map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        map('<leader>fp', function()
          vim.lsp.buf.format { bufnr = event.buf }
        end, '[F]ormat File')

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })

          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
        end

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    local capabilities = vim.tbl_deep_extend('force', {}, vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())

    local servers = {
      intelephense = {},
      ts_ls = {},
      pyright = {},
      clangd = {},

      html = {
        filetypes = { 'html', 'twig', 'hbs', 'blade' },
      },

      cssls = {},
      tailwindcss = {},

      -- DevOps
      dockerls = {},
      docker_compose_language_service = {},
      terraformls = {
        filetypes = { 'terraform', 'terraform-vars' },
      },
      bashls = {},
      ansiblels = {},
      jsonls = {},

      yamlls = {
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = '',
            },
            schemas = require('schemastore').yaml.schemas(),
            validate = true,
            completion = true,
            hover = true,
          },
        },
      },

      sqlls = {},
      marksman = {},

      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            runtime = {
              version = 'LuaJIT',
            },
            workspace = {
              checkThirdParty = false,
              library = {
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
            },
            diagnostics = {
              disable = { 'missing-fields' },
            },
            format = {
              enable = false,
            },
          },
        },
      },
    }

    local ensure_installed = {
      -- LSP
      'intelephense',
      'ts_ls',
      'pyright',
      'clangd',
      'html',
      'cssls',
      'tailwindcss',
      'dockerls',
      'docker_compose_language_service',
      'terraformls',
      'bashls',
      'ansiblels',
      'jsonls',
      'yamlls',
      'sqlls',
      'marksman',
      'lua_ls',

      -- Formatters / linters
      'stylua',
      'blade-formatter',
      'php-cs-fixer',
      'phpstan',
      'shellcheck',
      'shfmt',
      'tflint',
      'prettier',
      'ruff',
      'yamllint',
    }

    require('mason-tool-installer').setup {
      ensure_installed = ensure_installed,
    }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}

          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
