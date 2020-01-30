# dotfiles

These dotfiles are for macOS. On Linux — which is currently DICE, a flavour of Scientific Linux 7 — I use stuff that is in my [Xmonad](https://github.com/qaisjp/xmonad) repo (and more).

Some of this work was inspired by [/u/sptz's post on /r/macOS](https://www.reddit.com/r/MacOS/comments/evk0pu/yabai_twm_for_macos/).

* **window manager**: [yabai](https://github.com/koekeishiya/yabai)
* **hotkeys**: [skhd](https://github.com/koekeishiya/skhd)
* **keyboard customisation**: [karabiner elements](https://github.com/pqrs-org/Karabiner-Elements)
* **vscode opacity**: [vibrancy](https://github.com/EYHN/vscode-vibrancy)
* **terminal**: [iterm 2](https://iterm2.com/)
* **font**: [cascadia code](https://github.com/microsoft/cascadia-code)

**Files**

Use the following commands (or notes) to apply the files from this repo. Files from this repo are in the `dotfiles` folder. Commands assume you are in the home directory.

- `ln -s dotfiles/skhdrc .skhdrc`
- `ln -s dotfiles/yabairc .yabairc`

(`->` means it's a symlink)

## things yet to add here

- add zsh stuff especially my modified zsh theme

## wishes

- to make stuff be more like my experience using xmonad on DICE. which likely can never happen. it only worked because on Linux the super key was rarely used. (super was my mod key)

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

## Other tips

- Restart `yabai` using `launchctl kickstart -k "gui/${UID}/homebrew.mxcl.yabai"`
- Reload `skhd` using `skhd -r` or `skhd --reload`
