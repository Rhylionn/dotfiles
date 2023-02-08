# Dotfiles

Auto install script and configurations for Fedora.
This script is cybersecurity related and will install multiple cybersecurity tools.

## The look

![Neovim and terminal preview side by side](preview.jpg?raw=true "Configuration preview")

## Installation

Install git first
```
sudo dnf install git
```

Then run the following command

```
git clone https://github.com/Rhylionn/dotfiles && cd dotfiles && sudo ./install.sh
```

## Default installed applications

By default, the script will install: *Brave Browser* and *Vscode*. *Discord*, *Telegram* and *Bitwarden desktop* are also installed through flatpak.

## Terminal and appearance

The terminal runs under *zsh* with *Oh My Zsh* and *powerlevel10k* for styling. It also contains the following plugins:

| Plugin | Description |
| --- | --- |
| `zsh-autosuggestion` | Suggest command as you type based on history and completions |
| `zsh-syntax-highlighting`  | Enable highlighting of commands |
| `fzf` | Command line fuzzy finder |

Aliases are also created to replace `ls` with `exa` and `cat` with `bat`.

Two Nerd Fonts are downloaded: *Hack* (for the terminal) and *Firacode* (For vscode).

## Neovim

A minimalist neovim configuration is also added containing few options but only one plugin: *lualine*.

## Cybersecurity tools

Here is non-exaustive list of tools installed:

| Tools | Description |
|-------|-------------|
| hping3 | A network tool used for testing firewalls and network security. |
| hydra | A password cracking tool that supports various protocols. |
| aircrack-ng | A wireless network security tool. |
| ettercap | A network security tool for man-in-the-middle attacks. |
| tcpdump | A network tool for capturing and analyzing network packets. |
| john | A password cracking tool for various file formats. |
| wireshark | A network protocol analyzer tool for capturing and analyzing network packets. |
| nmap | A network exploration and security auditing tool used for scanning. |
| burpsuite | A web security tool for testing web applications and performing security scans. |
| metasploit | An open-source framework for developing, testing and executing exploits. |
| recon-ng | A reconnaissance framework for web-based information gathering and data retrieval. |
| dnsrecon | A DNS enumeration tool |
| sqlmap | Tool used for detecting and exploiting SQL injection vulnerabilities. |
| impacket | Collection of Python classes for working with network protocols. |
| setoolkit | Penetration testing framework designed for social engineering. |
| SecLists | Collection of multiple types of lists used during security assessments. |

And more...

