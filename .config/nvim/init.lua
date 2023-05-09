-- Plugins
local execute = vim.api.nvim_command
local keymap = vim.api.nvim_set_keymap

local install_path = vim.fn.stdpath('data') ..
                         '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' ..
                install_path)
end

vim.cmd([[
    augroup Packer
        autocmd!
        autocmd BufWritePost init.lua PackerCompile
    augroup end
]])

vim.o.background = 'light'

local use = require('packer').use
require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- Package manager
    use 'airblade/vim-rooter' -- change cwd to git root

    use 'tpope/vim-fugitive' -- Git commands in nvim
    use 'sbdchd/neoformat' -- format everything

    -- ui
    use 'shaunsingh/solarized.nvim'
    use 'hoob3rt/lualine.nvim' -- status line
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}} -- git signs

    -- navigation
    use 'junegunn/fzf.vim' -- fuzzy finder
    use 'junegunn/fzf' -- fuzzy finder
    use 'christoomey/vim-tmux-navigator' -- move between tmux & vim windows with same shortcuts
    use 'dyng/ctrlsf.vim' -- find string in whole project
    use {'kyazdani42/nvim-tree.lua'} -- file explorer
    use {'kevinhwang91/nvim-bqf', ft = 'qf'}

    -- typing stuff
    use 'tpope/vim-commentary' -- Code Comment stuff, f.ex gc
    use 'ntpeters/vim-better-whitespace' -- show trailing whitespaces in red
    use 'tpope/vim-surround' -- surround operations
    use 'editorconfig/editorconfig-vim' -- use tabstop / tabwidth from .editorconfig
    use 'tpope/vim-unimpaired' -- complementary pairs of mappings

    -- autocomplete
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path',
            'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip'
        }
    }

    -- lsp
    use 'neovim/nvim-lspconfig' -- lsp configs for builtin language server client
    use { -- show diagnostics, f.ex. eslint
        'iamcco/diagnostic-languageserver',
        requires = {'creativenull/diagnosticls-configs-nvim'}
    }
    use 'simrat39/rust-tools.nvim' -- additional rust analyzer tools, f.ex show types in method chain
    use 'ray-x/lsp_signature.nvim' -- show signature while typing method
    use 'arkav/lualine-lsp-progress' -- lsp progress in statusline
    use 'folke/lsp-colors.nvim' -- better inline diagnostics

    -- Remove after https://github.com/OmniSharp/omnisharp-roslyn/issues/2238 is fixed
    use 'Hoffs/omnisharp-extended-lsp.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'

    -- tree sitter
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'} -- syntax tree parser
    use 'windwp/nvim-ts-autotag' -- close html tags via treesitter
    use 'nvim-treesitter/nvim-treesitter-refactor'
    use 'JoosepAlviste/nvim-ts-context-commentstring'
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    -- cool but really slow
    -- use 'haringsrob/nvim_context_vt' -- show context on closing brackets
    -- use 'romgrk/nvim-treesitter-context' -- show method context
    use 'vimwiki/vimwiki'
    use 'aklt/plantuml-syntax'
end)

-- https://github.com/hrsh7th/nvim-compe#how-to-remove-pattern-not-found
vim.o.shortmess = vim.o.shortmess .. 'c'

-- Incremental live completion
vim.o.inccommand = "nosplit"

vim.g.do_filetype_lua = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menu,menuone,noselect"

-- Map blankline
vim.o.list = true;
vim.o.listchars = 'tab:| ,trail:•'

-- Set highlight on search
vim.o.hlsearch = true
vim.o.incsearch = true

-- hide default mode
vim.o.showmode = false

-- Make line numbers default
vim.wo.number = true

-- Do not save when switching buffers
vim.o.hidden = true

-- Cooler backspace
vim.o.backspace = 'indent,eol,start'

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

vim.o.smartindent = true

-- Cooler tabs
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
-- Don't expand tabs in golang files
vim.cmd([[
    augroup NoExpandTab
        autocmd!
        autocmd FileType go setlocal noexpandtab
        autocmd FileType groovy setlocal noexpandtab
    augroup end
]])

-- secure settings for gopass
vim.cmd([[
    augroup Gopass
        autocmd!
        autocmd BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile
    augroup end
]])

-- rust autocommands
vim.cmd([[
    augroup Rust
        autocmd!
        autocmd BufWritePre *.rs Neoformat
    augroup end
]])

-- Don't insert two spaces after a sentence.
vim.o.joinspaces = false

-- Save undo history
vim.o.undofile = true
vim.o.undolevels = 1000
vim.o.undoreload = 1000
vim.o.undodir = vim.fn.expand('$HOME') .. '/.vimundo'

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Put vertical splits to the right
vim.o.splitright = true

-- use ripgrep
vim.o.grepprg="rg --vimgrep --no-heading --smart-case"
vim.o.grepformat="%f:%l:%c:%m,%f:%l:%m"

if vim.fn.has('termguicolors') then vim.o.termguicolors = true end

require('solarized').set()

-- Remap , as leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","
keymap('n', '\\', ',', {noremap = true, silent = true})

-- Highlight on yank
vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])

vim.cmd([[
  augroup LoadView
    autocmd!
    autocmd BufWinLeave *.* mkview
    autocmd BufWinEnter *.* silent! loadview
  augroup end
]])

-- ctrlsf
vim.g.ctrlsf_auto_preview = 1
vim.g.ctrlsf_auto_focus = {at = 'start'}
vim.g.ctrlsf_mapping = {next = 'n', prev = 'N'}

-- key mapping

keymap("n", "Y", 'y$', {silent = true, noremap = true})
keymap("n", "ZW", ':w<CR>', {silent = true, noremap = true})
keymap("n", "<leader>f", ':grep <C-R><C-W><CR>', {noremap = true})
keymap("v", "<leader>f", 'y:grep <C-R>0<CR>', {noremap = true})
keymap("n", "<leader>au", ':UndotreeToggle<CR>', {silent = true, noremap = true})
keymap("n", "<leader>as", ':CtrlSF ', {noremap = true})
keymap("n", "<leader>af", ':Neoformat<CR>', {noremap = true})
keymap("n", "<leader>p", '"+p', {noremap = true})
keymap("n", "<leader>P", '"+P', {noremap = true})
keymap("v", "<leader>p", '"+p', {noremap = true})
keymap("v", "<leader>P", '"+P', {noremap = true})
keymap("n", "<leader>y", '"+y', {noremap = true})
keymap("v", "<leader>y", '"+y', {silent = true, noremap = true})
keymap("n", "<leader>d", '"+d', {noremap = true})
keymap("v", "<leader>d", '"+d', {silent = true, noremap = true})
keymap("n", "<leader>tn", ':tabnew<CR>', {silent = true, noremap = true})
keymap("n", "<leader>+", ':resize +4<CR>', {silent = true, noremap = true})
keymap("n", "<leader>-", ':resize -4<CR>', {silent = true, noremap = true})
keymap("n", "+", ':vertical resize +4<CR>', {silent = true, noremap = true})
keymap("n", "-", ':vertical resize -4<CR>', {silent = true, noremap = true})
keymap("n", "<C-N>", ':GFiles --cached --others --exclude-standard<CR>',
       {silent = true, noremap = true})
keymap("n", "<C-P>", ':Files<CR>', {silent = true, noremap = true})
keymap("n", "<leader>b", ':Buffers<CR>', {silent = true, noremap = true})
keymap("n", "<leader>e", ':NvimTreeFindFileToggle<CR>',
       {silent = true, noremap = true})
keymap("n", "<leader>n", ':NvimTreeFindFileToggle<CR>',
       {silent = true, noremap = true})
-- FIXME: clashes with gitsign mappings, see :map ,h
keymap("n", "<leader>hc", ":nohlsearch<CR>", {silent = true, noremap = true})
-- easily edit and reload init.lua
keymap("n", "<leader>rc", ":edit $MYVIMRC<CR>", {silent = true, noremap = true})
keymap("n", "<leader>rl", ":source $MYVIMRC<CR>",
       {silent = true, noremap = true})
-- swap ' and `
keymap("n", "'", "`", {silent = true, noremap = true})
keymap("n", "`", "'", {silent = true, noremap = true})

-- simplified window switching
keymap("n", "<C-l>", "<C-w><C-l>", {silent = true, noremap = true})
keymap("n", "<C-h>", "<C-w><C-h>", {silent = true, noremap = true})
keymap("n", "<C-j>", "<C-w><C-j>", {silent = true, noremap = true})
keymap("n", "<C-k>", "<C-w><C-k>", {silent = true, noremap = true})

-- stay in visual mode after shifting
keymap("v", ">", ">gv", {silent = true, noremap = true})
keymap("v", "<", "<gv", {silent = true, noremap = true})

-- do not move when using *
keymap("n", "*",
       ":let star_view=winsaveview()<CR>*:call winrestview(star_view)<CR>",
       {silent = true, noremap = true})

keymap("n", "<C-@>", "<C-^>", {silent = true, noremap = true})

-- weird uuid mappings
keymap("n", "<Leader>u",
       'a<c-r>=substitute(system("uuidgen"),"[\\r\\n]*$","","")<CR><ESC>',
       {silent = true, noremap = true})
keymap("v", "<Leader>u",
       "\"_s<c-r>=substitute(system('uuidgen'),'[\\r\\n]*$','','')<CR><ESC>",
       {silent = true, noremap = true})
keymap("i", "<c-x><c-f>", "<plug>(fzf-complete-file)", {silent = true, noremap = true})

-- luochen1990/rainbow
vim.g.rainbow_active = 1

-- ntpeters/vim-better-whitespace
vim.g.better_whitespace_enabled = 1

-- undo tree
vim.g.undotree_WindowLayout = 2
vim.g.undetree_SetFocusWhenToggle = 1

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end


  -- Default mappings. Feel free to modify or remove as you wish.
  --
  -- BEGIN_DEFAULT_ON_ATTACH
  vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
  vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
  vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
  vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
  vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
  vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
  vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
  vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
  vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
  vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
  vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
  vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
  vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
  vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
  vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
  vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
  vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
  vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
  vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
  vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
  vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
  vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
  vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
  vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
  vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
  vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
  vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
  vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
  vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
  vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
  vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
  vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
  vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
  vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
  vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
  vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
  vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
  vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
  vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
  vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
  vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
  vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
  vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
  vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
  vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
  -- END_DEFAULT_ON_ATTACH


  -- Mappings migrated from view.mappings.list
  --
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
  vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling'))
  vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts('Next Sibling'))
  vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
  vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
  vim.keymap.set('n', '<S-CR>', api.node.navigate.parent_close, opts('Close Directory'))
  vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open Preview'))
  vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts('First Sibling'))
  vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling'))
  vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
  vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
  vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
  vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
  vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
  vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
  vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
  vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
  vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
  vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
  vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
  vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
  vim.keymap.set('n', '}c', api.node.navigate.git.next, opts('Next Git'))
  vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
  vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))

end

-- file drawer
local tree_cb = require'nvim-tree.config'.nvim_tree_callback
require'nvim-tree'.setup {
    filters = {custom = {".git", "node_modules", ".cache"}},
    on_attach = on_attach,
    view = {
        side = "left",
        width = 30
    },
    renderer = {
        icons = {
            glyphs = {
                folder = {
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = ""
                }
            },
            show = {
                git = false,
                folder = true,
                file = false
            }
        }
    }
}

local cmp = require 'cmp'

cmp.setup({
    snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({{name = 'nvim_lsp'}, {name = 'path'}})
})

-- gitsigns

require('gitsigns').setup()

-- statusbar

require'lualine'.setup {
    options = {
        icons_enabled = false,
        theme = 'solarized',
        component_separators = {'|', '|'},
        section_separators = {'', ''},
        disabled_filetypes = {}
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {{'filename', file_status = true, path = 1}},
        lualine_c = {
            {
                'diagnostics',
                sources = {'nvim_diagnostic'},
                symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'}
            }, {
                'lsp_progress',
                color = {use = false},
                display_components = {{'title', 'percentage', 'message'}}
            }
        },
        lualine_x = {
            function()
                local clients = {}
                for _, client in pairs(vim.lsp.buf_get_clients()) do
                    table.insert(clients, client.name)
                end
                return table.concat(clients, ' ')
            end
        },
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
}

local nvim_lsp = require 'lspconfig'
local on_attach = function(client, bufnr)
    local function buf_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    require'lsp_signature'.on_attach({
        bind = true,
        doc_lines = 0,
        floating_window = true,
        hint_enable = false,
        handler_opts = {border = 'none'},
        extra_trigger_chars = {"(", ","}
    })

    buf_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>',
               {silent = true, noremap = true})
    buf_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>',
               {silent = true, noremap = true})
    buf_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>',
               {silent = true, noremap = true})
    buf_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>',
               {silent = true, noremap = true})
    buf_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>',
               {silent = true, noremap = true})
    buf_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', {silent = true, noremap = true})
    buf_keymap('n', '<leader>gr',
               '<cmd>lua vim.lsp.buf.incoming_calls({includeDeclaration = false})<CR>',
               {silent = true, noremap = true})
    buf_keymap('n', 'gm', '<cmd>lua vim.lsp.buf.document_symbol()<CR>',
               {silent = true, noremap = true})
    buf_keymap('n', 'gM', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>',
               {silent = true, noremap = true})
    buf_keymap('n', '<leader>ar', '<cmd>lua vim.lsp.buf.rename()<CR>',
               {silent = true, noremap = true})
    buf_keymap('n', '<leader>aa', '<cmd>lua vim.lsp.buf.code_action()<CR>',
               {silent = true, noremap = true})
    buf_keymap('v', '<leader>aa',
               '<cmd>lua vim.lsp.buf.range_code_action()<CR>',
               {silent = true, noremap = true})
    buf_keymap('n', '<leader>aF', '<cmd>lua vim.lsp.buf.formatting()<CR>',
               {silent = true, noremap = true})
    buf_keymap('n', '<leader>dl',
               '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>',
               {silent = true, noremap = true})
    buf_keymap('n', ']d',
               '<cmd>lua vim.diagnostic.goto_next({float = false})<CR>',
               {silent = true, noremap = true})
    buf_keymap('n', '[d',
               '<cmd>lua vim.diagnostic.goto_prev({float = false})<CR>',
               {silent = true, noremap = true})
    buf_keymap('n', '<leader>dd', '<cmd>lua vim.diagnostic.setloclist()<CR>',
               {silent = true, noremap = true})
end

require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    highlight = {enable = true},
    autotag = {enable = true},
    indent = {enable = false},
    context_commentstring = {enable = true},
    refactor = {highlight_definitions = {enable = true}},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = ".",
            scope_incremental = ";",
            node_decremental = "g."
        }
    },
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner"
            }
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer"
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer"
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer"
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer"
            }
        }
    }
}

local eslint = require 'diagnosticls-configs.linters.eslint'
require'diagnosticls-configs'.setup {
    ['typescript'] = {linter = eslint},
    ['typescriptreact'] = {linter = eslint}
}
require'diagnosticls-configs'.init {on_attach = on_attach}

-- Enable the following language servers
local servers = {'gopls', 'rust_analyzer', 'tsserver', 'pyright'}
for _, lsp in ipairs(servers) do
    local caps = vim.lsp.protocol.make_client_capabilities()
    caps.textDocument.completion.completionItem.snippetSupport = true
    caps.textDocument.completion.completionItem.resolveSupport = {
        properties = {'documentation', 'detail', 'additionalTextEdits'}
    }

    caps = require('cmp_nvim_lsp').default_capabilities(caps)

    nvim_lsp[lsp].setup {on_attach = on_attach, capabilities = caps}
end

local pid = vim.fn.getpid()
local omnisharp_bin = "/usr/bin/omnisharp"
local caps = vim.lsp.protocol.make_client_capabilities()
caps = require('cmp_nvim_lsp').default_capabilities(caps)
require'lspconfig'.omnisharp.setup {
    on_attach = on_attach,
    capabilities = caps,
    handlers = {
        ["textDocument/definition"] = require('omnisharp_extended').handler
    },
    cmd = {omnisharp_bin, "--languageserver", "--hostPID", tostring(pid)}
}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.lua_ls.setup {
    on_attach = on_attach,
    caps = caps,
    settings = {
        Lua = {
            runtime = {version = 'LuaJIT', path = runtime_path},
            diagnostics = {globals = {'vim'}},
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
            },
            telemetry = {enable = false}
        }
    }
}

require'rust-tools'.setup({
    server = {on_attach = on_attach, capabilities = caps}
})

vim.g.fzf_layout = {down = '50%'}

vim.g.localvimrc_ask = 1
-- mouse inside vimwiki
vim.g.vimwiki_use_mouse = 1

vim.g.vimwiki_list = {
    {path = '~/vimwiki/', syntax = 'markdown', ext = '.md', index = 'home'},
    {path = '~/vimwiki-work/', syntax = 'markdown', ext = '.md', index = 'home'}
}

vim.g.vimwiki_key_mappings = {table_format = 0}
vim.g.vimwiki_listsyms = ' .oOx'

vim.cmd([[
    augroup Vimwiki
        autocmd!
        autocmd FileType vimwiki nnoremap <buffer><silent> <C-]> :VimwikiVSplitLink<CR>
    augroup end
]])

vim.g.neoformat_rust_rustfmt = {
    exe = 'rustfmt',
    args = {'--edition 2021'},
    stdin = 1
}

vim.g.neoformat_markdown_prettier = {
    exe = 'prettier',
    args = {'--stdin-filepath', '"%:p"'},
    stdin = 1,
    try_node_exe = 1
}

vim.g.neoformat_vimwiki_prettier = {
    exe = 'prettier',
    args = {'--stdin-filepath', '"%:p"'},
    stdin = 1,
    try_node_exe = 1
}

vim.g.neoformat_enabled_rust = {'rustfmt'}
vim.g.neoformat_enabled_markdown = {'prettier'}
vim.g.neoformat_enabled_vimwiki = {'prettier'}
