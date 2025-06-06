#!/bin/bash

set -eu

sudo apt update && sudo apt upgrade -y
# chrome stuff
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrom-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --yes --dearmor -o /usr/share/keyrings/googlechrom-keyring.gpg

# vscode
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --yes --dearmor >packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
rm -f packages.microsoft.gpg
# kicad
sudo add-apt-repository -y ppa:kicad/kicad-8.0-releases
# warp
wget -qO- https://releases.warp.dev/linux/keys/warp.asc | gpg --yes --dearmor >warpdotdev.gpg
sudo install -D -o root -g root -m 644 warpdotdev.gpg /etc/apt/keyrings/warpdotdev.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" > /etc/apt/sources.list.d/warpdotdev.list'
rm warpdotdev.gpg
# docker
sudo apt-get -y install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
# obs studio
sudo apt-get install -y ffmpeg
sudo add-apt-repository -y ppa:obsproject/obs-studio
# discord
sudo -E gpg --no-default-keyring --keyring=/usr/share/keyrings/javinator9889-ppa-keyring.gpg --keyserver keyserver.ubuntu.com --recv-keys 08633B4AAAEB49FC
sudo tee /etc/apt/sources.list.d/javinator9889-ppa.list <<<"deb [arch=amd64 signed-by=/usr/share/keyrings/javinator9889-ppa-keyring.gpg] https://ppa.javinator9889.com all main"
# ansible
sudo add-apt-repository --yes --update ppa:ansible/ansible
# windsurf
curl -fsSL "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/windsurf.gpg" | sudo gpg --yes --dearmor -o /usr/share/keyrings/windsurf-stable-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/windsurf-stable-archive-keyring.gpg arch=amd64] https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt stable main" | sudo tee /etc/apt/sources.list.d/windsurf.list > /dev/null
# apt-fast
sudo add-apt-repository -y ppa:apt-fast/stable
sudo apt install -y apt-fast
# FUSE
sudo add-apt-repository -y universe


sudo apt-fast update
sudo apt-fast install -y \
  google-chrome-stable \
  rpi-imager ibus-mozc mozc-utils-gui \
  curl apt-transport-https git kicad clang \
  clangd clang-format build-essential warp-terminal \
  libreoffice docker-ce docker-ce-cli containerd.io blender \
  obs-studio openvpn3 network-manager-l2tp \
  network-manager-l2tp-gnome xsel nodejs npm python3-pip \
  exuberant-ctags ripgrep eza make libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev llvm libncursesw5-dev \
  xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
  lldb libxslt1-dev autoconf bison libyaml-dev libncurses5-dev \
  libgdbm-dev libdb-dev uuid-dev fzf htop net-tools trash-cli nmap \
  openssh-server bacula-console-qt discord blueman apt-fast code \
  direnv cargo sshpass docker-compose-plugin tigervnc-viewer zsh libheif-examples \
  fortune-mod software-properties-common ansible v4l-utils cheese micropython windsurf \
  cmake ninja-build libfuse2t64 aria2
sudo snap install zoom-client

if [ ! -d /opt/nvim ]; then
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux64.tar.gz
  rm -f nvim-linux64.tar.gz
fi
# add to bashrc
# echo "export PATH="$PATH:/opt/nvim-linux64/bin"" >> ~/.bashrc
# echo "export PATH=\"\$PATH:/opt/nvim-linux64/bin\"" >>~/.my-bashrc
git config --global user.name rotarymars
git config --global user.email s.goto2050@gmail.com
git config --global commit.gpgsign true
git config --global gpg.format ssh
# echo "source ~/.my-bashrc" >>~/.bashrc
# echo "alias pbcopy='xsel --clipboard --input'" >>~/.my-bashrc
# echo "alias g='git'" >>~/.my-bashrc
# echo "alias ls='eza --icons'" >>~/.my-bashrc
# git config --global user.signingkey ~/projects/ssh-keys/signing-keys.pub

if [ ! -d ~/.config ]; then
  mkdir ~/.config
fi

if [ ! -d ~/.config/nvim ]; then
  git clone git@github.com:rotarymars/neovim-setup ~/.config/nvim
else
  pushd ~/.config/nvim
  git pull
  popd
fi

if [ ! -d ~/.local/share/fonts/NerdFonts ]; then
  git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
  cd nerd-fonts
  ./install.sh
  cd ..
  rm -rf nerd-fonts
fi

sudo npm install n -g

sudo n stable
# sudo apt purge -y nodejs npm
sudo apt autoremove -y
pip install jedi yapf git+https://github.com/rotarymars/oj.git
# echo "export PATH=\"\$PATH:/home/rotarymars/.local/bin\"" >>~/.my-bashrc
sudo npm install -g atcoder-cli
# echo "alias compile='clang++ -g -std=c++2b'" >>~/.my-bashrc
# echo "alias accnew='acc new --template kyopuro'" >>~/.my-bashrc
# echo "alias accadd='acc add --template kyopuro'" >>~/.my-bashrc

# open /etc/group
# sudo vi /etc/group
# add user to docker droup
# like the bellow
# docker:x:999:rotarymars

if [ ! -d ~/.asdf ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
  # echo ". \"\$HOME/.asdf/asdf.sh\"" >>~/.my-bashrc
  # echo ". \"\$HOME/.asdf/completions/asdf.bash\"" >>~/.my-bashrc
  asdf plugin add python
  asdf plugin add ruby
  asdf install python latest
  asdf install ruby latest
  asdf global python latest
  asdf global ruby latest
  asdf plugin add zoxide https://github.com/nyrst/asdf-zoxide.git
  asdf install zoxide latest
  asdf global zoxide latest
  # zoxide init bash --cmd cd >>~/.my-bashrc
fi

sudo gpasswd -a rotarymars docker

# echo "alias rm='trash-put'" >>~/.my-bashrc
git config --global core.editor 'code --wait'

# replace cap
sudo sed -i 's/^XKBOPTIONS=.*/XKBOPTIONS="ctrl:nocaps"/' /etc/default/keyboard

TEMPLATE_PATH=$(dirname $0)/templates
cp ${TEMPLATE_PATH}/.ssh/config ~/.ssh/config
cp ${TEMPLATE_PATH}/.my-bashrc ~/.my-bashrc
cp ${TEMPLATE_PATH}/.my-zshrc ~/.my-zshrc

# add to load my-bashrc if necessary
grep .my-bashrc ~/.bashrc >>/dev/null
EC=$?
if [ $EC -ne 0 ]; then
  echo set .my-bashrc to .bashrc
  echo "source ~/.my-bashrc" >>~/.bashrc
fi

# for zsh
touch ~/.zshrc
grep .my-zshrc ~/.zshrc >> /dev/null
if [ $? -ne 0 ]; then
  echo "source ~/.my-zshrc" >> ~/.zshrc
fi

# git config
# git config --global alias.st status
# git config --global alias.co checkout
# git config --global alias.br branch
# git config --global alias.ci commit
# git config --global alias.ps push
# git config --global alias.pl pull
# git config --global alias.lg 'log --format=full --graph --decorate'
cp ${TEMPLATE_PATH}/.gitconfig ~/.gitconfig
# delta
aria2c 'https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_amd64.deb'
sudo dpkg -i ./git-delta_0.18.2_amd64.deb
rm ./git-delta_0.18.2_amd64.deb
