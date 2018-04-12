set encoding=utf-8
set runtimepath+=~/.vim_runtime

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Installed plugins
Plugin 'gmarik/Vundle.vim'
Plugin 'valloric/youcompleteme'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'google/yapf'
Plugin 'jmcantrell/vim-virtualenv'
Plugin 'bufexplorer.zip'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'mattesgroeger/vim-bookmarks'
Plugin 'vimwiki/vimwiki'
Plugin 'morhetz/gruvbox'
Plugin 'w0rp/ale'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set t_Co=256
set background=dark
colorscheme gruvbox

" Powerline plugin installed using pip
set rtp+=/usr/local/lib/python3.5/dist-packages/powerline/bindings/vim/
set laststatus=2

" NERDTree settings
"  - open with ctrl-n
"  - open on left side
"  - display it if vim started with no arguments
"  - close on :q if NERDTree is single
map <C-n> :NERDTreeToggle<cr>
let g:NERDTreeWinPos = 'left'
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" Display line numbers and highlist search maches
set number
set hlsearch

" Move between splits easily
map <C-left> <C-w>h
map <C-down> <C-w>j
map <C-right> <C-w>l
map <C-up> <C-w>k
set splitright
set splitbelow

" Find files and bookmarks
let g:ctrlp_map = '<C-f>'
let g:bookmark_no_default_key_mappings = 1
let g:bookmark_highlight_lines = 1
let g:bookmark_auto_save = 0
nmap <leader>b <Plug>BookmarkToggle
nmap <leader>a <Plug>BookmarkShowAll

try
    set undodir=~/.vimundodir
    set undofile
catch
endtry

" Enable folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" Be smart when using tabs ;)
set expandtab
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set backspace=indent,eol,start

" YCM and ALE configs
let g:ycm_python_binary_path = 'python'
let g:ycm_auto_trigger = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:virtualenv_auto_activate = 1
au BufNewFile,BufRead *.py call ActivateVirtualEnv()
let g:ale_linters={ 'python': ['pylint'] }
" let g:ale_python_pylint_executable='pylint --rcfile=/home/raducruceru/.pylintrc'
let g:ale_sign_column_always = 1
let g:ale_set_loclist = 1
let g:ale_open_list = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let python_highlight_all=1
syntax on


function! ActivateVirtualEnv()
	if strlen($VIRTUAL_ENV)==0
		echo "returned"
		return
	endif
py3 << EOF
import vim
import sys
p = ":".join([p for p in sys.path if p])
vim.command("let pp='%s'" % p)
EOF
let $PYTHONPATH=pp
let g:ycm_python_binary_path=$VIRTUAL_ENV."/bin/python"
endfunction



"===========================
"Taken from amix/vimrc files
"===========================

" Sets how many lines of history VIM has to remember
set history=500

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Set to auto read when a file is changed from the outside
set autoread

let g:LocalLeader = '\\'
let mapleader = "\\"
let g:mapleader = "\\"
nnoremap <leader><leader> :nohl<CR>

" Fast saving
nmap <leader>w :w!<cr>

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" Makes search act like search in modern browsers
set incsearch 

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch 
" How many tenths of a second to blink when matching brackets
set mat=2

" Indentation
set ai 
set si

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a"<esc>`<i"<esc>

" Map auto complete of (, ", ', [
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i

""""""""""""""""""""""""""""""
" => bufExplorer plugin
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>

" Display file position in NERDTree
map <leader>nf :NERDTreeFind<cr>
let NERDTreeShowHidden=1
let NERDTreeWinSize=31
