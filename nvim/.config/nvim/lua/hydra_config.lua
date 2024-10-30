local Hydra = require('hydra')
local gitsigns = require('gitsigns')
local gitlinker = require('gitlinker')

-- Git Hydra <leader g>

local git_hint = [[
 _J_: next hunk      _G_: status         _/_: show base file   _b_: blame line
 _K_: prev hunk      _B_: Blame all      _f_: Git files        _E_: GEdit: 
 _s_: stage hunk     _S_: stage buffer   _u_: undo stage hunk  _p_: preview hunk 
 _r_: reset hunk     _R_: reset buffer   _d_: toggle deleted   _c_: Commits
]]


Hydra({
   hint = git_hint,
   config = {
      color = 'pink',
      invoke_on_body = true,
      hint = {
         position = 'bottom',
      },
      on_enter = function()
         vim.bo.modifiable = true
         gitsigns.toggle_linehl(true)
      end,
      on_exit = function()
         gitsigns.toggle_linehl(false)
         gitsigns.toggle_deleted(false)
         vim.cmd 'echo' -- clear the echo area
      end
   },
   mode = {'n','x'},
   body = '<leader>g',
   heads = {
       { 'J', function()
               if vim.wo.diff then return ']c' end
               vim.schedule(function() gitsigns.next_hunk() end)
               return '<Ignore>'
       end, { expr = true } },
       { 'K', function()
               if vim.wo.diff then return '[c' end
               vim.schedule(function() gitsigns.prev_hunk() end)
               return '<Ignore>'
       end, { expr = true } },

       { 'G', "<cmd>Git<CR>" },
       { 'c', "<cmd>Commits<CR>" },
       { 'B', "<cmd>Git blame<CR>" },
       { 'f', "<cmd>GFiles<CR>" },
       { 'E', "<cmd>Gedit:<CR>" },
       { 'r', gitsigns.reset_hunk, {silent=true} },
       { 'R', "<cmd>Gitsigns reset_buffer<CR>" },
       { 's', "<cmd>Gitsigns stage_hunk<CR>", { silent = true } },
       { 'u', "<cmd>Gitsigns undo_stage_hunk<CR>", {silent=true} },
       { 'S', gitsigns.stage_buffer },
       { 'p', gitsigns.preview_hunk },
       { 'd', gitsigns.toggle_deleted, { nowait = true } },
       { 'b', gitsigns.blame_line },
       { '/', gitsigns.show, { exit = true } }, -- show the base of the file
       { '<ESC>', nil, { exit = true, nowait = true } },
   }
})





-- local dbg_hint = [[
 -- _c_: Start/Continue    _S_: Stop                          _R_: Restart                 _P_: Pause
 -- _b_: Toggle breakpoint _B_: Toggle conditional breakpoint _F_: Add function breakpoint _C_: Run to cursor
 -- _N_: Step over         _n_: Step into                     _o_: Step out                _i_: Inspect symbol
 -- _u_: Up stack          _d_: Down stack
-- ]]







--[[ Hydra({
   hint = dbg_hint,
   config = {
      color = 'pink',
      invoke_on_body = true,
      hint = {
         position = 'top',
         border = 'rounded'
      },
      on_enter = function()
         -- vim.bo.modifiable = false
      end,
      on_exit = function()
         vim.cmd 'echo' -- clear the echo area
      end
   },
   mode = {'n'},
   body = '<leader>d', heads = {
      {'c',  "<Plug>VimspectorContinue"},
      {'S',  "<Plug>VimspectorStop"},
      {'R',  "<Plug>VimspectorRestart"},
      {'P',  "<Plug>VimspectorPause"},
      {'b',  "<Plug>VimspectorToggleBreakpoint"},
      {'B',  "<Plug>VimspectorToggleConditionalBreakpoint"},
      {'F',  "<Plug>VimspectorAddFunctionBreakpoint"},
      {'C',  "<Plug>VimspectorRunToCursor"},
      {'N',  "<Plug>VimspectorStepOver"},
      {'n',  "<Plug>VimspectorStepInto"},
      {'o',  "<Plug>VimspectorStepOut"},
      {'i',  "<Plug>VimspectorBalloonEval"},
      {'u',  "<Plug>VimspectorUpFrame"},
      {'d',  "<Plug>VimspectorDownFrame"},
   }
}) ]]







