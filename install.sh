#!/bin/bash
# Made by rhylionn

if [ "$EUID" -ne 0 ]; then
  echo $'\n\e[1;31m[!] The script must be run as root\e[0m\n'
  exit
fi

read -p $'\e[1;31m[!] This script made for fedora distributions, continue ? (y/n)\e[0m ' continueInstall

if [ "$continueInstall" != "y" ]; then
  exit
fi

read -p $'\ne[1;32m[?] Username (for permissions):\e[0m ' username
read -p $'\ne[1;32m[?] Tool installation directory: (will be under /opt/<directory>) \e[0m' toolsdirectory

echo $'\n\e[1;34m[*] System updates\e[0m\n'
dnf update -y
dnf upgrade -y

dnf install -y util-linux-user

read -p $'\ne[1;32m[?] Install zsh and Oh My Zsh ? (y/n) \e[0m\n' installZsh

if [ "$installZsh" = "y" ]; then

  echo $'\n\e[1;34m[*] Installing Nerd Fonts\e[0m\n'

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
  
  echo $'\n\e[1;34m[*] Installing omz plugins\e[0m\n'
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/home/$username/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-/home/$username/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  sed -i 's/^plugins=\(.*\)$/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf)/' /home/$username/.zshrc

  read -p $'\ne[1;32m[?] Do you want to install p10k ? (y/n)\e[0m ' installP10k
	
  if [ "$installP10k" = "y" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-/home/$username/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i 's/ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' /home/$username/.zshrc

    read -p $'\ne[1;32m[?] Do you want to install Rhylionn’s zshrc and terminator configuration ? (y/n)\e[0m ' copyZshrc
    
    if [ "$copyZshrc" = "y" ]; then
      cp home/.zshrc /home/$username/ && cp -r home/.config/terminator /home/$username/.config/
    fi

    read -p $'\ne[1;32m[?] Do you want to install Rhylionn’s neovim configuration (y/n) ?\e[0m ' copyNeovim

    if [ "$copyNeovim" = "y" ]; then
      cp -r home/.config/nvim /home/$username/.config/
    fi
  fi
 
  chsh -s $(which zsh) $username
fi

echo $'\n\e[1;34m[*] Installing core dependencies\e[0m\n'
dnf group -y install "C Development Tools and Libraries"
dnf install -y dnf-plugins-core gnome-tweaks


echo $'\n\e[1;34m[*] Installing flatpak and applications\e[0m\n'
dnf install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub com.bitwarden.desktop com.discordapp.Discord md.obsidian.Obsidian org.telegram.desktop

echo $'\n\e[1;34m[*] Installing base apps\e[0m\n'
echo $'\n\e[1;34m[*] Installing brave browser\e[0m\n'

dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
dnf install -y brave-browser

echo $'\n\e[1;34m[*] Installing vscode\e[0m\n'

rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf update -y
dnf install -y code

echo $'\n\e[1;34m[*] Installation of basic tools\e[0m\n'
dnf install -y neovim terminator curl htop git gparted openvpn neofetch perl-Image-ExifTool 

echo $'\n\e[1;34m[*] Installing docker\e[0m\n'
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
usermod -aG docker $username

echo $'\n\e[1;34m[*] Installing python\e[0m\n'
dnf install -y python3 python3-pip

echo $'\n\e[1;34m[*] Installing ruby and ruby gems\e[0m\n'
dnf install -y ruby ruby-devel rubygems

echo $'\n\e[1;34m[*] Creating tools directory\e[0m\n'
mkdir /opt/$toolsdirectory/
cd /opt/$toolsdirectory/
mkdir wordlists
mkdir recon
mkdir webapps
mkdir social-engineering
mkdir postexploitation

echo $'\n\e[1;34m[*] Installation of basic pentest tools\e[0m\n'
dnf install -y nmap hping3 hydra aircrack-ng ettercap tcpdump john wireshark

echo $'\n\e[1;34m[*] Installation of burpsuite\e[0m\n'
wget "https://portswigger-cdn.net/burp/releases/download?product=community&type=Linux" -O /tmp/burpsuite.sh && chmod +x /tmp/burpsuite.sh && /tmp/./burpsuite.sh

echo $'\n\e[1;34m[*] Downloading wordlists\e[0m\n'
cd /opt/$toolsdirectory/wordlists
git clone https://github.com/danielmiessler/SecLists
git clone https://github.com/Mebus/cupp
git clone https://github.com/digininja/CeWL CeWL && cd CeWL && bundle install

cd /opt/$toolsdirectory/

echo $'\n\e[1;34m[*] Installing metasploit\e[0m\n'
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > /tmp/msfinstall
chmod +x /tmp/msfinstall
/tmp/./msfinstall

echo $'\n\e[1;34m[*] Installing recon tools\e[0m\n'
cd /opt/$toolsdirectory/recon/
git clone https://github.com/laramies/theHarvester
git clone https://github.com/aboul3la/Sublist3r
git clone https://github.com/lanmaster53/recon-ng 
git clone https://github.com/laramies/metagoofil 
git clone https://github.com/darkoperator/dnsrecon

echo $'\n\e[1;34m[*] Installing social engineering tools\e[0m\n'
cd /opt/$toolsdirectory/social-engineering/ 
git clone https://github.com/trustedsec/social-engineer-toolkit setoolkit/ && cd setoolkit && pip install -r requirements.txt && python setup.py


echo $'\n\e[1;34m[*] Installing web application pentest tools\e[0m\n'
cd /opt/$toolsdirectory/webapps/
dnf install -y nikto gobuster wfuzz
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git
gem install wpscan

echo $'\n\e[1;34m[*] Installing post exploitation tools\e[0m\n'
cd /opt/$toolsdirectory/postexploitation/
git clone https://github.com/fortra/impacket && python3 -m pip install impacket/

cd /

echo $'\n\e[1;34m[*] Clearing\e[0m\n'
rm -rf /tmp/*

echo $'\n\e[1;34m[*] Fixing permissions\e[0m\n'
chown -R $username:$username /opt/$toolsdirectory
