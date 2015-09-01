set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdtree'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'mmozuras/snipmate-mocha'
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-scripts/vimwiki'
Plugin 'Shutnik/jshint2.vim'
Plugin 'scrooloose/syntastic'
Plugin 'janko-m/vim-test'
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'raichoo/purescript-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

syntax on
let mapleader=','
nnoremap \ ,

set t_Co=16
set background=light
colorscheme solarized
call togglebg#map("<F5>")

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

set grepprg=grep\ -nH\ $*

" search in current directory and work up the tree towards root until one is
" found
set tags=.git/tags

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
    autocmd FileType javascript set sw=2 ts=2
    autocmd FileType cpp,c set comments^=b:///

    au BufWinLeave *.* mkview
    au BufWinEnter *.* silent! loadview


    " enable vimwiki foldings
    autocmd FileType vimwiki let g:vimwiki_folding=1
    autocmd FileType vimwiki let g:vimwiki_fold_lists=1

    autocmd FileType java set makeprg=ant
    autocmd FileType java set efm=\ %#[javac]\ %#%f:%l:%c:%*\\d:\ %t%[%^:]%#:%m,\%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#

    " shortcut go to last active tab
    let g:lasttab = 1
    nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
    au TabLeave * let g:lasttab = tabpagenr()


endif " has("autocmd")

let g:tex_isk="48-57,a-z,A-Z,_,:,192-255"
function! SetupLatex()
    nnoremap <leader>rr :!make pdf<CR>
    nnoremap ]] :/label{.*:\zs.*\ze}<CR>
    nnoremap [[ :?label{.*:\zs.*\ze}<CR>
endfunction

function! SetupPython()
    nnoremap <leader>rr :w<CR>:!python %<CR>
endfunction

function! SetupJavascript()
    nnoremap <leader>rr :w<CR>:!NODE_ENV=test mocha %<CR>
    nnoremap <leader>ra :w<CR>:!make test<CR>
endfunction

function! SetupJava()
    nnoremap <leader>rr :w<CR>:!gradle check<CR>
endfunction

if has("autocmd")
    au FileType python call SetupPython()
    au FileType javascript call SetupJavascript()
    au FileType tex call SetupLatex()
    au FileType java call SetupJava()
endif

" open NERDtree
map <Leader>n :NERDTreeToggle<CR>

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

map <silent> <Leader>cc :make %<Return>:cw<Return>
map <silent> <Leader>cp :cprevious<Return>
map <silent> <Leader>cn :cnext<Return>

map <silent> <Leader>lp :lprevious<Return>
map <silent> <Leader>ln :lnext<Return>

"autocmd FileType java set foldmethod=syntax
map <silent> <Leader>zz :set foldmethod=syntax<CR>:set foldmethod=manual<CR>

" edit nvimrc
map <silent> <Leader>rc :e ~/.nvimrc<CR>
" load nvimrc
map <silent> <Leader>rl :so ~/.nvimrc<CR>

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

nnoremap K k

" Don't allow gitgutter to map keys.
let g:gitgutter_map_keys = 0

" Custom ctrlp command.
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

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

" keep in visual-mode after shifting with >/<
vnoremap > >gv
vnoremap < <gv
noremap <Up> gk
noremap <Down> gj

" Do not move when using *
nnoremap <silent> * :let star_view=winsaveview()<CR>*:call winrestview(star_view)<CR>

"nnoremap <C-g> :execute "Ggrep '\\<" . expand('<cword>') . "\\>'"<CR>

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

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_tex_checkers = ['chktex']

if has("nvim")
    tnoremap <C-l> <C-\><C-n><C-w><C-l>
    tnoremap <C-h> <C-\><C-n><C-w><C-h>
    tnoremap <C-j> <C-\><C-n><C-w><C-j>
    tnoremap <C-k> <C-\><C-n><C-w><C-k>

    au WinEnter * if &buftype == 'terminal' | startinsert | endif
endif


if has('nvim') && executable('$HOME/bin/nvim-hs-devel.sh')
    call rpcrequest(rpcstart(expand('$HOME/bin/nvim-hs-devel.sh')), "PingNvimhs")
endif
