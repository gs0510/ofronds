#!/bin/bash

# Install ocaml/opam
if [ -f "/etc/arch-release" ]; then #detect arch-linux
        pacman -S opam
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        apt install opam
elif [[ "$OSTYPE" == "darwin"* ]]; then #MacOS
        #Check if homebrew is installed
        which=$(command -v which -s brew)
        if [[ $which != 0 ]] ; then
            # Install Homebrew
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        else
            brew update
        fi
        brew install gpatch
        brew install opam
elif [[ "$OSTYPE" == "freebsd"* ]]; then
        cd /usr/ports/devel/ocaml-opam || exit
        make install
elif [[ "$OSTYPE" == "openbsd"* ]]; then
        pkg_add opam
else
    "Unknown OS type, please install opam/ocaml manually."
fi

# Initailize a switch
opam init
eval "$(opam env)"
opam switch create 4.11.1
eval "$(opam env)"
opam install dune
eval "$(opam env)"

# Install all packages
opam install .