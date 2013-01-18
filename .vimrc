" set leader to ,
let mapleader=","
let g:mapleader=","

filetype off " temporary for vundle

" bundles
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'tpope/vim-rails.git'
Bundle 'tpope/vim-fugitive'
Bundle 'slim-template/vim-slim'
Bundle 'tomtom/tcomment_vim'
Bundle 'Railscasts-Theme-GUIand256color'

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

" custom statusline
set laststatus=2 " always show status line
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%{fugitive#statusline()}%=%c,%l/%L\ %P

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  set guifont=Inconsolata-dz:h14
endif

colorscheme railscasts

" highlight lines longer than 80 columns
:match ErrorMsg '\%>80v.\+'

" map capital W and Q to w and q
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))
cnoreabbrev <expr> WQ ((getcmdtype() is# ':' && getcmdline() is# 'WQ')?('wq'):('WQ'))
cnoreabbrev <expr> Wq ((getcmdtype() is# ':' && getcmdline() is# 'Wq')?('wq'):('Wq'))

" ctags maps, remap goto, go back
nnoremap <leader>g <C-]>
nnoremap <leader>h <C-T>

" multipurpose tab key
" Indent if we're at the beginning of a line. Else, do completion.
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" commandt
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>

" custom autocmds
augroup vimrcEx
    " clear all autocmds in the group
    autocmd!
    "for ruby, autoindent with two spaces, always expand tabs
    autocmd FileType ruby,yaml,cucumber set ai sw=2 sts=2 et
augroup END

" running tests
function! RunTests(filename)
    " write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        else
            exec ":!rspec --color " . a:filename
        end
    end
endfunction

function! SetTestFile()
    " set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('.')<cr>
map <leader>c :w\|:!script/cucumber<cr>
map <leader>w :w\|:!script/cucumber --profile wip<cr>

" visual mode search, searches for the selected text
:vmap * "qy/<C-R>q<CR>
