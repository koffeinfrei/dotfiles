" set leader to ,
let mapleader=","
let g:mapleader=","

filetype on " Enable filetype detection
filetype indent on " Enable filetype-specific indenting
filetype plugin on " Enable filetype-specific plugins

set number  " line numbers
set nobackup " no *~ backup files

set incsearch " incremental search
set showmatch
set hlsearch
set ignorecase smartcase " make searches case-sensitive only if they contain upper-case characters
set smartcase " ignore case if search pattern is all lowercase,case-sensitive otherwise

set expandtab "replace <TAB> with spaces
set softtabstop=4
set tabstop=4
set smarttab " insert tabs on the start of a line according to context
set shiftwidth=4
set autoindent " auto indentation
set copyindent " copy the previous indentation on autoindenting

set wildmode=longest,list " use emacs-style tab completion when selecting files, etc
set wildmenu " make tab completion for files/buffers act like bash

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  set guifont=Inconsolata-dz:h14
endif

colorscheme railscasts
