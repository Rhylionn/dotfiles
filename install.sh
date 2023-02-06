#!/bin/bash
# Made by rhylionn

if [ "$EUID" -ne 0 ]; then
	echo "[!] The script must be run as root"
	exit
fi

read -p "[!] This script made for fedora distributions, continue ? (y/n) " continueInstall

if [ "$continueInstall" != "y" ]; then
	exit
fi


read -p "[?] Username (for permissions): "  username
read -p "[?] Tool installation directory: (will be under /opt/<directory>) " toolsdirectory

echo "[*] System updates"
dnf update -y
dnf upgrade -y

read -p "[?] Install zsh and Oh My Zsh ? (y/n) " installZsh

if [ "$installZsh" = "y" ]; then
	
  read -p "[!] A nerd font need to be installed! Install Hack NF (or install one on your own) ? (y/n) " installHack
  if [ "$installHack" = "y" ]; then
    mkdir -p /home/$username/.local/share/fonts
    wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip" -P /tmp && unzip /tmp/Hack.zip -d /tmp/Hack
    find /tmp/Hack -name "*Nerd Font Complete.ttf" -exec mv -t /home/$username/.local/share/fonts/ {} +
  fi

  dnf install -y zsh fzf bat exa
	git clone https://github.com/ohmyzsh/ohmyzsh.git /home/$username/.oh-my-zsh
	cp /home/$username/.oh-my-zsh/templates/zshrc.zsh-template /home/$username/.zshrc
  
  echo "alias cat='bat'" >> /home/$username/.zshrc 
  echo "alias ls='exa'" >> /home/$username/.zshrc
  
  echo "[*] Installing omz plugins"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/home/$username/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-/home/$username/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  sed -i 's/^plugins=\(.*\)$/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf)/' /home/$username/.zshrc

  read -p "[?] Do you want to install p10k ? (y/n) " installP10k
	
	if [ "$installP10k" = "y" ]; then
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-/home/$username/.oh-my-zsh/custom}/themes/powerlevel10k
		sed -i 's/ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' /home/$username/.zshrc

  fi
  dnf install -y util-linux-user
	chsh -s $(which zsh) $username
fi

echo "[*] Installing core dependencies"
dnf group -y install "C Development Tools and Libraries"
dnf install -y dnf-plugins-core gnome-tweaks


echo "[*] Installing flatpak and applications"
dnf install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub com.bitwarden.desktop com.discordapp.Discord md.obsidian.Obsidian org.telegram.desktop

echo "[*] Installation of basic tools"
dnf install -y neovim terminator curl htop git gparted openvpn neofetch perl-Image-ExifTool 

echo "[*] Installing docker"
# Docker
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
usermod -aG docker $username

# TODO: Vscode/Brave/Node / npm

echo "[*] Installing python"
dnf install -y python3 python3-pip

echo "[*] Installing ruby and ruby gems"
dnf install -y ruby ruby-devel rubygems

echo "[*] Creating tools directory"
mkdir /opt/$toolsdirectory/
cd /opt/$toolsdirectory/
mkdir wordlists
mkdir recon
mkdir webapps
mkdir social-engineering
mkdir postexploitation

echo "[*] Installation of basic pentest tools"
dnf install -y nmap hping3 hydra aircrack-ng ettercap tcpdump john wireshark

echo "[*] Installation of burpsuite"
# https://portswigger-cdn.net/burp/releases/download?product=community&version=2022.12.7&type=Linux

echo "[*] Downloading wordlists"
cd /opt/$toolsdirectory/wordlists
git clone https://github.com/danielmiessler/SecLists
git clone https://github.com/Mebus/cupp
git clone https://github.com/digininja/CeWL CeWL && cd CeWL && bundle install

cd /opt/$toolsdirectory/

echo "[*] Installing metasploit"
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > /tmp/msfinstall
chmod +x /tmp/msfinstall
/tmp/./msfinstall

echo "[*] Installing recon tools"
cd /opt/$toolsdirectory/recon/
git clone https://github.com/laramies/theHarvester
git clone https://github.com/aboul3la/Sublist3r
git clone https://github.com/lanmaster53/recon-ng 
git clone https://github.com/laramies/metagoofil 
git clone https://github.com/darkoperator/dnsrecon

echo "[*] Installing social engineering tools"
cd /opt/$toolsdirectory/social-engineering/ 
git clone https://github.com/trustedsec/social-engineer-toolkit setoolkit/ && cd setoolkit && pip install -r requirements.txt && python setup.py


echo "[*] Installing web application pentest tools"
cd /opt/$toolsdirectory/webapps/
dnf install -y nikto gobuster wfuzz
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git
gem install wpscan

echo "[*] Installing post exploitation tools"
cd /opt/$toolsdirectory/postexploitation/
git clone https://github.com/fortra/impacket && python3 -m pip install impacket/


cd /
echo "[*] Fixing permissions"
chown -R $username:$username /opt/$toolsdirectory
