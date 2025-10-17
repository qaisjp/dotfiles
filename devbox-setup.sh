#!/bin/bash

set -euo pipefail

if ! [[ $(hostname) =~ qa-mydev* ]]; then
  # ----- local -----

  pay sync --no-sync-loop "$HOME/stripe/dotfiles":/home/qaisjp/.dotfiles

  pay ssh 'cd /home/qaisjp/.dotfiles && ./devbox-setup.sh'

  exit
fi

# ----- remote -----

# Monorepo optimisation
git config --global push.negotiate true

echo "💻 Installing oh-my-zsh..."
if [ ! -d ~/.oh-my-zsh ]; then
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

  echo "✅ Successfully installed oh-my-zsh."
else
  echo "✅ oh-my-zsh is already installed. Skipping step."
fi

echo "🦥 Installing fzf..."
if ! [ -x "$(command -v fzf)" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --bin
fi
echo "✅ Successfully installed fzf."

# Symlink zsh stuff
ln -f -s "$HOME/.dotfiles/oh-my-zsh/custom/aliases.zsh" "$HOME/.oh-my-zsh/custom/aliases.zsh"
ln -f -s "$HOME/.dotfiles/oh-my-zsh/custom/themes/robbynew.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/robbynew.zsh-theme"

# Replace ZSH_THEME="robbyrussell" with ZSH_THEME="robbynew"
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="robbynew"/g' "$HOME/.zshrc"
