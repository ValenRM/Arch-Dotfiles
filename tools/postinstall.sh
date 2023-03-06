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

Dotfiles_Dir="$HOME/.config/"
Git_Dir="$HOME/.repos/dotfiles/dotfiles"

#Vital Functions

function error_handler() {
    echo -e "\n${RED}${BOLD}Error: ${RESET}Command ${GREEN}'$1'${RESET} ${RED}${BOLD}failed${RESET} with exit status code of ${RED}${BOLD}$2${RESET}"
    return 0
}

function cleanup() {
  echo -e "${SHOWCURSOR}"
}

trap cleanup SIGINT
trap cleanup EXIT
trap 'error_handler "$BASH_COMMAND" "$?"' ERR

function show_prompt() {
    echo -e "${HIDECURSOR}${CYAN}============ Arch Linux Post Install ============${RESET}\n\n"
}

function sudo_request() {
    trap 'error_handler "$BASH_COMMAND" "$?"' ERR
    sudo -v
}

function install_dependencies() {
    trap 'error_handler "$BASH_COMMAND" "$?"' ERR
    echo -e "${YELLOW}${BOLD}[*] ${RESET}Installing Dependencies..."
    sudo pacman -Syu --noconfirm > /dev/null 2>&1
    sudo pacman -Sq --noconfirm xorg-server xorg-xsetroot xorg-xrandr xorg-xinit xf86-video-qxl python openssh bspwm sxhkd rofi nitrogen picom kitty chromium ttf-hack-nerd firefox zsh git bat lsd neovim ranger > /dev/null 2>&1
    sleep 1
    mkdir $HOME/.repos
    mkdir $HOME/.repos/yay
    git clone -q https://aur.archlinux.org/yay-git.git ~/.repos/yay > /dev/null 2>&1
    cd $HOME/.repos/yay
    makepkg --noconfirm -si > /dev/null 2>&1
    cd
    git clone -q --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10 > /dev/null 2>&1
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc #will be removed later on
    yay --noconfirm -S polybar > /dev/null 2>&1
    tput cuu1
    tput ed
    echo -e "${GREEN}${BOLD}[*] ${RESET}Dependencies"
}

function clone_configs() {
    trap 'error_handler "$BASH_COMMAND" "$?"' ERR
    echo -e "${YELLOW}${BOLD}[*] ${RESET}Cloning Dotfiles..."
    mkdir $HOME/.repos/dotfiles
    git clone https://github.com/ValenRM/tempfiles $HOME/.repos/dotfiles > /dev/null 2>&1
    sleep 2
    for folder in "$Git_Dir"/*/; do
        folder=${folder%*/}
        cp -r "$folder" "$Dotfiles_Dir"
    done
    mkdir $HOME/.config/bspwm
    mv $HOME/.config/bspwmrc $HOME/.config/bspwm
    cp $HOME/.repos/dotfiles/dotfiles/xinitrc $HOME/.xinitrc
    mkdir $HOME/Documents
    cp -r $HOME/.repos/dotfiles/Wallpapers $HOME/Documents
    mkdir $HOME/Downloads
    chmod +x $HOME/.config/bspwm/bspwmrc
    chmod +x $HOME/.config/sxhkd/sxhkdrc
    chmod +x $HOME/.config/polybar/launch.sh
    chmod +x $HOME/.config/polybar/scripts/network.sh
    chmod +x $HOME/.config/polybar/scripts/performance_counters.sh
    tput cuu1
    tput ed
    echo -e "${GREEN}${BOLD}[*] ${RESET}Dotfiles"
    #monitor=$(xrandr | grep " connected" | cut -f1 -d " ")
    #sed -i "s/# xrandr/xrandr --output ${monitor} --mode 1920x1080/g" $HOME/.xinitrc
}

sudo_request
clear
show_prompt
install_dependencies
clone_configs
cleanup
echo "finished"
read

# TODO: Set display resolution automatically - done
# TODO: Set background automatically
# TODO: Bind Cat to Bat & Ls to Lsd