#!/bin/bash

if [ -z "$USER" ]; then
    USER=$(id -un)
fi

function create_directory_if_not_exists {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        echo "Directory $1 created."
    else
        echo "Directory $1 already exists."
    fi
}

function go_to_temporary {
    if [ ! -d "$1" ]; then
        cd "$HOME/temporary"
        echo "Entered Temporary"
    else
        echo "Temporary doesn't exist"
        exit 1
    fi
}

function go_home {
        cd $HOME
}

#Temporary fix
export PATH="$HOME/bin:$PATH"

echo ""
echo "====================================================================="
echo " Setting up codespaces environment"
echo ""
echo " USER        $USER"
echo " HOME        $HOME"
echo "====================================================================="

cd $HOME

create_directory_if_not_exists "$HOME/bin"
create_directory_if_not_exists "$HOME/temporary"

go_to_temporary
#INSTALL bat
BAT_VERSION=0.23.0
curl -L -o bat_install.deb https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb
sudo dpkg -i bat_install.deb
go_home

# Istall fzf
FZF_VERSION=0.39.0
curl -L https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz | tar xzC $HOME/bin

# Install neovim
NVIM_VERSION=0.9.0
curl -L -o $HOME/bin/nvim https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage
cd $HOME/bin
chmod a+x ./nvim
./nvim --appimage-extract
./squashfs-root/AppRun --version
rm ./nvim
sudo ln -s $HOME/bin/squashfs-root/AppRun $HOME/bin/nvim

git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim