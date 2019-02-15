#!/bin/bash
# this script is used to setup bashrc, inputrc, vim in a linux box

# sanity check
if [ $# -ne 1 ]; then
    echo "Usage error! Example usage: ./linux_setup.sh knight-mutation-publisher-test"
    exit 1
fi

# get the box. There are 'test', 'staging', 'canary', 'prodcution' boxes 
# The name of the box follows syntax `serviceName-environment`. Ex: knight-mutation-publisher-test
NAME=$1
SERVICE=${NAME%-*}
ENVI=${NAME##*-}

if [ "$ENVI" == "test" ]; then
    JAR=${SERVICE}-all.jar
    SERVICE_NAME=$NAME
else 
    JAR=service-all.jar
    SERVICE_NAME=$SERVICE
fi

if [ "$SERVICE" == "knight-mutation-publisher" ]; then
    JAR=mutation-publisher-all.jar
fi

################################################################################
# setup serach command history
cat << 'EOF' >> ~/.inputrc
# for Bash history completion
"\e[A": history-search-backward
"\e[B": history-search-forward
set show-all-if-ambiguous on
set completion-ignore-case on"
EOF

################################################################################
# setup .vimrc
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

cat << 'EOF' >> ~/.vimrc
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
EOF

vim +PluginInstall +qall # install vim plugin

################################################################################
# setup ~./bash_rc
echo "source ~/.bashrc" > ~/.bash_profile 

cat << 'EOF' >> ~/.bashrc
alias ls='ls --color=auto'
alias ll='ls -alFh'
alias la='ls -A'
# main editor
export EDITOR="vim"
# set the bash prompts
export PS1="\e[0;36m$PS1\e[m"
# PS1='\[\e[0;44m\]$NAME\[\e[m\] \[\e[0;31m\]\u\[\e[m\] \[\e[0;36m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[0;37m\]'
alias vbr='vim ~/.bashrc'
alias sbr='source ~/.bashrc'
# $NAME
alias link_$SERVICE_NAME='sudo ln -sf ~/$JAR /srv/$SERVICE_NAME/lib/current'
alias link_${SERVICE_NAME}_back='sudo ln -sf /srv/$SERVICE_NAME/lib/next /srv/$SERVICE_NAME/lib/current'
alias log_${SERVICE_NAME}='tail -F /etc/sv/$SERVICE_NAME/log/current'
alias restart_${SERVICE_NAME}='sudo service $SERVICE_NAME restart' 
EOF
