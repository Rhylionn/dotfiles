#!/bin/bash
# Made by rhylionn

if [ "$EUID" -ne 0 ]; then
	echo "[!] The script must be run as root"
	exit
fi

read -p "[!] This script is meant to be executed on RHEL distributions, continue ? (y/n) " continueInstall

if [ "$continueInstall" != "y" ]; then
	exit
fi


read -p "[?] What is your session username so I can fix permissions and install required tools in your home directory ? " username

read -p "[?] In which directory do you want the tools to be installed in /opt/<directory>/ ?" toolsdirectory

echo "[*] System updates"
dnf update -y
dnf upgrade -y

read -p "[?] Do you want to install zsh and Oh My Zsh ? (y/n) " installZsh

if [ "$installZsh" = "y" ]; then
	dnf install zsh
	git clone https://github.com/ohmyzsh/ohmyzsh.git /home/$username/.oh-my-zsh
	cp /home/$username/.oh-my-zsh/templates/zshrc.zsh-template /home/$username/.zshrc

  echo "[*] Installing omz plugins"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/home/$username/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-/home/$username/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  read -p "[?] Do you want to install p10k ? (y/n) " installP10k
	
	if [ "$installP10k" = "y" ]
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-/home/$username/.oh-my-zsh/custom}/themes/powerlevel10k
		sed -i 's/ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' /home/$username/.zshrc

	chsh -s $(which zsh) $username

echo "[*] Installing core dependencies"
dnf group -y install "C Development Tools and Libraries"

echo "[*] Installation of basic tools"
dnf install -y nvim terminator curl htop git gparted openvpn docker docker-compose 

echo "[*] Installing python"
dnf install -y python3 python3-pip

echo "[*] Installing ruby and ruby gems"
dnf install -y ruby ruby-devel rubygems

echo "[*] Creating tools directory"
mkdir /opt/$toolsdirectory/
cd /opt/$toolsdirectory/
mkdir /opt/$toolsdirectory/wordlists
mkdir /opt/$toolsdirectory/recon
mkdir /opt/$toolsdirectory/webapps
mkdir /opt/$toolsdirectory/social-engineering

echo "[*] Installation of basic pentest tools"
dnf install -y nmap hping3 hydra aircrack-ng ettercap tcpdump john nmap wireshark

echo "[*] Installation of burpsuite"
# https://portswigger-cdn.net/burp/releases/download?product=community&version=2022.12.7&type=Linux

echo "[*] Downloading wordlists"
git clone https://github.com/danielmiessler/SecLists ./wordlists

echo "[*] Installing metasploit"
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > /tmp/msfinstall
chmod +x /tmp/msfinstall
/tmp/./msfinstall

echo "[*] Installing recon tools"
git clone https://github.com/laramies/theHarvester ./recon/theHarvester
git clone https://github.com/aboul3la/Sublist3r ./recon/Sublist3r
git clone https://github.com/lanmaster53/recon-ng ./recon/recon-ng
git clone https://github.com/laramies/metagoofil ./recon/metagoofil
git clone https://github.com/darkoperator/dnsrecon ./recon/dnsrecon
git clone https://github.com/trustedsec/social-engineer-toolkit ./recon/setoolkit && pip install -r ./recon/setoolkit/requirements.txt && python setup.py


echo "[*] Installing web application pentest tools"
dnf install -y nikto gobuster
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git ./webapps/sqlmap
gem install wpscan

echo "[*] Installing social engineering tools"
git clone https://github.com/trustedsec/social-engineer-toolkit ./social-engineering/social-engineer-toolkit && pip install -r social-engineer-toolkit/requirements.txt && sudo python3 social-engineer-toolkit/setup.py 
