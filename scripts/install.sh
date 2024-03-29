#!/bin/bash
#
#

FDIR="$HOME/.local/share/fonts"

#echo "We need an AUR helper. It is essential. 1) yay       2) paru"
#read -r -p "What is the AUR helper of your choice? (Default is yay): " num

#if [[ $num -eq 2 ]]
#then
#    HELPER="paru"
#fi

if ! command -v yay &> /dev/null
then
    echo "It seems that you don't have yay installed, I'll install that for you before continuing."
    git clone https://aur.archlinux.org/yay.git ~/.srcs/yay
    (cd ~/.srcs/yay/ && makepkg -si )
fi

#menu=printf "1) GPU Drivers Install\n 2) Pkgs Installation\n 3) Virt-manager install"
#read input

###########################
########GPU driver#########
##########################

read -r -p "Install video drivers? (y/n)" input
if [[ "$input" == "y" ]]
then
    sudo pacman -S $vid

    # choose video driver
    echo "1) xf86-video-intel 2) xf86-video-amdgpu 3) nvidia 4) Skip"
    read -r -p "Choose you video card driver(default 1)(will not re-install): " vid

    case $vid in
    1) yay -S --needed xf86-video-intel;;
    2) yay -S --needed xf86-video-amdgpu;;
    3) yay -S --needed nvidia-dkms nvidia-settings nvidia-utils;;
    4) DRI="";;
    *) yay -S --needed xf86-video-intel;;
    esac
    else
        echo "skipping"
fi

#program installation
read -r -p "Install Pkgs? (y/n)" input
if [[ "$input" == "y" ]]
then
    pkglist=()

    read -r -p "Install rofi pkgs? (y/n)" input
    if [ "$input" == 'y' ]
        then
            rofiPkgs=("rofi-greenclip" "flameshot" "ranger" "rofi" "rofi-calc" "rofi-emoji")
            pkglist+=("${rofiPkgs[@]}")
    fi
    
    read -r -p "Install WM pkgs? (y/n)" input
    if [ "$input" == 'y' ]
        then
            wmPkgs=("lazygit" "autotiling" "polybar" "dunst" "picom" "lxappearance" "nitrogen" "rofi-power-menu" "pavucontrol")
            pkglist+=("${wmPkgs[@]}")
    fi
    
    read -r -p "Install misc pkgs? (y/n)" input
    if [ "$input" == 'y' ]
        then
            miscPkgs=("mpv" "gimp" "hplip" "htop" "cava" "kitty" "neofetch"  "spotify-adblock-git" "pavucontrol" "tilp" "scrcpy" )
            pkglist+=("${miscPkgs[@]}")
    fi
    
    read -r -p "Install btrfs pkgs? (y/n)" input
    if [ "$input" == 'y' ]
        then
            btrfsPkgs=("timeshift" "timeshift-autosnap" "tldr" "grub-btrfs")
            pkglist+=("${btrfsPkgs[@]}")
    fi
    
    echo "installing packages..."
    for p in "${pkglist[@]}"
    do
        read -r -p "install $p?(y/n)" input
        if [ "$input" == 'y' ]
        then
            echo "installing $p"
            yay -S --noconfirm --needed "$p"
            echo "$p installed"
            else
                echo "skipping $p"
            fi
    done
    
    echo "done installing pkgs"
    
    #sudo grub-mkconfig && timeshift

    # #install fonts for polybar-themes
    # echo -e "\n[*] Installing fonts..."
    # cd && git clone https://github.com/adi1090x/polybar-themes
    # [[ ! -d "$FDIR" ]] && mkdir -p "$FDIR"
    # cp -rf $HOME/polybar-themes/fonts/* "$FDIR"
    # rm -rf $HOME/polybar-themes/
    # else
    #     echo "skipping"
fi

#virt man setup
read -r -p "Install Virt-manager? (y/n)" input
if [[ "$input" == "y" ]]
then
    echo "Installing and setting up virt-manager..."
    sudo pacman -S --needed virt-manager qemu-base libvirt edk2-ovmf dnsmasq vde2 bridge-utils iptables-nft dmidecode
    sudo systemctl enable --now libvirtd.service
    systemctl status libvirtd.service
    sudo virsh net-autostart default
    yay -S --noconfirm libguestfs qemu-emulators-full qemu-block-gluster qemu-block-iscsi samba
    echo "all done"
    else
        echo "skipping"
fi

#flatpak install
read -r -p "Install FlatPaks? (y/n)" input
if [[ "$input" == "y" ]]
then
    flatpakProgramList=("com.discordapp.Discord" "com.ultimaker.cura"
     "com.github.tchx84.Flatseal" "com.jetbrains.IntelliJ-IDEA-Community"
    "com.microsoft.Teams" "org.telegram.desktop" "io.github.mimbrero.WhatsAppDesktop" 
    "com.anydesk.Anydesk" "io.github.shiftey.Desktop")
    yay -S --noconfirm --needed flatpak
    for p in "${flatpakProgramList[@]}"
    do
        read -r -p "install $p?(y/n)" input
        if [ "$input" == 'y' ]
        then
            echo "installing $p"
            flatpak install flathub -y --noninteractive "$p"
            echo "$p installed"
            else
                echo "skipping $p"
            fi
    done
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

    echo "done installing flatpaks"
fi


