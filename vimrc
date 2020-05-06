
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-commentary' " comment stuff with gc / gcc commands. love it!
Plug 'sjl/gundo.vim'        " visual tree undo addon
Plug 'mileszs/ack.vim'      " use ag (silver searcher) in vim
Plug 'junegunn/fzf.vim'     " fuzzy file search
Plug 'w0rp/ale'             " linting engine

" Colorschemes
" Plug 'morhetz/gruvbox'
Plug 'sjl/badwolf'          " currently my favorite colorscheme now

call plug#end()

"""""""""""""""""
"" Color settings 
"""""""""""""""""
" colorscheme gruvbox
" let g:gruvbox_italic=1
colorscheme badwolf " I prefer badwolf for now

""""""""""
"" General
""""""""""
set termguicolors          " user 24bit full color 
syntax enable              " enable syntax highlighting
set tabstop=4              " number of spaces per tab symbol in file
set softtabstop=4          " number of spaces per tab press
set expandtab	           " convert tabs to spaces (tabs are bad okay?)
set number	               " enable line numbering
set showcmd 	           " show the last command in bottom
set cursorline	           " highlight current line of cursor
"filetype indent on         " load filetype-specific indent files
set wildmenu               " visual autocomplete in command menu
set lazyredraw             " only redraw screen when needed
set showmatch              " highlight matching brackets/parethesis/curlies
set clipboard=unnamed      " combine default clipboard with system clipboard
set mouse=a                " use mouse as well
let mapleader=","          " leader is comma
set laststatus=2           " always display the statusbar
set hidden                 " hide files in bg instead of closing them
set history=1000           " increase undo history to 1000
set dir=~/.cache/vim       " directory to store swap files
set backupdir=~/.cache/vim " directory to store backups

"""""""""
"" Search
"""""""""
set incsearch                 " search as characters are entered
set hlsearch                  " highlight matches
" stop highlighting your searched stuff using <leader> space
nnoremap <leader><space> :nohlsearch<CR>
" open Ack search 
nnoremap <leader>a :Ack<space>
let g:ackprg = 'ag --vimgrep' " use ag (silver-searcher) with ack plugin
" Fuzzy file shortcuts in buffers / files / tags
set rtp+=/usr/local/opt/fzf
nmap ; :Buffers<CR>   
nmap <Leader>t :Files<CR>     
nmap <Leader>r :Tags<CR>

""""""""""
"" Folding
""""""""""
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level
" space open/closes folds
nnoremap <space> za

"""""""""""
"" Movement
"""""""""""
" move vertically by visual line
nnoremap j gj
nnoremap k gk

""""""""""""
"" Shortcuts
""""""""""""
" toggle gundo
nnoremap <leader>u :GundoToggle<CR>
let g:gundo_prefer_python3 = 1 " gundo should use python3
" edit vimrc/zshrc and load vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
" Automatically source vimrc on save.
autocmd! bufwritepost $MYVIMRC source $MYVIMRC
" save session
nnoremap <leader>s :mksession<CR>

"""""""""
"" Splits
"""""""""
" navigate splits using ctrl hjkl instead ctrl w ctrl hjkl
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow          " open new horizontal splits below
set splitright          " open new vertical splits to the right


