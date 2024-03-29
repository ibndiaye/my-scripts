#!/bin/bash
#

#main folders
LIST=("cava" "fish" "rofi" "neofetch" "kitty" "i3" "MangoHud" "ranger" "polybar" "starship.toml" "dunst")


mydots="$HOME/.dotfiles"

# if [[ ! -d "$mydots" ]]
# then
#     mkdir "$mydots"
#     cd $mydots && git init && git remote add origin https://github.com/ibndiaye/dotfiles.git && git remote set-url origin git@github.com:ibndiaye/dotfiles.git
# fi



#the state of mind while writing this script : WHAT the fuck am i doing here

#echo "exists"
read -r -p 'Backup config folder? (y/n) ' input
if [ "$input" == 'y' ]
then
    cp -r "$HOME/.config" "$HOME/.conifig.bak"
fi

read -r -p 'Clone dotfiles and symlink the configs(y/n)' input
if [ "$input" == 'y' ]
then
    if [[ ! -d dotfiles || -d .dotfiles ]]
    then
        cd && git clone https://github.com/ibndiaye/dotfiles && mv dotfiles/ .dotfiles/
        else
            cd && mv dotfiles/ .dotfiles/
    fi

    for f in "${LIST[@]}"
    do
        if [[ -d "$HOME/.config/$f" ]] 
        then
            rm -rf "$HOME/.config/$f"
            ln -sf "$mydots/config/$f" "$HOME/.config/" 
            else
                ln -sf "$mydots/config/$f" "$HOME/.config/"
        fi
    done
    chmod +x ~/.config/ranger/scope.sh
fi

#get fish
read -r -p 'Set up fish config(y/n)' input
if [ "$input" == 'y' ]
then
    cd && git clone https://github.com/ibndiaye/fishy && cd fishy && chmod +x install.sh && ./install.sh
fi

read -r -p 'Clone fkf wallpaper repo(y/n)' input
if [ "$input" == 'y' ]
then
    echo "cloning and moving wallpapers..."
    if [[ ! -d wallpapers ]]
    then
        cd && git clone https://github.com/fkf-studios/wallpapers && cp -r wallpapers "$HOME/Pictures/"
        else
            cp -r wallpapers "$HOME/Pictures/"
        fi
    echo "done moving wallpapers"
fi


#let me get u a cheat sheet fot that
#lets do it down here



read -r -p "Set up drive?(y/n)" input
if [ "$input" == "y" ]
then
    if [ ! -d "/drives" ]
    then
        sudo mkdir /drives
    fi
    read -r -p "mount point name: " mountname
    sudo mkdir "/drives/$mountname"
    lsblk -f
    read -r -p "uuid: " inuu 
    read -r -p "filesystem: " infile
    filesys=$infile
    uuid=$inuu
    append="UUID=$uuid  /drives/$mountname      $filesys     noatime,x-systemd.automount,x-systemd.idle-timeout=1min 0 2"
    sudo cp /etc/fstab /etc/fstab.bak
    if  ! grep -q "$uuid" /etc/fstab 
    then
        echo $append | sudo tee -a /etc/fstab
        # sudo bash -c 'echo $append >> /etc/fstab' 
    fi
    sudo chown -R $USER /drives 
    sudo chown -R $USER "/drives/$mountname"
    sudo mount -a
    systemctl daemon-reload
    echo "drive mounted"
fi


echo 'Clearing up cloned repos'
rm -rf "$HOME/wallpapers"
rm -rf "$HOME/dotfiles"
rm -rf "$HOME/fishy"
#rm -rf "$HOME/my-scripts"

