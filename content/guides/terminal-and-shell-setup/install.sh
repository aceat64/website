#!/usr/bin/env bash

set -e

REQUIRED_PROGRAMS=(
  wget
  curl
  git
  atuin
  bat
  eza
  oh-my-posh
)

[[ "${OSTYPE}" == darwin* ]] && REQUIRED_PROGRAMS+=(brew)

MISSING_PROGRAMS=()

# Check each command
for cmd in "${REQUIRED_PROGRAMS[@]}"; do
  if ! command -v "${cmd}" &> /dev/null; then
    MISSING_PROGRAMS+=("${cmd}")
  fi
done

# If any commands are missing, list them and exit
if [[ ${#MISSING_PROGRAMS[@]} -ne 0 ]]; then
  echo "Error: Missing required programs:"
  printf '%s\n' "${MISSING_PROGRAMS[@]}"
  exit 1
fi

# Some systems will call compinit before evaluating ~/.zshrc and we don't want that.
# On these systems we need to add "skip_global_compinit=1" to ~/.zshenv
[[ -f /etc/zsh/zshrc ]] && grep -q "skip_global_compinit=1" /etc/zsh/zshrc && \
  (grep -q "^skip_global_compinit=1$" ~/.zshenv 2>/dev/null || \
  (echo "skip_global_compinit=1" >> ~/.zshenv && echo "Updated ~/.zshenv"))

echo "Installing plugins to ~/.local/share"
ZSH_PLUGINS=(
  mattmc3/ez-compinit
  lukechilds/zsh-nvm
  rupa/z
)
if [[ "${OSTYPE}" == darwin* ]]; then
  # On macOS I prefer installing these using brew
  brew install zsh-autosuggestions zsh-syntax-highlighting
else
  ZSH_PLUGINS+=(zsh-users/zsh-syntax-highlighting zsh-users/zsh-autosuggestions)
fi
for REPO in "${ZSH_PLUGINS[@]}"; do
  echo "${REPO}"
  DIRECTORY="${HOME}/.local/share/$(basename "${REPO}")"
  if [[ -d "${DIRECTORY}" ]]; then
    cd "${DIRECTORY}"
    git pull
    cd -
  else
    git clone --depth 1 "https://github.com/${REPO}" "${DIRECTORY}" >/dev/null
  fi
done

echo "Installing themes to ~/.local/share/themes"
THEME_URLS=(
  https://andrew.lecody.com/guides/terminal-and-shell-setup/acecat.omp.toml
  https://github.com/catppuccin/zsh-syntax-highlighting/raw/main/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
  https://github.com/catppuccin/delta/raw/main/catppuccin.gitconfig
)
mkdir -p ~/.local/share/themes
for THEME_URL in "${THEME_URLS[@]}"; do
  THEME_FILENAME=$(basename "${THEME_URL}")
  echo "${THEME_FILENAME}"
  wget -q "${THEME_URL}" -O ~/.local/share/themes/"${THEME_FILENAME}"
done

BAT_THEMES_DIR="$(bat --config-dir)/themes"
echo "Installing Catppuccin Mocha theme for bat"
mkdir -p "${BAT_THEMES_DIR}"
wget -q https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme -O "${BAT_THEMES_DIR}/Catppuccin Mocha.tmTheme"
bat cache --build

ATUIN_CONFIG_DIR="${HOME}/.config/atuin"
ATUIN_THEMES_DIR="${ATUIN_CONFIG_DIR}/themes"
echo "Installing Catppuccin Mocha theme for atuin"
mkdir -p "${ATUIN_THEMES_DIR}"
wget -q https://github.com/catppuccin/atuin/raw/main/themes/mocha/catppuccin-mocha-sapphire.toml -O "${ATUIN_THEMES_DIR}/catppuccin-mocha-sapphire.toml"

curl -s https://andrew.lecody.com/guides/terminal-and-shell-setup/generate_completions > ~/.local/bin/generate_completions
chmod +x ~/.local/bin/generate_completions

update_files() {
  local DST_FILE DOWNLOAD_URL
  DST_FILE="$1"
  DOWNLOAD_URL="$2"
  TMPFILE=$(mktemp)
  BACKUP_TIMESTAMP="$(date +%s)"

  if [[ -z "${DST_FILE}" || -z "${DOWNLOAD_URL}" ]]; then
    echo "Usage: update_files <destination_file> <download_url>" >&2
    return 1
  fi

  echo "Downloading: ${DOWNLOAD_URL}"
  wget -q "${DOWNLOAD_URL}" -O "${TMPFILE}"
  if [[ -f "${DST_FILE}" ]]; then
    if ! diff -q "${DST_FILE}" "${TMPFILE}" > /dev/null 2>&1; then
      echo "Existing file differs from download, backing up file file to: ${DST_FILE}-${BACKUP_TIMESTAMP}"
      mv "${DST_FILE}" "${DST_FILE}-${BACKUP_TIMESTAMP}"
    fi
  fi
  echo "Installing file: ${DST_FILE}"
  mv "${TMPFILE}" "${DST_FILE}"
}

update_files "${HOME}/.zshrc" "https://andrew.lecody.com/guides/terminal-and-shell-setup/zshrc"
update_files "${HOME}/.zsh_aliases" "https://andrew.lecody.com/guides/terminal-and-shell-setup/zsh_aliases"
update_files "${HOME}/.zsh_functions" "https://andrew.lecody.com/guides/terminal-and-shell-setup/zsh_functions"
update_files "${ATUIN_CONFIG_DIR}/config.toml" "https://andrew.lecody.com/guides/terminal-and-shell-setup/atuin_config.toml"

echo "Testing the zsh setup, you may see nvm get setup during this."
zsh -i -c 'exit'

echo "Generating completion files, this avoids having to generate them each time we start a session."
~/.local/bin/generate_completions
