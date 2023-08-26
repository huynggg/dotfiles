colorscheme NeoSolarized
set background=dark
" turn hybrid line numbers on
set number

syntax on

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent

func! WordProcessorMode()
 setlocal textwidth=80
 setlocal smartindent
 setlocal spell spelllang=en_us
 setlocal noexpandtab
endfu

com! WP call WordProcessorMode()

call plug#begin('~/.vim/plugged')
Plug 'mhinz/vim-startify'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } 
Plug 'vim-airline/vim-airline'
call plug#end()
