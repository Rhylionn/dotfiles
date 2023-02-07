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


read -p "[?] Username (for permissions): " username
read -p "[?] Tool installation directory: (will be under /opt/<directory>) " toolsdirectory

echo "[*] System updates"
dnf update -y
dnf upgrade -y

read -p "[?] Install zsh and Oh My Zsh ? (y/n) " installZsh

if [ "$installZsh" = "y" ]; then

  echo "[*] Installing Nerd Fonts"

  mkdir -p /home/$username/.local/share/fonts

  # Hack
  wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip" -P /tmp && unzip /tmp/Hack.zip -d /tmp/Hack
  find /tmp/Hack -name "*Nerd Font Complete.ttf" -exec mv -t /home/$username/.local/share/fonts/ {} +

  # FiraCode
  wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip" -P /tmp && unzip /tmp/FiraCode.zip -d /tmp/FiraCode
  find /tmp/FiraCode -name "*Nerd Font Complete.ttf" -exec mv -t /home/$username/.local/share/fonts/ {} +

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

    read -p "[?] Do you want to install Rhylionn’s zshrc and terminator configuration ? (y/n) " copyZshrc
    
    if [ "$copyZshrc" = "y" ]; then
      cp home/.zshrc /home/$username/ && cp -r home/.config/terminator /home/$username/.config/
    fi

    read -p "[?] Do you want to install Rhylionn’s neovim configuration (y/n) ? " copyNeovim

    if [ "$copyNeovim" = "y" ]; then
      cp home/.config/nvim /home/$username/.config/
    fi
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

echo "[*] Installing base apps"

echo "[*] Installing brave browser"

dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
dnf install -y brave-browser

echo "[*] Installing vscode"

rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf update -y
dnf install -y code

echo "[*] Installation of basic tools"
dnf install -y neovim terminator curl htop git gparted openvpn neofetch perl-Image-ExifTool 

echo "[*] Installing docker"
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
usermod -aG docker $username

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
wget "https://portswigger-cdn.net/burp/releases/download?product=community&type=Linux" -O /tmp/burpsuite.sh && chmod +x /tmp/burpsuite.sh && /tmp/./burpsuite.sh

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

echo "[*] Clearing"
rm -rf /tmp/*

echo "[*] Fixing permissions"
chown -R $username:$username /opt/$toolsdirectory
