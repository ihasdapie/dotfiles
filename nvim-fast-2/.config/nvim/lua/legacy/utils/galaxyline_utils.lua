local M = {}
local F = vim.fn
local A = vim.api

M.stabline = {}
M.stabline.utils = {}
M.lsp = {}
M.utils = {}
M.misc = {}


-- local function get_color() 








local function pp(i)
    print(vim.inspect(i))
end

-- Checks if a string is empty or nil
-- @param str string
-- @return bool
function M.utils.is_empty(str)
    return (not str) or (str == '')
end

-- Gets the buffer name in the first window of the tabpage
-- TODO Get *Active* buffer instead. Maintian a state table?
-- @param tabpage_handle integer
-- @return str
function M.stabline.utils.get_tabpage_bufname(tabpage_handle)
    local tab_info = F.gettabinfo(tabpage_handle)
    local first_window=  tab_info[1].windows[1]
    -- try nvim_win_get_buf(window)...
    local buf_in_first_window = F.getwininfo(first_window)[1].bufnr
    local bufname = F.getbufinfo(buf_in_first_window)[1].name
    return bufname
end

-- Formats a buffer path according to a fstring
-- Default is filename only
-- @param fstring regexp | string | nil
-- @return string
function M.stabline.utils.filename_only_bufstring_format(bufname)
    return bufname:match("^.+/(.+)$")
end

-- Renders the current tab for use with galaxyline
-- buffer_formatter is any function that takes and returns a string
-- @param buffer_formatter function | nil
-- @param left_seperator string | nil
-- @param right_seperator string | nil
-- @param tab_style string Can be one of following: 'number_only', 'name_only', 'both' (default)
-- TODO Add custom tabpage naming
function M.stabline.render_current_tab(buffer_formatter, left_seperator, right_seperator, tab_style)
    if not buffer_formatter then
        -- buffer_formatter = M.stabline.utils.filename_only_bufstring_format
        buffer_formatter = M.stabline.utils.filename_only_bufstring_format
    end
    local function renderer ()

        local cur_tab = F.tabpagenr()
        local bufname = M.stabline.utils.get_tabpage_bufname(cur_tab)

        if M.utils.is_empty(bufname) then
            return left_seperator .. cur_tab .. right_seperator
        elseif tab_style == 'name_only' then
            return left_seperator ..  buffer_formatter(bufname) .. right_seperator
        elseif tab_style == 'number_only' then
            return left_seperator .. cur_tab .. right_seperator
        else
            return left_seperator .. cur_tab .. ": " ..  buffer_formatter(bufname) .. right_seperator
        end
    end
    return renderer
end


-- Renders buffers to the right of the current tab for use with galaxyline
-- buffer_formatter is any function that takes and returns a string
-- @param buffer_formatter function | nil
-- @param seperator string | nil
-- @param tab_style string Can be one of following: 'number_only', 'name_only', 'both' (default)
function M.stabline.render_right_tabs(buffer_formatter, seperator, tab_style)
    if not buffer_formatter then
        -- buffer_formatter = M.stabline.utils.filename_only_bufstring_format
        buffer_formatter = M.stabline.utils.filename_only_bufstring_format
    end
    local function renderer()
        local tabinfo = F.gettabinfo()
        local right_tabstr = ""
        local bufname
        local cur_tab = F.tabpagenr()

        for _, tab in pairs(tabinfo) do -- I think that the keys are guaranteed to be ordered, if I'm not mistaken...
            if tab.tabnr <= cur_tab then
                goto continue -- TODO What's the proper lua way to do this?
            end
            bufname = M.stabline.utils.get_tabpage_bufname(tab.tabnr)
            if M.utils.is_empty(bufname) then
                right_tabstr = right_tabstr .. tab.tabnr .. seperator
            elseif tab_style == 'name_only' then
                right_tabstr =  right_tabstr .. buffer_formatter(bufname) .. seperator
            elseif tab_style == 'number_only' then
                right_tabstr =  right_tabstr .. tab.tabnr .. seperator
            else
                right_tabstr =  right_tabstr .. tab.tabnr .. ': ' .. buffer_formatter(bufname) .. seperator
            end
            ::continue::
        end
        return right_tabstr
    end
    return renderer
end

-- Renders buffers to the left of the current tab for use with galaxyline
-- buffer_formatter is any function that takes and returns a string
-- @param buffer_formatter function | nil
-- @param seperator string | nil
-- @param tab_style string Can be one of following: 'number_only', 'name_only', 'both' (default)
function M.stabline.render_left_tabs(buffer_formatter, seperator, tab_style)
    if not buffer_formatter then
        -- buffer_formatter = M.stabline.utils.filename_only_bufstring_format
        buffer_formatter = M.stabline.utils.filename_only_bufstring_format
    end
    local function renderer ()
        local tabinfo = F.gettabinfo()
        local left_tabstr = seperator
        local bufname
        local cur_tab = F.tabpagenr()

        for key, tab in ipairs(tabinfo) do -- I think that the keys are guaranteed to be ordered, if I'm not mistaken...
            if tab.tabnr >= cur_tab then
                break
            end
            bufname = M.stabline.utils.get_tabpage_bufname(tab.tabnr)
            if M.utils.is_empty(bufname) then
                left_tabstr = left_tabstr .. tab.tabnr 
            elseif tab_style == 'name_only' then
                left_tabstr =  left_tabstr .. buffer_formatter(bufname)
            elseif tab_style == 'number_only' then
                left_tabstr =  left_tabstr .. tab.tabnr
            else
                left_tabstr =  left_tabstr .. tab.tabnr .. ': ' .. buffer_formatter(bufname)
            end

            if key < (cur_tab - 1) then 
                left_tabstr = left_tabstr .. seperator
            end
            ::continue::
        end
        return left_tabstr
    end
    return renderer
end

function M.stabline.get_condition(type)
    -- TODO optimize this
   local function condition()
     local cur_tab = vim.fn.tabpagenr()
     local all_nr = {}
     for key, tab in pairs(vim.fn.gettabinfo()) do
       table.insert(all_nr, tab.tabnr)
     end

     local max = math.max(unpack(all_nr))
     if type == 'checkleft' then
       return (cur_tab > 1 ) and (#all_nr > 1)
     elseif type == 'checkright' then
       return cur_tab < max
     end
   end
   return condition
 end

function M.misc.db_ui_condition()
  return vim.fn.exists("*db_ui#statusline") == 1
end

function M.misc.db_ui_info()
    local status = vim.fn['db_ui#statusline']()
    if M.utils.is_empty(status) then
        return ''
    end
    return status
end


function M.lsp.format_lsp_status(status)
    local shorter_stat = ''
    for match in string.gmatch(status, "[^%s]+")  do
        local err_warn = string.find(match, "^[WE]%d+", 0) -- check what this regex does
        if not err_warn then
            shorter_stat = shorter_stat .. ' ' .. match
        end
    end
    return shorter_stat
end

function M.lsp.status ()
    local status = vim.fn['coc#status']()
    if M.utils.is_empty(status) then
        return ''
    end
    return M.lsp.format_lsp_status(status)
end



function M.misc.get_venom()
  local virtualenv = vim.fn['venom#statusline']()
  return virtualenv
end









return M



