local function lualine_config()
    -- Based on `eviline` from `shadmansaleh` and `glepnir`

    -- Color table for highlights
    local colors = {
        bg       = '#202328',
        fg       = '#bbc2cf',
        yellow   = '#ECBE7B',
        cyan     = '#008080',
        darkblue = '#081633',
        green    = '#98be65',
        orange   = '#FF8800',
        violet   = '#a9a1e1',
        magenta  = '#c678dd',
        blue     = '#51afef',
        red      = '#ec5f67',
        white    = '#ffffff',
    }

    -- Conditions
    local conditions = {
        buffer_not_empty = function()
            return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
        end,
        hide_in_width = function()
            return vim.fn.winwidth(0) > 80
        end,
        hide_width_small = function()
            return vim.fn.winwidth(0) > 160
        end,
        check_git_workspace = function()
            local filepath = vim.fn.expand('%:p:h')
            local gitdir = vim.fn.finddir('.git', filepath .. ';')
            return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
    }

    -- Config
    local config = {
        options = {
            -- Disable sections and component separators
            icons_enabled = true,
            component_separators = '',
            globalstatus = true,
            section_separators = '',
            theme = {
                -- We are going to use lualine_c an lualine_x as left and
                -- right section. Both are highlighted by c theme .  So we
                -- are just setting default looks o statusline
                normal = { c = { fg = colors.fg, bg = colors.bg } },
                inactive = { c = { fg = colors.fg, bg = colors.bg } },
            },
        },
        sections = {
            -- these are to remove the defaults
            lualine_a = {},
            lualine_b = {},
            lualine_y = {},
            lualine_z = {},
            -- These will be filled later
            lualine_c = {},
            lualine_x = {},
        },
        inactive_sections = {
            -- these are to remove the defaults
            lualine_a = {},
            lualine_b = {},
            lualine_y = {},
            lualine_z = {},
            lualine_c = {},
            lualine_x = {},
        },
    }

    -- Inserts a component in lualine_c at left section
    local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
    end

    -- Inserts a component in lualine_x at right section
    local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
    end

    -- current lsp function
    local function current_lsp()
        local msg = ''
        local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
            return msg
        end
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
            end
        end
        return msg
    end

    ins_left {
        -- mode component
        function()
            -- Arch/Apple symbol from NerdFonts
            local os
            if vim.fn.has('mac') == 1 then
                os = ''
            elseif vim.fn.has('unix') == 1 then
                os = ''
            end
            return os
        end,

        color = function()
            -- auto change color according to neovims mode
            local mode_color = {
                n = colors.red,
                i = colors.green,
                v = colors.blue,
                [''] = colors.blue,
                V = colors.blue,
                c = colors.magenta,
                no = colors.red,
                s = colors.orange,
                S = colors.orange,
                [''] = colors.orange,
                ic = colors.yellow,
                R = colors.violet,
                Rv = colors.violet,
                cv = colors.red,
                ce = colors.red,
                r = colors.cyan,
                rm = colors.cyan,
                ['r?'] = colors.cyan,
                ['!'] = colors.red,
                t = colors.red,
            }
            return { fg = mode_color[vim.fn.mode()] }
        end,
        padding = { left = 1 },
    }

    ins_left {
        'filesize',
        cond = conditions.buffer_not_empty,
    }

    ins_left {
        -- harpoon mark + Filename
        function()
            local current_file = vim.fn.split(vim.api.nvim_buf_get_name(0), "/")
            current_file = current_file[#current_file]

            local harpoon_marks = require("harpoon").get_mark_config()['marks']

            local file_key = ""
            for key, value in pairs(harpoon_marks) do
                local file = vim.fn.split(value['filename'], "/")
                file = file[#file]

                if current_file == file then
                    file_key = key .. " "
                    break
                end
            end

            return file_key .. current_file
        end,
        cond = conditions.buffer_not_empty,
        color = { fg = colors.magenta, gui = 'bold' },
    }

    ins_left { 'location' }

    ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }

    ins_left {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ' },
        diagnostics_color = {
            color_error = { fg = colors.red },
            color_warn = { fg = colors.yellow },
            color_info = { fg = colors.cyan },
        },
    }

    -- Insert mid section. You can make any number of sections in neovim :)
    -- for lualine it's any number greater then 2
    ins_left {
        function()
            return '%='
        end,
    }

    ins_right{
        -- harpoonFiles,
        function()
            local harpoon_marks = require("harpoon").get_mark_config()['marks']
            local currentFile = vim.fn.split(vim.api.nvim_buf_get_name(0), "/")
            currentFile = currentFile[#currentFile]

            local ret = ""
            local count = 0
            for key, value in pairs(harpoon_marks) do
                local file = vim.fn.split(value['filename'], "/")
                file = file[#file]

                -- if currentFile not equal add string
                if currentFile ~= file then
                    ret = ret .. " " .. key .. " " .. file
                end
                count = count + 1
                if count == 4 then break end
            end

            return ret
        end,
        cond = conditions.buffer_not_empty,
        color = { fg = colors.cyan, gui = 'bold' },
    }

    ins_right {
        -- Lsp server name .
        function()
            local msg = current_lsp()
            if msg == '' then
                msg = 'no lsp'
            end
            return msg
        end,
        icon = '',
        color = function()
            local msg = current_lsp()
            local color
            if msg == '' then
                color = colors.red
            else
                color = colors.white
            end
            return { fg = color }
        end,
    }

    ins_right {
        'branch',
        icon = '',
        color = { fg = colors.violet, gui = 'bold' },
    }

    ins_right {
        'diff',
        -- Is it me or the symbol for modified us really weird
        symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
        diff_color = {
            added = { fg = colors.green },
            modified = { fg = colors.orange },
            removed = { fg = colors.red },
        },
        cond = conditions.hide_in_width,
    }

    ins_right {
        'datetime',
        cond = conditions.hide_width_small,
        style = "🕒 %H:%M",
        padding = { right = 1 },
    }

    return config
end

return lualine_config()
