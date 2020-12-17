if !has("nvim")
    set nocompatible              " be iMproved, required
endif
filetype off                  " required

" set the runtime path to include Vundle and initialize
if has("nvim")
    call plug#begin('~/.nvim/bundle')
else
    call plug#begin('~/.vim/bundle')
endif
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
"Plug 'frankier/neovim-colors-solarized-truecolor-only'
Plug 'lifepillar/vim-solarized8'
Plug 'vimwiki/vimwiki'
Plug 'benekastah/neomake'
Plug 'neovimhaskell/haskell-vim'
Plug 'tpope/vim-surround'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'christoomey/vim-tmux-navigator'
Plug 'udalov/kotlin-vim'
Plug 'itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf.vim'
call plug#end()

filetype plugin indent on

syntax on

let g:lightline = {
\ 'colorscheme': 'solarized',
\ 'active': {
\   'left': [ [ 'mode', 'paste' ],
\             [ 'readonly', 'filename', 'modified' ] ]
\ }
\ }

let mapleader=','
nnoremap \ ,

set ttimeout
set ttimeoutlen=0

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set history=1000		" keep 50 lines of command line history
set undofile
set undolevels=1000
set undoreload=1000
set undodir=$HOME/.vimundo/
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set showmode
set incsearch		" do incremental searching
set hlsearch
set number
" Setting tabulator key to 4 spaces
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

set clipboard=unnamedplus

set splitright " Put vertical splits to the right.

" Allow to hide modified buffers.
set hidden

" Don't auto de-indent labels (std:)
set cinoptions+=L0
" Don't auto indent public: and private:
set cinoptions+=g0

" show wildmenu
set wildmenu
set wildmode=list:longest

" save temp-files in a central folder
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

set ignorecase
set smartcase

if has("nvim")
    " live replace
    set inccommand=nosplit
endif

" The Silver Searcher
" if executable('ag')
"   " Use ag over grep
"   set grepprg=ag\ --nogroup\ --nocolor
" else
"     set grepprg=grep\ -nH\ $*
" endif

" bind K to grep word under cursor
nnoremap K :set noincsearch<CR>:grep! "\b<C-R><C-W>\b"<CR>:cw<CR>:set incsearch<CR>

" search in current directory and work up the tree towards root until one is
" found
set tags+=.git/tags
set tags+=tags
set tags+=TAGS

if ! exists('g:TagHighlightSettings')
    let g:TagHighlightSettings = {}
endif
let g:TagHighlightSettings['TagFileName'] = '.git/tags'
let g:TagHighlightSettings['TypesFileDirectory']=".git"

" allow unsing the mouse
set mouse=a
" always show statusline
set laststatus=2

" fugitive status line
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" show invisible characters
set list
" som alternatives: tab:▸\,eol:¬
set listchars=tab:\|\ ,trail:…

" clear trailing spaces on save
"autocmd BufWritePre * kz|:%s/\s\+$//e|'z

" Latex settings
let g:tex_flavor='latex'

let g:localvimrc_ask = 1
" enable mouse inside vimwiki
let g:vimwiki_use_mouse=1

let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

let g:xml_syntax_folding=1

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    au BufRead,BufNewFile *.he  set filetype=c
    au BufRead,BufNewFile *.hdb  set filetype=c
    au BufRead,BufNewFile *.cu  set filetype=c

    au BufRead,BufNewFile *.moon set filetype=lua
    au BufRead,BufNewFile Jenkinsfile* setfiletype groovy
    au BufRead,BufNewFile Jenkinsfile* set noexpandtab

    au BufRead,BufNewFile *.ts set filetype=typescript

    au BufRead,BufNewFile *.yaml.j2 set filetype=yaml
    au BufRead,BufNewFile *.yml.j2 set filetype=yaml
    au BufRead,BufNewFile *.json.j2 set filetype=json
    au FileType go set noexpandtab

    au FileType ruby nnoremap <leader>rr :!ruby %<CR>


    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 78 characters.
        "autocmd FileType text setlocal textwidth=78

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        autocmd BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif

    augroup END

    autocmd FileType ruby set sw=2 ts=2
    autocmd FileType lua set sw=2 ts=2
    autocmd FileType c set sw=2 ts=2
    autocmd FileType json set sw=2 ts=2
    autocmd FileType yaml set sw=4 ts=4
    autocmd FileType javascript set sw=2 ts=2
    autocmd FileType cpp,c set comments^=b:///
    autocmd FileType groovy set expandtab
    autocmd FileType groovy set sw=4

    au BufWinLeave *.* mkview
    au BufWinEnter *.* silent! loadview


    " enable vimwiki foldings
    autocmd FileType vimwiki let g:vimwiki_folding=1
    autocmd FileType vimwiki let g:vimwiki_fold_lists=1

    " shortcut go to last active tab
    let g:lasttab = 1
    nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
    au TabLeave * let g:lasttab = tabpagenr()


endif " has("autocmd")

" let g:tex_isk="48-57,a-z,A-Z,_,:,192-255"
function! SetupLatex()
    nnoremap <leader>rr :!make pdf<CR>
    nnoremap ]] :/label{.*:\zs.*\ze}<CR>
    nnoremap [[ :?label{.*:\zs.*\ze}<CR>
endfunction

function! SetupPython()
    nnoremap <leader>rr :w<CR>:!python %<CR>
    call neomake#configure#automake('w')
endfunction

function! SetupJavascript()
    nnoremap <leader>rr :w<CR>:!NODE_ENV=test mocha %<CR>
    nnoremap <leader>ra :w<CR>:!make test<CR>
endfunction

function! SetupJava()
    nnoremap <leader>rr :w<CR>:!gradle check<CR>
    set noexpandtab
endfunction

function! SetupHaskell()
    set grepprg=hg\ $*\ --color=never
    nnoremap <leader>rr :Neomake remote<CR>
    nnoremap <leader>rt :botright new<CR>:terminal scripts/build-remotely.sh test<CR>
    set foldmethod=indent
    set foldopen-=block
endfunction

if has("autocmd")
    au FileType python call SetupPython()
    au FileType javascript call SetupJavascript()
    au FileType java call SetupJava()
    au FileType haskell call SetupHaskell()
endif

" open NERDtree
map <Leader>n :NERDTreeToggle<CR>
map <Leader>rf :NERDTreeFind<CR>

" easy copy and paste with gui-clipboard
map <Leader>p "+p
map <Leader>P "+P
map <Leader>]p "+]p
map <Leader>]P "+]P
map <Leader>y "+y
vmap <Leader>y "+y
map <Leader>d "+d
vmap <Leader>d "+d

nmap <Leader>tn :tabnew<CR>

nmap <silent> <leader>+ :resize +4<CR>
nmap <silent> <leader>- :resize -4<CR>
nmap <silent> + :vertical resize +4<CR>
nmap <silent> - :vertical resize -4<CR>

nnoremap <Leader>cc :make %<Return>:cw<Return>
nnoremap <Leader>cp :cprevious<Return>
nnoremap <Leader>cn :cnext<Return>

map <silent> <Leader>lp :lprevious<Return>
map <silent> <Leader>ln :lnext<Return>

"autocmd FileType java set foldmethod=syntax
map <silent> <Leader>zz :set foldmethod=syntax<CR>:set foldmethod=manual<CR>

" edit nvimrc
nnoremap <Leader>rc :e $MYVIMRC<CR>
" load nvimrc
nnoremap <Leader>rl :so $MYVIMRC<CR>

" some mappings for easy folding
nmap <silent> <Leader>f0 :set foldlevel=0<CR>
nmap <silent> <Leader>f1 :set foldlevel=1<CR>
nmap <silent> <Leader>f2 :set foldlevel=2<CR>
nmap <silent> <Leader>f3 :set foldlevel=3<CR>
nmap <silent> <Leader>f4 :set foldlevel=4<CR>
nmap <silent> <Leader>f5 :set foldlevel=5<CR>
nmap <silent> <Leader>f6 :set foldlevel=6<CR>
nmap <silent> <Leader>f7 :set foldlevel=7<CR>
nmap <silent> <Leader>f8 :set foldlevel=8<CR>
nmap <silent> <Leader>f9 :set foldlevel=9<CR>

" map ' to ` and vice versa
nnoremap ' `
nnoremap ` '

" Don't allow gitgutter to map keys.
let g:gitgutter_map_keys = 0

nnoremap <C-P> :FZF<CR>

" map to switch off hlsearch
nnoremap <silent> <leader>h :silent :nohlsearch<CR>

" center search results
" nnoremap n nzz
" nnoremap N Nzz
" nnoremap * *zz
" nnoremap # #zz
" nnoremap g* g*zz
" nnoremap g# g#zz
nnoremap ]] ]]zz
nnoremap [[ [[zz

" go to first tab
nnoremap <silent> g0 :tabfirst<CR>
" go to last tab
nnoremap <silent> g$ :tablast<CR>

nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>

nnoremap <C-@> <C-^>

" keep in visual-mode after shifting with >/<
vnoremap > >gv
vnoremap < <gv
noremap <Up> gk
noremap <Down> gj

" Do not move when using *
nnoremap <silent> * :let star_view=winsaveview()<CR>*:call winrestview(star_view)<CR>

" Open tags in vertical splits
nnoremap <C-w>] :vsp<CR>:exec("tag ".expand("<cword>"))<CR>

nnoremap <C-g> :execute "Ggrep '\\<" . expand('<cword>') . "\\>'"<CR>

function! GitReplaceWord(to_replace, replacement)
    execute "!git grep -l '\\<" . a:to_replace . "\\>' | xargs sed -i 's/\\b" .  a:to_replace . "\\b/" . a:replacement . "/g'"
endfunction

command! -nargs=* Greplace call GitReplaceWord(<f-args>)

function! GitReplaceWordUnderCursor()
    let to_replace = expand('<cword>')
    let replacement = input('Replace ' . to_replace .' with: ')
    call GitReplaceWord(to_replace, replacement)
endfunction

" Interactively replace word under cursor using git and sed.
nnoremap <silent> gr :call GitReplaceWordUnderCursor()<CR>

command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis


let g:neomake_haskell_enabled_makers = ['hlint']
" autocmd! BufWritePost * Neomake

let g:neomake_haskell_remote_maker = {
    \ 'exe': './scripts/build-remotely.sh',
    \ 'args': ['build'],
    \ 'append_file': 0,
    \ 'errorformat': '%E%f:%l:%c: %m,'.'%W%f:%l:c: Warning: %m,'.'%C%m'
    \ }
let g:neomake_ft_maker_remove_invalid_entries = 1

let g:neomake_tex_enabled_makers = ['chktex']

" let g:neomake_java_enabled_makers = ['gradle']

if has("nvim")
    tnoremap <C-l> <C-\><C-n><C-w><C-l>
    tnoremap <C-h> <C-\><C-n><C-w><C-h>
    tnoremap <C-j> <C-\><C-n><C-w><C-j>
    tnoremap <C-k> <C-\><C-n><C-w><C-k>

    au WinEnter * if &buftype == 'terminal' | startinsert | endif
endif

let g:haskell_indent_if = 3
let g:haskell_indent_case = 2
let g:haskell_indent_let = 4
let g:haskell_indent_where = 2
let g:haskell_indent_do = 3
let g:haskell_indent_in = 1

" if has('nvim') && executable('$HOME/bin/nvim-hs-devel.sh')
"     call rpcrequest(rpcstart(expand('$HOME/bin/nvim-hs-devel.sh')), "PingNvimhs")
" endif

let g:gutentags_enabled=0

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=light
set termguicolors
colorscheme solarized8
"colorscheme default

" coc adjustments
set updatetime=300
set cmdheight=2
set shortmess+=c
set signcolumn=yes


" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

inoremap <silent><expr> <c-space> coc#refresh()

if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

inoremap <silent><expr> <TAB>
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ pumvisible() ? coc#_select_confirm() :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gu <Plug>(coc-references)
nmap <silent> gb <C-o>
nmap <silent> gf <C-i>
nnoremap <silent> gm  :<C-u>CocList outline<cr>
nnoremap <silent> gM  :<C-u>CocList -I symbols<cr>

nmap <silent> gE <Plug>(coc-diagnostic-prev)
nmap <silent> ge <Plug>(coc-diagnostic-next)
nmap <Leader>af :call CocAction('format')<CR>

" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
nmap <leader>ar <Plug>(coc-rename)
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

nmap <Leader>u i<c-r>=substitute(system('uuidgen'),'[\r\n]*$','','')<cr><esc>
