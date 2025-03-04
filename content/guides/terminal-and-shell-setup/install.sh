#!/bin/bash

set -e

REQUIRED_PROGRAMS=(
  wget
  curl
  git
  bat
  fzf
  eza
  oh-my-posh
)

[[ "$OSTYPE" == darwin* ]] && REQUIRED_PROGRAMS+=(brew)

MISSING_PROGRAMS=()

# Check each command
for cmd in "${REQUIRED_PROGRAMS[@]}"; do
  if ! command -v "$cmd" &> /dev/null; then
    MISSING_PROGRAMS+=("$cmd")
  fi
done

# If any commands are missing, list them and exit
if [ ${#MISSING_PROGRAMS[@]} -ne 0 ]; then
  echo "Error: Missing required programs:"
  printf '%s\n' "${MISSING_PROGRAMS[@]}"
  exit 1
fi

[ -f /etc/zsh/zshrc ] && grep -q "skip_global_compinit=1" /etc/zsh/zshrc && \
  (grep -q "^skip_global_compinit=1$" ~/.zshenv 2>/dev/null || \
  (echo "skip_global_compinit=1" >> ~/.zshenv && echo "Updated ~/.zshenv"))


echo "Installing plugins to ~/.local/share"
ZSH_PLUGINS=(
  mattmc3/ez-compinit
  lukechilds/zsh-nvm
)
if [[ "$OSTYPE" == darwin* ]]; then
  # On macOS I prefer installing these using brew
  brew install zsh-autosuggestions zsh-syntax-highlighting
else
  ZSH_PLUGINS+=(zsh-users/zsh-syntax-highlighting zsh-users/zsh-autosuggestions)
fi
for REPO in "${ZSH_PLUGINS[@]}"; do
  echo "$REPO"
  git clone --depth 1 "https://github.com/$REPO" "$HOME/.local/share/$(basename "$REPO")" >/dev/null
done

echo "Installing themes to ~/.local/share/themes"
THEME_URLS=(
  https://lickthesalt.com/guides/terminal-and-shell-setup/acecat.omp.toml
  https://github.com/catppuccin/zsh-syntax-highlighting/raw/main/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
  https://github.com/catppuccin/delta/raw/main/catppuccin.gitconfig
)
mkdir -p ~/.local/share/themes
for THEME_URL in "${THEME_URLS[@]}"; do
  THEME_FILENAME=$(basename "$THEME_URL")
  echo "$THEME_FILENAME"
  wget -q -c "$THEME_URL" -O ~/.local/share/themes/"$THEME_FILENAME"
done

BAT_THEMES_DIR="$(bat --config-dir)/themes"
echo "Installing Catppuccin Mocha theme for bat"
mkdir -p "$BAT_THEMES_DIR"
wget -q -c https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme -O "$BAT_THEMES_DIR/Catppuccin Mocha.tmTheme"
bat cache --build

[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc-"$(date +%s)"
curl -s https://lickthesalt.com/guides/terminal-and-shell-setup/zshrc > ~/.zshrc