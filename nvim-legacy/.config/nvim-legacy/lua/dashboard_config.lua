vim.g.dashboard_custom_header = {
    '',
    '███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
    '████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
    '██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
    '██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
    '██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
    '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
'                                                  ' }

local function split_str (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end


-- requires cowsay, fortune, shuf
local footer = {'', "Have `fortune`, `cowsay`, and `shuf` for cows in your dashboard!", 'Cowfiles should be in `/usr/share/fortune`. If not, just edit the path in dashboard_config.lua', ''}
local cowsay_enabled = false


-- if os.execute('which shuf') and os.execute('which fortune') and os.execute('which cowsay') then
if cowsay_enabled then
    -- This adds another 40ms to startuptime...
    -- footer = split_str(io.popen('fortune | cowsay -f $(ls /usr/share/cows | shuf -n 1)'):read('*a'), '\n')
    footer = split_str(io.popen('fortune | cowsay'):read('*a'), '\n')
    table.insert(footer, #footer+1, '')
end

vim.g.dashboard_custom_footer = footer
vim.g.dashboard_default_executive = 'fzf'



local dashboard_entry_length = 50

local function make_dashboard_entry(description, keybinding, total_length)
    return {description .. string.rep(' ', total_length - #description - #keybinding) .. keybinding}
end


vim.g.dashboard_custom_section = {
    -- Dashboard sorts entries alphabetically.
    A_keybindings = {
        description = make_dashboard_entry('  Explore Keybindings', 'SPC SPC' , dashboard_entry_length),
        command = 'WhichKey'
    },
    recent_list= {
        description= make_dashboard_entry('  Recent Files', 'SPC f r', dashboard_entry_length),
        command = 'History'
    },
    find_files = {
        description= make_dashboard_entry('  Find Files', 'SPC f f', dashboard_entry_length),
        command = 'Files'
    },
    edit_config = {
        description= make_dashboard_entry('  Config Files', 'SPC f P', dashboard_entry_length),
        command = 'FZF ~/.config/nvim-legacy'
    },
    pick_project = {
        description = make_dashboard_entry('  Pick Project', 'SPC p p', dashboard_entry_length),
        command = 'FzfSwitchProject'
    },

    search_parent = {
        description = make_dashboard_entry('  Search @ CWD', 'SPC s p', dashboard_entry_length),
        command = 'Rg'
    },

    change_colourscheme = {
        description = make_dashboard_entry('  Change Colourscheme', 'SPC h t', dashboard_entry_length),
        command = 'DashboardChangeColorscheme'
    },

    search_documentation = {
        description = make_dashboard_entry('  Search Documentation', 'SPC h s', dashboard_entry_length),
        command = 'Helptags'
    },

    search_commands = {
        description = make_dashboard_entry('  Search Commands', 'SPC s c', dashboard_entry_length),
        command = 'Commands'
    },

    marks = {
        description = make_dashboard_entry('  Bookmarks', 'SPC l m', dashboard_entry_length),
        command = 'Marks'
    },

    Z_org_agenda = {
        description = make_dashboard_entry('  Org-Agenda', 'COMMA o a', dashboard_entry_length),
        command = ''
    },






}











