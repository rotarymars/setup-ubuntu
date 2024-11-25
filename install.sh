sudo apt update && sudo apt upgrade
# chrome stuff
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrom-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/googlechrom-keyring.gpg

# vscode
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
rm -f packages.microsoft.gpg
# kicad
sudo add-apt-repository ppa:kicad/kicad-8.0-releases
# warp
wget -qO- https://releases.warp.dev/linux/keys/warp.asc | gpg --dearmor >warpdotdev.gpg
sudo install -D -o root -g root -m 644 warpdotdev.gpg /etc/apt/keyrings/warpdotdev.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" > /etc/apt/sources.list.d/warpdotdev.list'
rm warpdotdev.gpg
# docker
sudo apt-get -y install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
# obs studio
sudo apt-get install -y ffmpeg
sudo add-apt-repository ppa:obsproject/obs-studio
# openvpn
sudo mkdir -p /etc/apt/keyrings && curl -fsSL https://packages.openvpn.net/packages-repo.gpg | sudo tee /etc/apt/keyrings/openvpn.asc
DISTRO=$(lsb_release -c -s)
echo "deb [signed-by=/etc/apt/keyrings/openvpn.asc] https://packages.openvpn.net/openvpn3/debian $DISTRO main" | sudo tee /etc/apt/sources.list.d/openvpn-packages.list

sudo apt update && sudo apt upgrade
sudo apt-get install -y google-chrome-stable rpi-imager ibus-mozc mozc-utils-gui curl apt-transport-https git kicad clang clangd clang-format build-essential warp-terminal libreoffice docker-ce docker-ce-cli containerd.io blender obs-studio openvpn3 network-manager-l2tp network-manager-l2tp-gnome xsel
sudo apt-get -y install docker-compose-plugin
sudo apt-get update
sudo apt-get install -y code

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm -f nvim-linux64.tar.gz
# add to bashrc
# echo "export PATH="$PATH:/opt/nvim-linux64/bin"" >> ~/.bashrc
git config --global user.name rotarymars
git config --global user.email s.goto2050@gmail.com
git config --global commit.gpgsign true
git config --global gpg.format ssh
echo "source ~/.my-bashrc" >>~/.bashrc
echo "alias pbcopy='xsel --clipboard --input'" >>~/.my-bashrc
# git config --global user.signingkey ~/projects/ssh-keys/signing-keys.pub

mkdir ~/.config
git clone git@github.com:rotarymars/neovim-setup ~/.config/nvim

git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh
cd ..
rm -rf nerd-fonts

# open /etc/group
# sudo vi /etc/group
# add user to docker droup
# like the bellow
# docker:x:999:rotarymars
