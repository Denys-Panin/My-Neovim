return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  build = ':TSUpdate',
  dependencies = {}, -- ВАЖЛИВО: має бути список, навіть якщо порожній
  opts = {
    ensure_installed = {
      'lua', 'python', 'javascript', 'typescript', 'vimdoc', 'vim',
      'regex', 'terraform', 'sql', 'dockerfile', 'toml', 'json', 'jsonc','java',
      'groovy', 'go', 'gitignore', 'graphql', 'yaml', 'make', 'cmake',
      'markdown', 'markdown_inline', 'bash', 'tsx', 'css', 'html',
      'c', 'cpp'
    },
    auto_install = true,
    highlight = { enable = true, additional_vim_regex_highlighting = { 'ruby' } },
    indent = { enable = true, disable = { 'ruby' } },
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)

    -- 🔹 Функція для додавання класів із виділеного HTML у CSS у правильному порядку
    function _G.ExtractSelectedHtmlClasses()
        local classes = {}
        local seen_classes = {} -- Для унікальності класів

        -- Отримуємо виділений текст
        local start_line, start_col = unpack(vim.fn.getpos("'<"), 2, 3)
        local end_line, end_col = unpack(vim.fn.getpos("'>"), 2, 3)

        local selected_lines = vim.fn.getline(start_line, end_line)
        if #selected_lines == 0 then return end

        -- Вирізаємо правильну частину для першого та останнього рядка
        selected_lines[1] = string.sub(selected_lines[1], start_col)
        selected_lines[#selected_lines] = string.sub(selected_lines[#selected_lines], 1, end_col)

        -- Обробляємо кожен рядок і шукаємо класи
        for _, line in ipairs(selected_lines) do
            for class_list in line:gmatch('class="(.-)"') do
                for class_name in class_list:gmatch("%S+") do
                    if not seen_classes[class_name] then
                        table.insert(classes, class_name)
                        seen_classes[class_name] = true
                    end
                end
            end
        end

        -- 🔹 Отримуємо список всіх CSS-файлів у проєкті
        local css_files = vim.fn.globpath(vim.fn.getcwd(), "**/*.css", false, true)

        if #css_files == 0 then
            print("❌ CSS-файли не знайдено!")
            return
        end

        -- 🔹 Показуємо список файлів для вибору
        vim.ui.select(css_files, {
            prompt = "Виберіть файл для додавання класів:",
        }, function(selected_file)
            if not selected_file then
                print("❌ Файл не вибрано, операцію скасовано.")
                return
            end

            local existing_classes = {}

            -- Якщо файл існує, зчитуємо його вміст
            if vim.fn.filereadable(selected_file) == 1 then
                local lines = vim.fn.readfile(selected_file)
                for _, line in ipairs(lines) do
                    local existing_class = line:match("^%s*%.([%w%-_]+)%s*{")
                    if existing_class then
                        existing_classes[existing_class] = true
                    end
                end
            end

            -- Формуємо CSS-код, додаючи тільки нові класи у правильному порядку
            local css_lines = vim.fn.readfile(selected_file) or {}
            for _, class_name in ipairs(classes) do
                if not existing_classes[class_name] then
                    table.insert(css_lines, "." .. class_name .. " {}")
                end
            end

            -- Записуємо оновлений CSS у вибраний файл
            vim.fn.writefile(css_lines, selected_file)

            print("✅ CSS-файл оновлено: " .. selected_file)

            -- Відкриваємо вибраний CSS-файл у Neovim
            vim.cmd(string.format("edit %s", selected_file))
        end)
    end

    -- 🔹 Прив’язуємо до Visual Mode (виділення + <leader>ec)
    vim.api.nvim_set_keymap("v", "<leader>ec", ":lua ExtractSelectedHtmlClasses()<CR>", { noremap = true, silent = true })
  end,
}

