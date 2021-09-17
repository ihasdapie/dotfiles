-- Just-for-fun test packer.nvim test
-- I don't get any significant performance improvements over vim-plug
-- The added features are nice but I don't have time to work it through yet
return require('packer').startup(function(use)
  -- Packer can manage itself
  use {'wbthomason/packer.nvim'}
  use {'neoclide/coc.nvim', branch =  'release'}
  use {'junegunn/fzf'}
  use {'junegunn/fzf.vim'}
  use {'liuchengxu/vista.vim', cmd = { 'Vista' }}
  use {'benwainwright/fzf-project', cmd = { 'FzfSwitchProject', 'FzfChooseProjectFile' }}
  use {'sheerun/vim-polyglot'}
  use {'tpope/vim-fugitive'}
  use {'lewis6991/gitsigns.nvim'}
  use {'ihasdapie/vim-snippets'}
  use {'voldikss/vim-floaterm', cmd = { 'FloatermFirst', 'FloatermHide', 'FloatermKill', 'FloatermLast', 'FloatermNew', 'FloatermNext', 'FloatermPrev', 'FloatermSend', 'FloatermShow', 'FloatermToggle', 'FloatermUpdate', 'FloatermFirst' }}
  use {'glepnir/galaxyline.nvim' , branch = 'main'}
  use {'kshenoy/vim-signature' }
  use {'ggandor/lightspeed.nvim'}
  use {'famiu/bufdelete.nvim', cmd = { 'Bdelete', 'BWipeout' }}
  use {'mbbill/undotree', cmd = { 'UndotreeToggle' }}
  use {'antoinemadec/FixCursorHold.nvim'}
  use {'tweekmonster/startuptime.vim', cmd = 'StartupTime'}
  use {'vim-scripts/LargeFile'}
  use {'famiu/nvim-reload', cmd = { 'Reload', 'Restart' }}
  use {'kdav5758/TrueZen.nvim', cmd = { 'TZMinimalist', 'TZAtaraxis' }}
  use {'kyazdani42/nvim-web-devicons'}
  use {'wfxr/minimap.vim', cmd = { 'MinimapToggle' }}
  use {'glepnir/dashboard-nvim'}
  use {'gruvbox-community/gruvbox',  cmd = { 'Colors' }}
  use {'ihasdapie/spaceducky',  cmd = { 'Colors' }}
  use {'navarasu/onedark.nvim', cmd = { 'Colors' }}
  use {'b4skyx/serenade', cmd = { 'Colors' }}
  use {'Luxed/ayu-vim' }
  use {'michaelb/sniprun', run = 'bash install.sh',  cmd = { 'SnipRun',  }}
  use {'b3nj5m1n/kommentary'}
  use {'lambdalisue/suda.vim', cmd = { 'SudaRead', 'SudaWrite' }}
  use {'nathanaelkane/vim-indent-guides'}
  use {'DougBeney/pickachu', cmd = { 'Pick', 'Pickachu' }}
  use {'tmsvg/pear-tree'}
  use {'tpope/vim-surround'}
  use {'folke/which-key.nvim'}
  use {'ferrine/md-img-paste.vim'}
  use {'mechatroner/rainbow_csv', ft = { 'csv' }}
  use {'kristijanhusak/vim-dadbod-ui', cmd = { 'DBUI', 'DB' }}
  use {'tpope/vim-dadbod', cmd = { 'DBUI', 'DB' }}
  use {'mg979/vim-visual-multi'}
  use {'nvim-lua/plenary.nvim'}
  use {'kevinhwang91/nvim-bqf'}
  use {'weirongxu/plantuml-previewer.vim', ft = 'plantuml'}
  use {'tyru/open-browser.vim', cmd = { 'OpenBrowser', 'OpenBrowserSearch', 'OpenBrowserSmartSearch' }}
  use {'lervag/vimtex', ft = { 'tex', 'bib', 'pdc', 'pandoc' }}
  use {'daeyun/vim-matlab', ft = { 'matlab', 'octave' }}
  use {'liuchengxu/graphviz.vim', ft = { 'dot' } }
  use {'vim-pandoc/vim-pandoc', ft = { 'pandoc', 'pdc', 'markdown' },  cmd = { 'Pandoc' }}
  use {'vim-pandoc/vim-pandoc-syntax', ft = { 'pandoc', 'pdc', 'md', 'markdown' },  cmd = { 'Pandoc' }}
  use {'nvim-treesitter/nvim-treesitter', un = ':TSUpdate'}
  use {'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle'}
  use {'nvim-treesitter/nvim-treesitter-refactor'}
  use {'p00f/nvim-ts-rainbow'}
  use {'kristijanhusak/orgmode.nvim', ft = 'org'}
  use {'kristijanhusak/orgmode.nvim'}
  use {'~/Projects/vim-dev/nvim-bufferline.lua', }
  use {'nathangrigg/vim-beancount', ft = {'beancount'}}
  use {'gelguy/wilder.nvim'}
  -- use {'lewis6991/impatient.nvim', rocks = 'mpack'}
end)

