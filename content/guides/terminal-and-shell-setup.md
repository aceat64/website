---
status: new
description: Terminal and shell configuration.
social:
    cards_layout: default/only/image
    cards_layout_options:
        background_image: content/guides/terminal-and-shell-setup/social_card.png
---

# Terminal & Shell Setup

![Ghostty with zsh and acecat theme](terminal-and-shell-setup/zsh_screenshot_1.png)
![Ghostty with zsh and acecat theme, remote and root](terminal-and-shell-setup/zsh_screenshot_2.png)

## Ghostty

I've started using [Mitchell Hashimoto's](https://mitchellh.com/) [Ghostty](https://ghostty.org/), it's fast, clean and runs natively on both macOS and Linux.

> Ghostty is a fast, feature-rich, and cross-platform terminal emulator that uses platform-native UI and GPU acceleration.

### Configuration

```ini
theme = catppuccin-mocha
font-family = "MesloLGM Nerd Font"
keybind = global:cmd+grave_accent=toggle_quick_terminal
```

Ghostty on macOS has a [Quick Terminal](https://ghostty.org/docs/features#macos), I've set a global keybinding of ++cmd+grave-accent++ so I can access it from anywhere.

![Ghossty quick terminal](terminal-and-shell-setup/quick_terminal.png){ loading=lazy }

### Optional: VS Code Settings

VS Code users will need to add the following to their `settings.json`:

```json
"terminal.external.osxExec": "Ghostty.app",
"terminal.integrated.fontFamily": "MesloLGM Nerd Font",
```

## Z shell (zsh)

Required software:

- [bat](https://github.com/sharkdp/bat)
- [eza](https://github.com/eza-community/eza)
- [fzf](https://github.com/junegunn/fzf)
- [Oh My Posh](https://ohmyposh.dev)

=== ":simple-apple: macOS"

    ```shell
    brew install bat eza fzf jandedobbeleer/oh-my-posh/oh-my-posh
    ```

=== ":simple-linux: Linux"

    For `bat`, `eza`, and `fzf` most distros have recent enough versions, use your package manager.

    You'll need to install `oh-my-posh` using their script:

    ```shell
    curl -s https://ohmyposh.dev/install.sh | bash -s
    ```

!!! note

    Ghostty has [Nerd Fonts](https://www.nerdfonts.com/) built-in, so if you use another terminal emulator you will need to install the `Meslo` font yourself.

### Automatic Install

```shell
curl -s https://lickthesalt.com/guides/terminal-and-shell-setup/install.sh | bash -s
```

### Files

Here are the files, if you just want to look at them instead of running my install script.

??? example "install.sh"

    ```shell
    --8<-- "content/guides/terminal-and-shell-setup/install.sh"
    ```

??? example "zshrc"

    ```shell
    --8<-- "content/guides/terminal-and-shell-setup/zshrc"
    ```

??? example "acecat Oh-My-Posh Theme"

    ```shell
    --8<-- "content/guides/terminal-and-shell-setup/acecat.omp.toml"
    ```

### Finishing Touches

To use delta with git, update your `~/.gitconfig` with the following:

```toml
[interactive]
    diffFilter = delta --color-only
[include]
    path = ~/.local/share/themes/catppuccin.gitconfig
[delta]
    features = catppuccin-mocha
    side-by-side = true
    navigate = true    # use n and N to move between diff sections
    dark = true
[merge]
    conflictstyle = zdiff3
[diff]
    colorMoved = default
```
