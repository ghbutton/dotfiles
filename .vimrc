set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tomtom/quickfixsigns_vim'
Plugin 'scrooloose/nerdtree'
Plugin 'sheerun/vim-polyglot'
Plugin 'vim-syntastic/syntastic'
Plugin 'jezcope/vim-align'
Plugin 'tpope/vim-rails'
Plugin 'slim-template/vim-slim'
Plugin 'kien/ctrlp.vim'
Plugin 'slashmili/alchemist.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'nanotech/jellybeans.vim'

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

behave xterm
syntax on
syntax sync fromstart
colorscheme jellybeans
" filetype plugin indent on

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

set foldtext=getline(v:foldstart)
set fillchars="vert:|"

" indentation preferences
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set backspace=2
set autoindent
set textwidth=100

" C formatting options
set cinoptions=t0,+2s,g0
set cinwords=if,unless,else,while,until,do,for,switch,case
set cindent
set formatoptions=croql

" display options
set number                " show line numbers
set ruler                 " show current line, column, and relative position in file
set showmode              " show current mode (insert, replace, visual)
set nowrap                " don't wrap long lines
set novisualbell          " no blinking
set noerrorbells          " no noise
set list                  " show hidden characters
set listchars=tab:>=,trail:~,extends:>,precedes:<,nbsp:.

" highlight current line in active window
autocmd WinEnter      * setlocal cursorline
autocmd WinLeave      * setlocal nocursorline
autocmd InsertEnter   * setlocal nocursorline
autocmd InsertLeave   * setlocal cursorline
autocmd CursorHoldI   * setlocal cursorline
autocmd CursorMovedI  * setlocal nocursorline
setlocal cursorline   " enable in active window just after vim loads

let mapleader = ","

" highlight past 80 columns
"highlight OverLength cterm=reverse
"match OverLength /\%81v.*/

" use ; to enter command mode
nnoremap ; :

" reselect visual block after shift
vnoremap < <gv
vnoremap > >gv

" allow dot operator to work on all lines
vnoremap . :norm.<CR>

" shorter keystrokes for split navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" disable those damn arrow keys
nnoremap <up>    <nop>
nnoremap <down>  <nop>
nnoremap <left>  <nop>
nnoremap <right> <nop>
inoremap <up>    <nop>
inoremap <down>  <nop>
inoremap <left>  <nop>
inoremap <right> <nop>

" to write to protected files
cmap w!! %!sudo tee %

" fix pageup and pagedown behavior
map  <PageUp>   <C-U>
map  <PageDown> <C-D>
imap <PageUp>   <C-O><C-U>
imap <PageDown> <C-O><C-D>

" fix C-Page{Up,Down} in rxvt (sends different key codes)
nmap <ESC>[5^ <C-PageUp>
nmap <ESC>[6^ <C-PageDown>


" Save the last source buffer so that we can return to it after switching to helper windows, such as
" NERDTree or Tagbar.

" Returns true if the current buffer is a source file.
function! g:IsSourceBuffer()
  return !(winnr() == g:NERDTreeWindow() || winnr() == g:TagbarWindow())
endfunction

" Saves the current source buffer so that it can be restored by g:RestoreLastSourceBuffer().
function! g:SaveLastSourceBuffer()
  if g:IsSourceBuffer()
    let t:LastSourceBuffer = bufnr('%')
  endif
endfunction

" Returns to the last source file that was being edited.
function! g:RestoreLastSourceBuffer()
  if exists('t:LastSourceBuffer')
    execute bufwinnr(t:LastSourceBuffer) . 'wincmd w'
  else
    execute 'wincmd p'
  endif
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

noremap  <silent> <F2>      :NERDTreeToggle<CR>
nnoremap <silent> <Leader>f :call g:AlternateNERDTreeAndBuffer()<CR>
nnoremap <silent> <Leader>F :call g:NERDTreeFocusCurrentBuffer()<CR>

" open NERDTree if vim is launched without opening a file
autocmd VimEnter * if !argc() | NERDTree | endif

" quit vim if NERDTree is the only window left open
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif


" NERDCommenter
let g:NERDCustomDelimiters = { 'toml': { 'left': '#' } }


" Tagbar
let g:tagbar_left        = 0
let g:tagbar_width       = 40
let g:tagbar_autofocus   = 1
let g:tagbar_autoclose   = 1
let g:tagbar_sort        = 1
let g:tagbar_compact     = 0
let g:tagbar_expand      = 0
let g:tagbar_singleclick = 1
let g:tagbar_iconchars   = ['▶', '▼']
let g:tagbar_autoshowtag = 0

let g:tagbar_type_coffee = {
      \ 'ctagstype' : 'coffee',
      \ 'kinds' : [
      \   'f:functions',
      \   'v:variables'
      \ ],
      \ }

function! g:TagbarWindow()
  return bufwinnr('__Tagbar__')
endfunction

function! g:OpenTagbarWithSaveSourceBuffer()
  call g:SaveLastSourceBuffer()
  call tagbar#OpenWindow('fj')
endfunction

function! g:AlternateTagbarAndBuffer()
  if winnr() == g:TagbarWindow()
    call g:RestoreLastSourceBuffer()
  else
    call g:OpenTagbarWithSaveSourceBuffer()
  endif
endfunction

noremap <silent> <F3> :TagbarToggle<CR>
nnoremap <silent> <Leader>g :call g:AlternateTagbarAndBuffer()<CR>


" ctags
set tags=./tags;/
map <silent> <C-\>   :vsplit    <CR>:exec("tag ".expand("<cword>"))<CR>
map <silent> <C-S-\> :tab split <CR>:exec("tag ".expand("<cword>"))<CR>

" VimClojure
let vimclojure#SplitPos = "right"
let vimclojure#UseErrorBuffer=0
let vimclojure#FuzzyIndent=1
let vimclojure#HighlightBuiltins=1
let vimclojure#HighlightContrib=1
let vimclojure#DynamicHighlighting=1
let vimclojure#ParenRainbow=1
let vimclojure#WantNailgun=1


autocmd FileType ruby nnoremap <buffer> K :call ri#LookupNameUnderCursor()<CR>

" configure haskellmode-vim
let g:haddock_browser="/usr/bin/chromium-browser"
let $PATH = $PATH . ':' . expand("~/.cabal/bin")

" fix grep in OSX
map <F8> :GrepBuffer<CR><CR>
map <F9> :Rgrep<CR><CR>
let Grep_Find_Use_Xargs = 0

" tabs
nnoremap <silent> <C-PageUp>   :tabprev<CR>
nnoremap <silent> <C-PageDown> :tabnext<CR>

" copy/cut/paste
vnoremap <C-X> "+x
vnoremap <C-C> "+y
nnoremap <C-V> "+gP
cnoremap <C-V> <C-R>+

" expand surrounding code-folds
nmap zp  zozjzo2zkzozj

" remove trailing white-space when saving a file
autocmd BufWritePre * :%s/\s\+$//e

" treat hamlc as haml
autocmd BufRead,BufNewFile *.hamlc set filetype=haml

" use Dispatch and Zeus with vim-rspec
let g:rspec_command = "compiler rspec | set makeprg=zeus | Make rspec {spec}"
nnoremap <silent> <Leader>r :call RunCurrentSpecFile()<CR>
nnoremap <silent> <Leader>R :call RunNearestSpec()<CR>
nnoremap <silent> <Leader>s :call RunLastSpec()<CR>

" debug syntax highlighting
map <Leader>sn :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" NERDTree on opening a direction
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" NERDTree shortcut
map <C-n> :NERDTreeToggle<CR>

" ctrlp shortcut
let g:ctrlp_map = '<c-p>'

" syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
"
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
