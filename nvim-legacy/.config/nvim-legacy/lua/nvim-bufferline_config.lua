require('bufferline').setup{
    options = {
        view = "multiwindow",
        tab_size=5,
        numbers="both",
        separator_style="thin",
        enforce_regular_tabs=false,
        show_tab_indicators = true,
        tab_indicator_style = function(tab)
            if not tab.name or tab.name == "" then
                return "裡"
            end

            local loaded, webdev_icons
            if loaded == nil then
                loaded, webdev_icons = pcall(require, "nvim-web-devicons")
            end

            if loaded then
                local icon = webdev_icons.get_icon(tab.name, vim.fn.expand("#"..tab.mru_buf..":e"))
                if not icon or icon == "" then
                    return vim.fn.fnamemodify(tab.name, ":t")
                    -- return tab.name:match("^.+/(.+)$") .. " 裡"
                else
                    -- return tab.name:match("^.+/(.+)$") .. " " .. icon
                    return vim.fn.fnamemodify(tab.name, ':t') .. " " .. icon
                end
            end
        end
    }
}

local wk = require('which-key')

wk.register({
        name = "+bufferline",
        h = {"<cmd>BufferLineCyclePrev<CR>", "Previous buffer"},
        l = {"<cmd>BufferLineCycleNext<CR>", "Next buffer"},
        j = {"<cmd>BufferLineMovePrev<CR>", "Move buffer left"},
        k = {"<cmd>BufferLineMoveNext<CR>", "Move buffer right"},
    }, {
        mode = 'n',
        prefix = "<localleader>b"
    })






        -- offsets = {
            --[[ {filetype="vista", text="vista"},
            {filetype="coc-explorer", text="Project Drawer"} 
        } ]]
        --[[ sort_by = function(buffer_a, buffer_b)
            -- Automatically sort buffers by tabpage
            local tabs = vim.fn.gettabinfo()
            local buffer_a_tabnr = nil
            local buffer_b_tabnr = nil

            for _, tab in ipairs(tabs) do
                local buffers = vim.fn.tabpagebuflist(tab.tabnr)
                for _, buff in ipairs(buffers) do
                    if buff == buffer_a.id then
                        buffer_a_tabnr = tab.tabnr
                    elseif buff == buffer_b.id then
                        buffer_b_tabnr = tab.tabnr
                    end
                    if buffer_a_tabnr ~= nil and buffer_b_tabnr ~= nil then
                        return buffer_a_tabnr < buffer_b_tabnr
                    end
                end
            end

            if buffer_a_tabnr == nil then
                return true
            end

            if buffer_b_tabnr == nil then
                return false
            end

            return buffer_a_tabnr < buffer_b_tabnr
        end ]]




