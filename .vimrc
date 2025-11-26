" Basic settings
set nocompatible              " Be iMproved
filetype off                  " Required

" UI Configuration
syntax on                     " Enable syntax highlighting
set number                    " Show line numbers
set relativenumber            " Show relative line numbers
set ruler                     " Show cursor position
set showcmd                   " Show command in bottom bar
set cursorline                " Highlight current line
set wildmenu                  " Visual autocomplete for command menu
set showmatch                 " Highlight matching brackets
set laststatus=2              " Always show status line

" Searching
set incsearch                 " Search as characters are entered
set hlsearch                  " Highlight matches
set ignorecase                " Case insensitive search
set smartcase                 " Case sensitive when uppercase present

" Indentation
set tabstop=4                 " Number of visual spaces per TAB
set softtabstop=4             " Number of spaces in tab when editing
set shiftwidth=4              " Number of spaces to use for autoindent
set expandtab                 " Tabs are spaces
set autoindent                " Copy indent from current line when starting a new line
set smartindent               " Smart indenting when starting a new line

" File handling
set encoding=utf-8            " UTF-8 encoding
set fileencoding=utf-8        " UTF-8 encoding for files
set backspace=indent,eol,start " Make backspace work as expected
set hidden                    " Allow hidden buffers
set autoread                  " Auto reload files changed outside vim

" Performance
set lazyredraw                " Don't redraw while executing macros

" Backup and swap
set nobackup                  " No backup files
set nowritebackup             " No backup before overwriting
set noswapfile                " No swap files

" Color scheme
set background=dark
colorscheme desert

" Status line
set statusline=%F%m%r%h%w\ [%{&ff}]\ [%Y]\ [%04l,%04v][%p%%]\ [LEN=%L]

" Key mappings
let mapleader = ","           " Leader key

" Quick save
nnoremap <leader>w :w<CR>

" Quick quit
nnoremap <leader>q :q<CR>

" Clear search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" Move between splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Enable filetype plugins
filetype plugin indent on
