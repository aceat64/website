---
status: new
description: Terminal and shell configuration.
---

# Terminal & Shell Setup

## Ghostty

I've started using [Mitchell Hashimoto's](https://mitchellh.com/) [Ghostty](https://ghostty.org/), it's fast, clean and runs natively on both macOS and Linux.

> Ghostty is a fast, feature-rich, and cross-platform terminal emulator that uses platform-native UI and GPU acceleration.

### Configuration

```ini
theme = catppuccin-mocha
font-family = "MesloLGM Nerd Font Mono"
```

!!! note

    Ghostty has [Nerd Fonts](https://www.nerdfonts.com/) built-in, so if you use another terminal emulator you will need to install the `Meslo` font yourself.

## Z shell (zsh)

<div class="grid cards" markdown>

- [Oh My Posh](https://ohmyposh.dev)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [acecat (catppuccin-mocha) theme](#acecat-theme)

</div>

### zshrc

```zsh title="~/.zshrc"
--8<-- "content/guides/terminal-and-shell-setup/.zshrc"
```

### acecat Theme

```zsh title="~/.config/ohmyposh/acecat.omp.toml"
--8<-- "content/guides/terminal-and-shell-setup/acecat.omp.toml"
```

### Optional: VS Code Settings

VS Code users will need to add the following to their `settings.json`:

```json
"terminal.external.osxExec": "Ghostty.app",
"terminal.integrated.fontFamily": "MesloLGM Nerd Font Mono",
```
