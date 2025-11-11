# dotfiles (2025)


Enable sudo with Touch ID:

```
sudo vi /etc/pam.d/sudo
# Add the following line to the top, below the header:
# auth       sufficient     pam_tid.so
```

## aerospace

As per [a note on mission control](https://nikitabobko.github.io/AeroSpace/guide#a-note-on-mission-control) I've enabled "Group windows by application"

```
defaults write com.apple.dock expose-group-apps -bool true && killall Dock
```

As per [this note](https://nikitabobko.github.io/AeroSpace/guide#a-note-on-displays-have-separate-spaces) I've also disabled "Displays have separate spaces".

As per [this note](https://nikitabobko.github.io/AeroSpace/goodies#disable-open-animations) disable window open animations:

```
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
```


# dotfiles (old)

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
- get into spacemacs, could use https://github.com/easymotion/vim-easymotion#readme

## Status bar

The [simple status bar that ships with yabai](https://github.com/koekeishiya/yabai/wiki/Configuration#status-bar) is used.

This setting mentioned below is enabled:

> The status bar is not intended to be used with the macOS menu bar visible. You can turn on autohiding of the macOS menubar so that it only shows up when you move your cursor to access it: System Preferences -> General -> Automatically hide and show the menu bar.

Maybe we can switch to `xmobar`? Maybe I shouldn't, I don't need a reason to have Haskell installed anymore. Cabal is awful — it doesn't support uninstall. Stack is meant for projects. Bye Haskell, I guess.

## Karabiner settings

I use Karabiner (beta) to change some default keybinds

Complex modifications:

- Quit application by holding command-q (modified to use `left_command` as input, rather than just any `command`)
- PC-Style Home/End
- Cmd+Shift+X to Lock Screen
    - This is not a default complex modification. See [extra/karabiner.json](extra/karabiner.json).
    - This works by mapping the input keybind to macOS' lock screen keybind: `ctrl + cmd + q`

Simple modifications:

- Swap `left_command` and `left_option`, because my `left_command` needs me to press harder (I need to go to the Genius bar!)
- Map `non_us_backslash` to `right_command`. This makes it easier to switch spaces. Resolving [#<span></span>107](https://github.com/koekeishiya/skhd/issues/107) should get rid of this.

Also, I enabled `Manipulate LED` under the `Caps Lock LED` column on the "Devices" tab because otherwise the LED stops working.

## Other tips

- Restart `yabai` using `launchctl kickstart -k "gui/${UID}/homebrew.mxcl.yabai"`
- Reload `skhd` using `skhd -r` or `skhd --reload`

# Windows stuff

I use scoop.

- Install `gh` using https://github.com/cli/cli
- `scoop install msys2`
- `scoop install ag`

**[The difference between and MSYS2 MinGW](https://sourceforge.net/p/msys2/discussion/general/thread/dcf8f4d3/)**

- MSYS2 is based on Cygwin and knows how to understand POSIX conventions like paths (`/usr/bin/`, `/etc`) as well as special devices like `/dev/null`, `/dev/clipboard`, etc and many other things. The POSIX emulation layer is done inside `msys-2.0.dll` and incurs a performance penalty that can be significant for heavy file-centric software (e.g. `git`).
- MinGW is a set of toolchains to build native Windows applications.
- **MSYS2 is slower than MinGW** - so you should prefer to install using scoop than in MinGW.

TL;DR just prefer MinGW.
