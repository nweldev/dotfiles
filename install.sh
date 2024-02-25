echo "You should check the install.sh file and modify it first."
exit 1

is_ubuntu() {
  [[ $(lsb_release -i) =~ "Ubuntu" ]]
  return $?
}

is_manjaro() {
  [[ $(lsb_release -i) =~ "Manjaro" ]]
  return $?
}

Help()
{
   # Display Help
   echo "dotfiles manager"
   echo
   echo "Syntax: run.sh <command>"
   echo "commands:"
   echo "help      Print this Help."
   echo "check     Check the system."
   echo

   exit 0
}

Check()
{
  echo distribution:
  lsb_release -i | cut -f 2-

  if is_ubuntu(); then
    echo "Ubuntu detected ✅"
  elif is_manjaro(); then
    echo "Manjaro detected ✅"
  else
    echo "unsupported distribution ❌"
  fi
}

Install()
{
  ## Packages

  if is_manjaro; then
    sudo pacman -Sy $(cat packages.dsv | cut -d' ' -f1)

    # X Window System
    sudo pacman -S awesome xorg-xbacklight xorg-xmodmap
    # CLI utils
    sudo pacman -S xclip hub openssh vim sudo stow zsh autojump physlock
    # WiFi
    sudo pacman -S wpa_supplicant dialog iw elinks
    # Fonts
    sudo pacman -S powerline-fonts otf-fira-code noto-fonts-emoji
    # Sound
    sudo pacman -S alsa-utils playerctl
    # LightDM
    sudo pacman -S lightdm lightdm-gtk-greeter
    # Bluetooth (bluetoothctl)
    sudo pacman -S bluez bluez-utils
  fi

  # NVM git install

  stow nvm
  cd nvm
  . nvm.sh
  cd ..

  # install vs code extensions

  cat code-extensions.list | xargs -L 1 echo code --install-extension

  ## system config

  if is_manjaro; then
    sudo ln -sf $PWD/etc/X11/xorg.conf.d/00-keyboard.conf /etc/X11/xorg.conf.d/
    sudo ln -sf $PWD/etc/locale.conf /etc/
    sudo ln -sf $PWD/etc/lightdm/lightdm.conf /etc/lightdm
  fi

  ## Services

  # disable Manjaro NetworkManager

  if is_manjaro; then
    sudo systemctl disable --now NetworkManager.service
    sudo systemctl enable --now dhcpcd.service

    sudo systemctl enable netctl-auto@interface.service
    # enable a profile (in /etc/netctl/, maybe create with wifi-menu) to start at boot
    # sudo netctl enable my-profile
    sudo systemctl enable lightdm.service
  fi

  ## link user dotfiles
  # this project should be cloned in $HOME/dotfiles

  stow awesome
  stow git
  stow vscode
  stow zsh
  stow arandr
  stow nvm
  stow vim
  stow scripts
  stow desktop

  ## user services

  systemctl --user enable sleepprompt
  systemctl --user enable sleepprompt.timer
}

## Tools

# unmute master with 'm' key
alsamixer
# configure WiFi
sudo wifi-menu
# check installed packages
grep -i installed /var/log/pacman.log

## run awesome in a nested X server for tests
## ctrl+shift to capture keyboard and mouse
Xephyr :5 &
sleep 1
DISPLAY=:5 awesome

##### main

case $0 in
        "check" )
           Check;;
        "install" )
           Install;;
        "--copy" )
           COPY=true;;
        "--remove" )
           REMOVE=true;;