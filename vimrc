"===================== BEGAIN of setup Vundle ===========================
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'ervandew/supertab'
Plugin 'vim-ruby/vim-ruby'
Plugin 'matchit.zip'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
" ========================== END of setup Vundle ========================

" show existing tab with 4 spaces width
set tabstop=2
" when indenting with '>', use 4 spaces width
set shiftwidth=2
" On pressing tab, insert 4 spaces
set expandtab

syntax on
set laststatus=2
set statusline=
set statusline +=%1*\ %n\ %*            "buffer number
set statusline +=%5*%{&ff}%*            "file format
set statusline +=%3*%y%*                "file type
set statusline +=%4*\ %<%F%*            "full path
set statusline +=%2*%m%*                "modified flag
set statusline +=%1*%=%5l%*             "current line
set statusline +=%2*/%L%*               "total lines
set statusline +=%1*%4v\ %*             "virtual column number
set statusline +=%2*0x%04B\ %*          "character under cursor
colorscheme darkblue
set backspace=indent,eol,start "let mac use backspace as delete
set clipboard=unnamed

"set spell check
set spelllang=en_us
autocmd FileType gitcommit setlocal spell
autocmd FileType tex setlocal spell

autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype tex setlocal ts=2 sts=2 sw=2
autocmd Filetype sh setlocal ts=2 sts=2 sw=2

autocmd BufEnter * silent! lcd %:p:h "set autochdir

" function to quick typ some predefined text
" See :h :command-nargs
command! Xp call s:Myprint("sr")
command! -nargs=? Mp call s:MyPrint(<f-args>)
function! s:MyPrint(...)
  if a:0 == 0 || a:1 == "sr"
    normal! i[search-ranking]
  endif
endfunction