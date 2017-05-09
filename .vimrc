" set leader to ,
let mapleader="\<Space>"
let g:mapleader="\<Space>"

filetype off " temporary for vundle

" plugins
call plug#begin('~/.local/share/nvim/plugged')

Plug 'gmarik/vundle'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-fugitive'
Plug 'tomtom/tcomment_vim'
Plug 'vim-scripts/Railscasts-Theme-GUIand256color'
Plug 'godlygeek/tabular'
Plug 'quentindecock/vim-cucumber-align-pipes'
Plug 'rking/ag.vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-endwise'
Plug 'bogado/file-line'
Plug 'isRuslan/vim-es6'

" file formats
Plug 'slim-template/vim-slim'
Plug 'juvenn/mustache.vim'
Plug 'kchmck/vim-coffee-script'

call plug#end()

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
set softtabstop=2
set tabstop=2
set smarttab " insert tabs on the start of a line according to context
set shiftwidth=2
set autoindent " auto indentation
set copyindent " copy the previous indentation on autoindenting

set wildmode=longest,list " use emacs-style tab completion when selecting files, etc
set wildmenu " make tab completion for files/buffers act like bash

set synmaxcol=1000 " disable syntax highlighting for long lines
set scrolloff=5 " start scrolling early

" custom statusline
set laststatus=2 " always show status line
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%{fugitive#statusline()}%=%c,%l/%L\ %P

" hamlc
au BufRead,BufNewFile *.hamlc set ft=haml

" rabl
au BufRead,BufNewFile *.rabl setf ruby
au BufRead,BufNewFile *.rabl syn keyword rubyRabl node attribute object child collection attributes glue extends
au BufRead,BufNewFile *.rabl hi def link rubyRabl Function

" prawn
au BufRead,BufNewFile *.prawn setf ruby

" excel templates (axsls)
au BufRead,BufNewFile *.axlsx setf ruby

" cap and other ruby files
au BufRead,BufNewFile *.cap,Capfile,Bowerfile setf ruby

" au BufRead,BufNewFile *.jsx,*.jsx.erb setf javascript

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
cnoreabbrev <expr> Qa ((getcmdtype() is# ':' && getcmdline() is# 'Qa')?('qa'):('Qa'))

" ctags maps, remap goto, go back
nnoremap <leader>g <C-]>
nnoremap <leader>h <C-T>

" save as root
cmap w!! w !sudo tee % >/dev/null

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

" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    let selection = system(a:choice_command . " | selecta " . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
nnoremap <leader>f :call SelectaCommand("ag --nogroup --nocolor --column -l .", "", ":e")<cr>

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
            exec ":!bundle exec rspec --color --drb " . a:filename
        else
            exec ":!rspec --color --drb " . a:filename
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

function! RunNearestTest(...)
    if a:0
        let command_suffix = " " . a:1
    else
        let command_suffix = ""
    endif
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . command_suffix)
endfunction

map <leader>tf :call RunTestFile()<cr>
map <leader>tt :call RunNearestTest()<cr>
map <leader>td :call RunNearestTest('-d')<cr>
map <leader>ta :call RunTests('.')<cr>
map <leader>tc :w\|:!script/cucumber<cr>
map <leader>tw :w\|:!script/cucumber --profile wip<cr>

map <leader>nt :tabnew<cr>

" search everything
map <leader>sa :Ag<space>
" search stylesheets
map <leader>ss :Ag -G "\.(sass\|css\|scss)$"<space>
" search javascripts
map <leader>sj :Ag -G "\.(js\|coffee\|coffee\.erb\|es6)$"<space>
" search ruby files
map <leader>sr :Ag -G "\.(rb)$"<space>
" search view files
map <leader>sv :Ag -G "\.(slim\|haml\|erb)$"<space>

" tabularize by comma
map <leader>ic Tabularize /,\zs<cr>
