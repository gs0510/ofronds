#!/bin/bash

opam_exists=$(command -v which opam)
if [[ $opam_exists != 0 ]] ; then
        echo "\e[32mInstalling opam on your system."
        # Install ocaml/opam
        if [ -f "/etc/arch-release" ]; then #detect arch-linux
                sudo pacman -S opam
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then #detect debian systems
                sudo apt install opam 
        elif [[ "$OSTYPE" == "darwin"* ]]; then #MacOS
                #Check if homebrew is installed
                which=$(command -v which brew)
                if [[ $which != 0 ]] ; then
                # Install Homebrew
                echo "\e[32mInstalling homebrew (package manager) needed to install opam."
                ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
                else
                brew update
                fi
                brew install gpatch
                brew install opam
        elif [[ "$OSTYPE" == "freebsd"* ]]; then
                cd /usr/ports/devel/ocaml-opam || exit
                su make install
        elif [[ "$OSTYPE" == "openbsd"* ]]; then
                su pkg_add opam
        else
        "\e[31mUnknown OS type, please install opam/ocaml manually."
        fi

        # Initailize a switch
        opam init
        eval "$(opam env)"
fi

echo -e "\e[32mCreating a local switch"
opam switch create ./
eval "$(opam env)"

# Install all packages
echo -e "\e[32mInstalling all packages required by ofronds."
opam install .
eval "$(opam env)"