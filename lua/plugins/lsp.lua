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

    local lsp_attach_group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = lsp_attach_group,

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
          vim.lsp.buf.format {
            bufnr = event.buf,
            async = false,
          }
        end, '[F]ormat File')

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_group = vim.api.nvim_create_augroup('kickstart-lsp-highlight-' .. event.buf, { clear = true })

          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_group,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_group,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            buffer = event.buf,
            group = highlight_group,

            callback = function()
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds {
                group = highlight_group,
                buffer = event.buf,
              }
            end,
          })
        end

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            local enabled = vim.lsp.inlay_hint.is_enabled {
              bufnr = event.buf,
            }

            vim.lsp.inlay_hint.enable(not enabled, {
              bufnr = event.buf,
            })
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
        filetypes = {
          'html',
          'twig',
          'hbs',
          'blade',
        },
      },

      cssls = {},
      tailwindcss = {},

      -- DevOps
      dockerls = {},
      docker_compose_language_service = {},

      terraformls = {
        filetypes = {
          'terraform',
          'terraform-vars',
        },

        -- Override the incompatible default on_attach from nvim-lspconfig.
        on_attach = function(_, bufnr)
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(bufnr) then
              vim.lsp.codelens.refresh {
                bufnr = bufnr,
              }
            end
          end)
        end,
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
              disable = {
                'missing-fields',
              },
            },

            format = {
              enable = false,
            },
          },
        },
      },
    }

    local ensure_installed = {
      -- LSP servers
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

      -- Formatters and linters
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

    -- Configure the servers before mason-lspconfig enables them.
    for server_name, server_config in pairs(servers) do
      server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {})

      vim.lsp.config(server_name, server_config)
    end

    require('mason-lspconfig').setup {
      automatic_enable = true,
    }
  end,
}
