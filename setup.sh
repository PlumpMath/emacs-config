#!/bin/bash

INSTALLDIR=$HOME

#########################################
# Determining platform
#########################################
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='mac'
fi

echo "Installing dependencies"
if [[ $platform == 'linux' ]]; then
    # until emacs 24: https://launchpad.net/~cassou/+archive/emacs
    # sudo add-apt-repository ppa:cassou/emacs
    # sudo apt-get update
    sudo apt-get install emacs-snapshot ack-grep git
elif [[ $platform == 'darwin' ]]; then
    echo "Make sure emacs24, ack, git are installed"
fi

echo "Fixing permissions..."
chmod u=rwx,g=r,o=r setup.sh config src 
chmod -R u=rw,g=r,o=r config/*
chmod -R u=rw,g=r,o=r src/*

echo "Fetching 3rd party packages..."
if [ ! -d $INSTALLDIR/.emacs.d/thirdparty ]; then
    mkdir -p $INSTALLDIR/.emacs.d/thirdparty
fi

pushd $INSTALLDIR/.emacs.d/thirdparty
if [ ! -d emacs-color-theme-solarized ]; then
    echo "Pulling emacs-color-theme-solarized..."
    git clone git://github.com/sellout/emacs-color-theme-solarized.git
else
    echo "Updating emacs-color-theme-solarized..."
    cd emacs-color-theme-solarized
    git pull -u
fi
popd

if [ ! "init.el" -ef "~/.emacs.d/init.el" ]; then
    echo "Backing up init.el to init.el.backup"
    mv ~/.emacs.d/init.el ~/.emacs.d/init.el.backup
fi
echo "Linking init.el"
ln -s `pwd`/init.el ~/.emacs.d/init.el


# find . -name *.tar.gz | xargs -n1 tar xvzf
# find . -name *.tar.bz2 | xargs -n1 tar xvjpf
#mv auto-complete* ./emacs/auto-complete
#cd ./emacs/auto-complete/
#make
#cd ../../
#mv *Pymacs* ./emacs/pymacs
#mv yasnippet* ./emacs/yasnippet
#mv cedet* ./emacs/cedet
#mv ecb* ./emacs/ecb
#mv color-theme ./emacs/color-theme
#mv haskell-mode* ./emacs/haskell-mode
#mv python-mode*/* ./emacs/python-mode/
#rm -rf python-mode*
#mv php-mode* ./emacs/php-mode

