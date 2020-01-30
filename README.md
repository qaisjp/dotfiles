# dotfiles

These dotfiles are for macOS. On Linux — which is currently DICE, a flavour of Scientific Linux 7 — I use stuff that is in my [Xmonad](https://github.com/qaisjp/xmonad) repo (and more).


**Files**

Use the following commands (or notes) to apply the files from this repo. Files from this repo are in the `dotfiles` folder. Commands assume you are in the home directory.

- `ln -s dotfiles/skhdrc .skhdrc`
- `ln -s dotfiles/yabairc .yabairc`

(`->` means it's a symlink)

## todo

- add zsh stuff especially my modified zsh theme

## Karabiner settings

I use Karabiner (beta) to change some default keybinds

Complex modifications:

- Quit application by holding command-q
- PC-Style Home/End
- Cmd+Shift+X to Lock Screen
    - This is not a default complex modification. See [extra/karabiner.json](extra/karabiner.json).
    - This works by mapping the input keybind to macOS' lock screen keybind: `ctrl + cmd + q`

Simple modifications:

- Swap `left_command` and `left_option`, because my `left_command` needs me to press harder (I need to go to the Genius bar!)

Also, I enabled `Manipulate LED` under the `Caps Lock LED` column on the "Devices" tab because otherwise the LED stops working.
