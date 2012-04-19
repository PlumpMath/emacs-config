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
    sudo apt-get install emacs-snapshot ack-grep git mercurial ipython pyflakes python-setuptools bzr exuberant-ctags
    sudo pip install rope ropemode
elif [[ $platform == 'mac' ]]; then
    echo "Make sure emacs24, ack, git, ipython, pyflakes are installed"
    echo "Make sure pip install rope ropemode"
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
    cd ..
fi
if [ ! -d python-mode ]; then
    echo "Pulling python-mode"
    bzr branch lp:python-mode
else
    echo "Updating python-mode"
    cd python-mode
    bzr merge
    cd ..
fi
if [ ! -d helm ]; then
    echo "Pulling helm"
    git clone git://github.com/emacs-helm/helm.git
else
    echo "Updating helm"
    cd helm
    git pull -u
    cd ..
fi
cd helm
make
cd ..
if [ ! -d projectile ]; then
    echo "Pulling projectile"
    git clone git://github.com/bbatsov/projectile
else
    echo "Updating projectile"
    cd projectile
    git pull -u
    cd ..
fi
if [ ! -d autopair ]; then
    echo "Pulling autopair"
    svn co http://autopair.googlecode.com/svn/trunk autopair
else
    echo "Updating autopair"
    cd autopair
    svn up
    cd ..
fi
if [ ! -d Pymacs ]; then
    echo "Pulling pymacs"
    git clone https://github.com/pinard/Pymacs.git
else
    echo "Updating pymacs"
    cd Pymacs
    git pull -u
    cd ..
fi
echo "Building pymacs"
cd Pymacs
make && sudo make install
cd ..
if [ ! -d ropemacs ]; then
    echo "Pulling ropemacs"
    hg clone https://bitbucket.org/agr/ropemacs
else
    echo "Updating ropemacs"
    cd ropemacs
    hg pull -u
    cd ..
fi
echo "Building ropemacs"
cd ropemacs
sudo python setup.py install
cd ..
popd

if [[ $platform == 'linux' ]]; then
    STAT_CMD="stat -L -c '%d:%i' "
elif [[ $platform == 'mac' ]]; then
    STAT_CMD="stat -L -f '%d:%i' "
fi

if ! [ "$($STAT_CMD "init.el")" = "$($STAT_CMD "$HOME/.emacs.d/init.el")" ]; then
    echo "Backing up init.el to init.el.backup"
    mv ~/.emacs.d/init.el ~/.emacs.d/init.el.backup
    echo "Linking init.el"
    ln -s `pwd`/init.el ~/.emacs.d/init.el
else
    echo "Init files are already linked"
fi



# find . -name *.tar.gz | xargs -n1 tar xvzf
# find . -name *.tar.bz2 | xargs -n1 tar xvjpf
