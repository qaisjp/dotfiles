DOTFILES_DIRECTORY="$( cd "$(dirname "$0")" ; pwd -P )"

# copy dotfiles to the correct places...
ln -sf $DOTFILES_DIRECTORY/yabai $HOME/.config/yabai
ln -sf $DOTFILES_DIRECTORY/skhd $HOME/.config/skhd

# Quiet the macOS "Last Login" message:
touch ~/.hushlogin
