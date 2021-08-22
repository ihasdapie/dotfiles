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

local footer = {'', "Install `fortune`, `cowsay`, and `shuf` for cows in your dashboard!", ''}

if os.execute('which shuf') and os.execute('which fortune') and os.execute('which cowsay') then
    footer = split_str(io.popen('fortune -s | cowsay -f $(ls /usr/share/cows | shuf -n1)'):read('*a'), '\n')
    table.insert(footer, #footer+1, '')
end

vim.g.dashboard_custom_footer = footer



local dashboard_entry_length = 50

local function make_dashboard_entry(description, keybinding, total_length)
    return {description .. string.rep(' ', total_length - #description - #keybinding) .. keybinding}
end


vim.g.dashboard_custom_section = {
    -- Dashboard takes it alphabetically
    A_keybindings = {
        description = make_dashboard_entry('  Explore Keybindings', 'SPC SPC' , dashboard_entry_length),
        command = 'WhichKey'
    },
    buffer_list= {
        description= make_dashboard_entry('  Recent Files', 'SPC f r', dashboard_entry_length),
        command = 'Files'
    },
    pick_project = {
        description = make_dashboard_entry('冷 Pick Project', 'SPC p c', dashboard_entry_length),
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
        description = make_dashboard_entry('  Search Documentation', 'SPC h s', dashboard_entry_length),
        command = 'Helptags'
    },

    search_commands = {
        description = make_dashboard_entry('  Search Commands', 'SPC s c', dashboard_entry_length),
        command = 'Commands'
    },

    marks = {
        description = make_dashboard_entry(' Bookmarks', 'SPC l m', dashboard_entry_length),
        command = 'Marks'
    },

    Z_org_agenda = {
        description = make_dashboard_entry('  Org-Agenda', 'COMMA o a', dashboard_entry_length),
        command = ''
    },






}











