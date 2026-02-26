
# 📘 Neovim Configuration Documentation

## = Plugins GitHub repositories
= `https://github.com/derektata/lorem.nvim`: Lorem plugin



## ⌨️ Keymaps
- `space` : leader key

### 🧭 General Navigation:
- `x`: Close the current buffer
- `xx`: Close the all buffer
- `<Space>`: Disable the space key in Normal/Visual modes
- `<C-s>`: Save the file
- `<leader>sn`: Save without triggering formatting
- `<C-q>`: Quit file
- `<C-d>`, `<C-u>`: Scroll down/up and center
- `n`, `N`: Next/previous search result and center
- `<Tab>`, `<S-Tab>`: Switch between buffers
- `<leader>x`: Force close buffer
- `<leader>b`: New empty buffer

### 🪟 Window Management:
- `<leader>v`: Split window vertically
- `<leader>h`: Split window horizontally
- `<leader>se`: Make splits equal size
- `<leader>xs`: Close active window
- `<C-h/j/k/l>`: Move between windows
- `<Up/Down/Left/Right>`: Resize window

### 🗂️ Tabs:
- `<leader>to`: Open new tab
- `<leader>tx`: Close current tab
- `<leader>tn`: Next tab
- `<leader>tp`: Previous tab

### 🔧 Miscellaneous:
- `<leader>lw`: Toggle line wrapping
- `<`, `>` (in Visual mode): Stay in indent mode
- `p`: Paste without replacing the buffer
- `[d`, `]d`: Jump between diagnostics
- `<leader>d`: Open diagnostic float
- `<leader>q`: Open diagnostics list

### 📊 Diffview:
- `<leader>go`: Open Diffview
- `<leader>gc`: Close Diffview
- `<leader>gt`: Toggle file panel
- `<leader>gh`: Show file history
- `<leader>gl`: Compare with previous commit (HEAD~1)
- `<leader>gm`: Compare with main/master branch
- `<leader>gr`: Refresh Diffview

### 🌐 Live Server:
- `<leader>ls`: Start Live Server
- `<leader>le`: Stop Live Server

### 🧼 Formatting:
- `<leader>pf`: Format PHP with php-cs-fixer
- `<leader>lf`: Format Laravel project with Pint

### 🎯 Class Search:
- `<leader>cc`: Search class in CSS/SCSS files using Telescope

---

## ⚙️ LSP and Autocompletion

This setup uses the following plugins:
- `mason.nvim`: Installer and manager for LSPs, formatters, tools
- `nvim-lspconfig`: LSP configurations
- `nvim-cmp`: Autocompletion engine
- `LuaSnip`: Snippet engine for completion

Supported languages:
- Lua, PHP, HTML, CSS, JavaScript, Python (via Pyright)

---

## 📦 Plugin Descriptions

- `telescope.nvim`: Powerful file/buffer/search UI
- `diffview.nvim`: Git diff viewer
- `lualine.nvim`: Statusline plugin
- `gitsigns.nvim`: Git signs in the gutter
- `nvim-cmp`: Autocompletion
- `LuaSnip`: Snippet support
- `mason.nvim`: Tool installer for LSPs and more
- `none-ls.nvim`: Integration of external linters/formatters
- `emmet-vim`: Emmet for fast HTML
- `php-cs-fixer`, `pint`: Formatters for PHP and Laravel
- `alpha-nvim`: Custom start screen
- `lazy.nvim`: Plugin manager

---

### 🐍 Ruff & Ruff LSP

There are two ways to use Ruff in Neovim:

1. **As a linter** (via [null-ls](https://github.com/nvimtools/none-ls.nvim)):
   - Requires installing `ruff` via pip:
     ```bash
     pip install ruff
     ```

2. **As a language server** (for full LSP support):
   - Install `ruff-lsp` via Mason inside Neovim:
     ```vim
     :Mason
     ```
     Then search for `ruff-lsp` and press `i` to install it.

   - Add to your LSP servers:
     ```lua
     ruff_lsp = {},
     ```

   - And ensure it’s included in the `ensure_installed` list:
     ```lua
     local ensure_installed = {
       -- ...
       'ruff-lsp',
     }
     ```

---

## 🧰 How to Install Required Tools

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install ripgrep fd-find nodejs npm php php-cli composer curl

# PHP Formatter
composer global require friendsofphp/php-cs-fixer

# Laravel Pint
composer global require laravel/pint

# Live Server
npm install -g live-server

# Stylua (Lua Formatter)
cargo install stylua

# Add Composer bin to PATH
echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```
