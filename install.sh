DOTFILES_DIRECTORY="$( cd "$(dirname "$0")" ; pwd -P )"

# copy dotfiles to the correct places...
ln -hsF $DOTFILES_DIRECTORY/yabai $HOME/.config/yabai
ln -hsF $DOTFILES_DIRECTORY/skhd $HOME/.config/skhd
ln -hsF $DOTFILES_DIRECTORY/hammerspoon $HOME/.hammerspoon

# Quiet the macOS "Last Login" message:
touch ~/.hushlogin
