#!/bin/bash

#Text Colors and Effects
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

BOLD='\033[1m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
RESET='\033[0m'

HIDECURSOR="\e[?25l"
SHOWCURSOR='\e[?25h'

#Redirect to /dev/null

TONULL="> /dev/null 2>&1"

#Vital Functions

function error_handler() {
    echo -e "\n${RED}${BOLD}Error: ${RESET}Command ${GREEN}'$1'${RESET} ${RED}${BOLD}failed${RESET} with exit status code of ${RED}${BOLD}$2${RESET}"
    return 0
}

trap 'error_handler "$BASH_COMMAND" "$?"' ERR

function cleanup() {
  echo -e "${SHOWCURSOR}"
}

trap cleanup SIGINT
trap cleanup EXIT
trap 'error_handler "$BASH_COMMAND" "$?"' ERR

function show_prompt() {
    echo -e "${CYAN}============ Arch Linux Post Install ============${RESET}\n\n"
}

function sudo_request() {
    sudo -v
}

function install_dependencies() {
    echo -e "${YELLOW}${BOLD}[*] ${RESET}Installing Dependencies..."
    sudo pacman -Syu --noconfirm > /dev/null 2>&1
    sudo pacman -Sq --noconfirm xorg-server xorg-xinit xf86-video-qxl python openssh bspwm sxhkd rofi nitrogen picom kitty chromium arandr ttf-hack-nerd zsh git bat lsd neovim ranger > /dev/null 2>&1
    sleep 1
    mkdir ~/.repos
    mkdir ~/.repos/yay
    git clone -q https://aur.archlinux.org/yay-git.git ~/.repos/yay > /dev/null 2>&1
    cd ~/.repos/yay
    makepkg --noconfirm -si > /dev/null 2>&1
    git clone -q --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10 > /dev/null 2>&1
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc #will be removed later on
    sudo chsh -s $(which zsh) $(whoami)
}

function make_configs() {
    mkdir ~/.config/bspwm
    mkdir ~/.config/sxhkd
    mkdir ~/.config/polybar
    mkdir ~/.config/kitty
    mkdir ~/.config/picom
}

sudo_request
clear
show_prompt
install_dependencies
make_configs
read