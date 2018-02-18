" Set wildmenu to enable autocomplete
set wildmenu
" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Ignore case when searching
set ignorecase
set smartcase
" Highlight search results
set hlsearch

" Show matching bracket
set showmatch

" Set auto read changes made from outside
set autoread

" Set syntax color
syntax on

" Keep original content when pasting
set paste

" tabstop 2 and use space for tab
set tabstop=2
set shiftwidth=2
set expandtab

" auto indent
set ai "Auto indent
set si " smart indent

" Set utf8
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,mac,dos

" Turn off backup and swap
set nobackup
set nowb
set noswapfile

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>
