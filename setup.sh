#!/bin/bash

set -e

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
    # sudo add-apt-repository ppa:cassou/emacs
    # sudo apt-get update
    # sudo apt-get install emacs-snapshot-el emacs-snapshot-gtk emacs-snapshot
    sudo apt-get install ack-grep git-core subversion mercurial ipython pyflakes python-setuptools bzr exuberant-ctags
elif [[ $platform == 'mac' ]]; then
    echo "Make sure emacs24 is installed"
    echo "(Try http://emacsformacosx.com/builds)"
    #if `diff /usr/bin/emacs ./thirdparty/mac-emacs-script >/dev/null` ; then
    #    echo "/usr/bin/emacs fix is done"
    #else
    #    echo "fixing /usr/bin/emacs"
    #    sudo mv /usr/bin/emacs /usr/bin/emacs.backup
    #    sudo cp ./thirdparty/mac-emacs-script /usr/bin/emacs
    #fi
    # always succeeds
    brew install bzr git mercurial || true
fi
pip install rope ropemode ipdb

#echo "Fixing permissions..."
#chmod u=rwx,g=r,o=r setup.sh config src 
#chmod -R u=rw,g=r,o=r config/*
#chmod -R u=rw,g=r,o=r src/*

# create temporary flymake folder
if [ ! -d $INSTALLDIR/.emacs.d/tmp ]; then
    mkdir -p $INSTALLDIR/.emacs.d/tmp
fi

echo "Fetching 3rd party packages..."
if [ ! -d $INSTALLDIR/.emacs.d/thirdparty ]; then
    mkdir -p $INSTALLDIR/.emacs.d/thirdparty
fi

pushd $INSTALLDIR/.emacs.d/thirdparty
if [ ! -d pylookup ]; then
    echo "Pulling pylookup..."
    git clone git://github.com/tsgates/pylookup.git
else
    echo "Updating pylookup..."
    cd pylookup
    git pull
    cd ..
fi
cd pylookup
if [ ! -e pylookup.db ]; then
    make
fi
cd ..
if [ ! -d python-mode ]; then
    echo "Pulling python-mode"
    bzr branch lp:python-mode
else
    echo "Updating python-mode"
    cd python-mode
    # bzr merge --pull
    cd ..
fi
if [ ! -d helm ]; then
    echo "Pulling helm"
    git clone git://github.com/emacs-helm/helm.git
else
    echo "Updating helm"
    cd helm
    git pull
    cd ..
fi
cd helm
make
cd ..
if [ ! -d Pymacs ]; then
    echo "Pulling pymacs"
    git clone https://github.com/pinard/Pymacs.git
else
    echo "Updating pymacs"
    cd Pymacs
    git pull
    cd ..
fi
echo "Building pymacs"
cd Pymacs
make && make install
cd ..
if [ ! -d ropemacs ]; then
    echo "Pulling ropemacs"
    git clone https://github.com/python-rope/ropemacs.git
else
    echo "Updating ropemacs"
    cd ropemacs
    hg pull -u
    cd ..
fi
echo "Building ropemacs"
cd ropemacs
python setup.py install
cd ..
if [ ! -d rainbow-delimiters ]; then
    echo "Pulling rainbow-delimiters"
    git clone git://github.com/jlr/rainbow-delimiters.git
else
    echo "Updating rainbow-delimiters"
    cd rainbow-delimiters
    git pull
    cd ..
fi
cd rainbow-delimiters
emacs -Q -batch -L . -f batch-byte-compile rainbow-delimiters.el
cd ..
if [ ! -d popwin-el ]; then
    echo "Pulling popwin-el"
    git clone git://github.com/m2ym/popwin-el.git
else
    echo "Updating popwin-el"
    cd popwin-el
    git pull
    cd ..
fi
cd popwin-el
emacs -Q -batch -L . -f batch-byte-compile popwin.el
cd ..
popd

if [[ $platform == 'linux' ]]; then
    STAT_CMD="stat -L -c '%d:%i' "
elif [[ $platform == 'mac' ]]; then
    STAT_CMD="stat -L -f '%d:%i' "
fi

if [ -e $HOME/.emacs.d/init.el ]; then
    if ! [ "$($STAT_CMD "init.el")" = "$($STAT_CMD "$HOME/.emacs.d/init.el")" ]; then
        echo "Backing up init.el to init.el.backup"
        mv ~/.emacs.d/init.el ~/.emacs.d/init.el.backup
    fi
fi

if ! [ -e $HOME/.emacs.d/init.el ]; then
    echo "Linking init.el"
    ln -s `pwd`/init.el ~/.emacs.d/init.el
else
    echo "Init files are already linked"
fi

echo "maybe add to bashrc: alias E=\"SUDO_EDITOR=\\\"emacsclient -c -a emacs\\\" sudo -e\""
echo "maybe add to .hgrc: [ui] merge = emacsclient [merge-tools] emacsclient.args = --eval \"(ediff-merge-with-ancestor \\"$local\\" \\"$other\\" \\"$base\\" nil \\"$output\\")\""
