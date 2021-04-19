#!/usr/bin/bash
sudo apt install stow zsh direnv
sudo snap install nvim --classic

git clone https://github.com/ihasdapie/dotfiles
cd dotfiles
stow nvim # will need to remove treesitter and sniprun
stow zsh

# get antibody
curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin

# get fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install


# get nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
# will need to install a recent-er version of node for coc.nvim


# get nnn, fd
wget https://github.com/sharkdp/fd/releases/download/v8.2.1/fd_8.2.1_amd64.deb
wget https://github.com/jarun/nnn/releases/download/v3.6/nnn_3.6-1_ubuntu16.04.amd64.deb

sudo dpkg -i fd_8.2.1_amd64.deb
sudo dpkg -i nnn_3.6-1_ubuntu16.04.amd64.deb

# pyenv 
sudo apt-get install build-essential git libreadline-dev zlib1g-dev libssl-dev libbz2-dev libsqlite3-dev
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash











