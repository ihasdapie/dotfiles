-- Assorted utility functions

M = {}

function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

function M.cycle_number ()
    -- cycles between `set number`, `set relativenumber`, `set nonumber` ... and so forth
    local nu_isset = vim.o.number
    local rnu_isset = vim.o.relativenumber

    if not nu_isset and not rnu_isset then
        vim.o.number = true
    elseif nu_isset and not rnu_isset then
        vim.o.relativenumber = true
    elseif nu_isset and rnu_isset then
        vim.o.number = false
    elseif not nu_isset and rnu_isset then
        vim.o.relativenumber = false
    end
end

-- function M.cycle_searchhl


return M




