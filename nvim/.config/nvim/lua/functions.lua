-- Assorted utility functions


function _G.NI_dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

function _G.NI_cycle_number ()
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

function _G.NI_cycle_conceallevel()
    local switch = {
        [0] = 1,
        [1] = 2,
        [2] = 0,
    }
    vim.o.conceallevel = switch[vim.o.conceallevel]
    print("conceallevel=" .. vim.o.conceallevel)
end



function _G.NI_cycle_prose ()
    vim.wo.wrap = not vim.wo.wrap
    vim.wo.linebreak = not vim.wo.linebreak

    --[[ " Focus mode
function! Prose_mode()
    " execute ":Copilot disable"
    execute ":set linebreak!"
    execute ":set wrap!"
endfunction ]]

end


    
--[[ function p(a)
    print(vim.inspect(a))
end

--[[ A = vim.api
F =vim.fn ]]


-- function M.cycle_searchhl
