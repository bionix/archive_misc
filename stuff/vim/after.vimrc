" ################################
" My vimified after.vimrc config "
" ################################
set nocompatible
filetype plugin indent on
syntax enable
set cursorline

" un-nerd the config
noremap <left> h
noremap <up> k
noremap <down> j
noremap <right> l

let g:molokai_original = 0
colorscheme molokai

Bundle 'mattn/webapi-vim'
Bundle 'mattn/gist-vim'
Bundle 'empanda/vim-varnish'
Bundle 'rodjek/vim-puppet'
Bundle 'flazz/vim-colorschemes'


set encoding=utf-8
set modelines=0
set autoindent
set showmode
" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500
" Makes search act like search in modern browsers
set incsearch
" Don't redraw while executing macros (good performance config)
set lazyredraw
" " For regular expressions turn magic on
set magic
" " Show matching brackets when text indicator is over them
set showmatch
" " How many tenths of a second to blink when matching brackets
set mat=2
" Use spaces instead of tabs
set expandtab
" " Be smart when using tabs ;)
set smarttab
" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile
" When searching try to be smart about cases
set smartcase
" Highlight search results
set hlsearch
