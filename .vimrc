"jj Generated from: https://gist.github.com/simonista/8703722
" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype off

" May need to do the command `ssh-add-github`  or `ssh-add ~/.ssh/id_rsa`
call plug#begin()
  Plug 'tpope/vim-sensible' " some defaults
  Plug 'scrooloose/nerdtree' " navigation
  Plug 'tpope/vim-fugitive' " git commands
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " search
  Plug 'junegunn/fzf.vim' " search
  Plug 'nanotech/jellybeans.vim' " nice color
  Plug 'sheerun/vim-polyglot' " language highlighting
  Plug 'tpope/vim-dadbod' " database
call plug#end()

" Turn on syntax highlighting
syntax on

" For plugins to load correctly
filetype plugin indent on

" TODO: Pick a leader key
" let mapleader = ","

" Security
set modelines=0

" Show line numbers
set number

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" Whitespace
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk
" Allow hidden buffers
set hidden
" Rendering
set ttyfast
" Status bar
set laststatus=2
" Last line
set showmode
set showcmd
" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " clear search
" Remap help key.
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>
" Textmate holdouts
" Formatting
map <leader>q gqip
" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL
" Color scheme (terminal)
set t_Co=256
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
" put https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim
" in ~/.vim/colors/ and uncomment:
" colorscheme solarized

" Custom stuff

" NERDTree shortcut
map <C-n> :NERDTreeToggle<CR>

" open NERDTree if vim is launched without opening a file
autocmd VimEnter * if !argc() | NERDTree | endif

" quit vim if NERDTree is the only window left open
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" NERDTree on opening a direction
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Alternates between the NERDTree window and a source window.
function! g:AlternateNERDTreeAndBuffer()
  if winnr() == g:NERDTreeWindow()
    call g:RestoreLastSourceBuffer()
  else
    call g:OpenNERDTreeWithSaveSourceBuffer()
  endif
endfunction

" Focuses the NERDTree window on the current file
function! g:NERDTreeFocusCurrentBuffer()
  if g:NERDTreeWindow() < 0
    call g:OpenNERDTreeWithSaveSourceBuffer()
  endif

  if !g:IsSourceBuffer()
    call g:RestoreLastSourceBuffer()
  endif

  NERDTreeFind
endfunction

" NERDTree
let NERDTreeChDirMode  = 2        " keep working directory set to NERD's root node
let NERDTreeWinPos     = "left"
let NERDTreeWinSize    = 35
let NERDTreeQuitOnOpen = 1
let NERDTreeIgnore     = ['\~$', '\.o$', '\.lo$', '\.la$', '\.log$', '^stamp-h1$', '^test-suite.log$', '_unittest']

function! g:NERDTreeWindow()
  if exists('t:NERDTreeBufName')
    return bufwinnr(t:NERDTreeBufName)
  else
    return -1
  endif
endfunction

function! g:OpenNERDTreeWithSaveSourceBuffer()
  call g:SaveLastSourceBuffer()

  if g:NERDTreeWindow() < 0
    NERDTreeToggle
  else
    execute g:NERDTreeWindow() . 'wincmd w'
  endif
endfunction

" fzf
nnoremap <C-p> :Files<CR>
nnoremap <C-o> :Buffers<CR>
nnoremap <C-g> :GFiles<CR>
nnoremap <C-i> :Rg!

" remove trailing white-space when saving a file
autocmd BufWritePre * :%s/\s\+$//e

" copy/cut/paste
vnoremap <C-X> "+x
vnoremap <C-C> "+y
nnoremap <C-V> "+gP
cnoremap <C-V> <C-R>+

" fix grep in OSX
map <F8> :GrepBuffer<CR><CR>
map <F9> :Rgrep<CR><CR>
let Grep_Find_Use_Xargs = 0

" shorter keystrokes for split navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" use ; to enter command mode
nnoremap ; :

" display options
set number                " show line numbers
set ruler                 " show current line, column, and relative position in file
set showmode              " show current mode (insert, replace, visual)
set nowrap                " don't wrap long lines
set novisualbell          " no blinking
set noerrorbells          " no noise
set list                  " show hidden characters
set listchars=tab:>=,trail:~,extends:>,precedes:<,nbsp:.

" indentation preferences
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set backspace=2
set autoindent
set textwidth=100

" editor behavior
set wildmenu              " show matches on tab-completion
set incsearch             " show matches while typing search string
set noshowmatch           " don't jump to matching bracket after typing closing bracket
set foldmethod=syntax     " fold code based on syntax
" set foldlevel=99
set nofoldenable
" set foldlevelstart=99
set nostartofline         " keep cursor in same column during motion commands
set modeline              " read modelines
set mouse=a               " enable mouse in all modes
set updatetime=100        " delay (ms) before CursorHold event
set dir=/tmp              " write swap files to /tmp

set mousemodel=extend
syntax on
syntax sync fromstart
colorscheme jellybeans

"Custom command for getting the filename in VIM
command Filename let @+ = expand("%")
