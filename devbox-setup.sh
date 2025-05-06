#!/bin/bash

set -euo pipefail

if ! [[ $(hostname) =~ qa-mydev* ]]; then
  # ----- local -----

  pay sync --no-sync-loop "$HOME/stripe/dotfiles":/home/qaisjp/.dotfiles

  pay ssh 'cd /home/qaisjp/.dotfiles && ./devbox-setup.sh'

  exit
fi

# ----- remote -----


echo "💻 Installing oh-my-zsh..."
if [ ! -d ~/.oh-my-zsh ]; then
  wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O ./zsh-installer.sh
  sudo chmod +x ./zsh-installer.sh
  ~/zsh-installer.sh --unattended --keep-zshrc

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
