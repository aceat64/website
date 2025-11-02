#!/usr/bin/env bash

set -e

GREY='\033[0;30m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BOLD_RED='\033[1;31m'
BOLD_YELLOW='\033[1;33m'
BG_BLUE='\033[44m'
RESET='\033[0m'

REQUIRED_PROGRAMS=(
  curl
  lsb_release
  jq
)

MISSING_PROGRAMS=()

# Check each command
for cmd in "${REQUIRED_PROGRAMS[@]}"; do
  if ! command -v "${cmd}" &> /dev/null; then
    MISSING_PROGRAMS+=("${cmd}")
  fi
done

# If any commands are missing, list them and exit
if [[ ${#MISSING_PROGRAMS[@]} -ne 0 ]]; then
  echo -e "${BOLD_RED}Error:${RESET} Missing required programs:"
  printf '%s\n' "${MISSING_PROGRAMS[@]}"
  exit 1
fi

# Check if the distribution is Debian or Ubuntu
DISTRO=$(lsb_release --id --short)
if [[ "${DISTRO}" != "Debian" && "${DISTRO}" != "Ubuntu" ]]; then
    echo -e "${BOLD_YELLOW}Sorry, this script only works for Debian/Ubuntu${RESET}"
    exit 1
fi

# Check if this is an x86_64 system
ARCH=$(uname --machine)
case "${ARCH}" in
  x86_64)  ARCH_ALT="amd64";;
  aarch64) ARCH_ALT="arm64";;
  *)
    echo -e "${BOLD_YELLOW}Sorry, this script only works for x86_64 (amd64) and aarch64 (arm64)${RESET}"
    exit 1
esac

# Check if we're root
if [[ "${UID}" -ne 0 ]]; then
    echo -e "${BOLD_YELLOW}This script must be run as root, you trust me, right?${RESET}" >&2
    exit 1
fi

get_latest_github_release() {
    local REPO LATEST_VERSION
    REPO="$1"

    if [[ -z "${REPO}" ]]; then
        echo "Usage: get_latest_github_release <username/repository>" >&2
        return 1
    fi

    # Fetch the latest release using GitHub API
    LATEST_VERSION=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | jq -r '.tag_name')

    # Check if the API call was successful
    if [[ "${LATEST_VERSION}" == "null" || -z "${LATEST_VERSION}" ]]; then
        echo -e "${BOLD_RED}Error:${RESET} Could not fetch the latest release for ${REPO}" >&2
        return 1
    fi

    # Remove 'v' prefix if present
    echo "${LATEST_VERSION#v}"
    return 0
}

install_eza() {
    local VERSION TMPDIR
    VERSION="$1"

    if [[ -z "${VERSION}" ]]; then
        echo "Usage: install_eza <version>" >&2
        return 1
    fi

    if command -v eza &> /dev/null; then
        INSTALLED_VERSION=$(eza --version | sed -n 's/^v\([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/p')
        if [[ "${VERSION}" == "${INSTALLED_VERSION}" ]]; then
            echo -e "${YELLOW}Nothing to do${RESET}, the installed version of ${BG_BLUE}eza${RESET} is already ${BG_BLUE}${INSTALLED_VERSION}${RESET}"
            return 0
        fi
    fi

    echo -e "\nInstalling eza ${GREEN}v${VERSION}${RESET}"

    # Download and extract the files to a tmp directory
    TMPDIR=$(mktemp --directory)
    curl -s -L "https://github.com/eza-community/eza/releases/download/v${VERSION}/eza_${ARCH}-unknown-linux-gnu.tar.gz" | tar -C "${TMPDIR}" -zxf -
    curl -s -L "https://github.com/eza-community/eza/releases/download/v${VERSION}/completions-${VERSION}.tar.gz" | tar -C "${TMPDIR}" -zxf -
    curl -s -L "https://github.com/eza-community/eza/releases/download/v${VERSION}/man-${VERSION}.tar.gz" | tar -C "${TMPDIR}" -zxf -

    # Install the files
    echo -e "${GREY}"
    set -x
    install --mode=0755 --owner=root --group=root "${TMPDIR}/eza" /usr/local/bin/eza
    cp "${TMPDIR}/target/completions-${VERSION}/_eza" /usr/local/share/zsh/site-functions/_eza
    mkdir -p /usr/local/share/man/man1 /usr/local/share/man/man5
    cp "${TMPDIR}/target/man-${VERSION}/"*.1 /usr/local/share/man/man1/
    cp "${TMPDIR}/target/man-${VERSION}/"*.5 /usr/local/share/man/man5/
    rm -rf "${TMPDIR}"
    set +x
    echo -e "${RESET}"

    echo -e "Installed at: ${BG_BLUE}$(command -v eza)${RESET}"
    eza --version
}

install_fzf() {
    local VERSION TMPDIR
    VERSION="$1"

    if [[ -z "${VERSION}" ]]; then
        echo "Usage: install_fzf <version>" >&2
        return 1
    fi

    if command -v fzf &> /dev/null; then
        INSTALLED_VERSION=$(fzf --version | sed -n 's/^\([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/p')
        if [[ "${VERSION}" == "${INSTALLED_VERSION}" ]]; then
            echo -e "${YELLOW}Nothing to do${RESET}, the installed version of ${BG_BLUE}fzf${RESET} is already ${BG_BLUE}${INSTALLED_VERSION}${RESET}"
            return 0
        fi
    fi

    echo -e "\nInstalling fzf ${GREEN}v${VERSION}${RESET}"

    # Download and extract the file to a tmp directory
    TMPDIR=$(mktemp --directory)
    curl -s -L "https://github.com/junegunn/fzf/releases/download/v${VERSION}/fzf-${VERSION}-linux_${ARCH_ALT}.tar.gz" | tar -C "${TMPDIR}" -zxf -

    # Install the file
    echo -e "${GREY}"
    set -x
    install --mode=0755 --owner=root --group=root "${TMPDIR}/fzf" /usr/local/bin/fzf
    rm -rf "${TMPDIR}"
    set +x
    echo -e "${RESET}"

    echo -e "Installed at: ${BG_BLUE}$(command -v fzf)${RESET}"
    fzf --version
}

install_bat() {
    local VERSION TMPDIR
    VERSION="$1"

    if [[ -z "${VERSION}" ]]; then
        echo "Usage: install_bat <version>" >&2
        return 1
    fi

    if command -v bat &> /dev/null; then
        INSTALLED_VERSION=$(bat --version | sed -n 's/^bat \([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/p')
        if [[ "${VERSION}" == "${INSTALLED_VERSION}" ]]; then
            echo -e "${YELLOW}Nothing to do${RESET}, the installed version of ${BG_BLUE}bat${RESET} is already ${BG_BLUE}${INSTALLED_VERSION}${RESET}"
            return 0
        fi
    fi

    echo -e "\nInstalling bat ${GREEN}v${VERSION}${RESET}"

    # Download and extract the file to a tmp directory
    TMPDIR=$(mktemp --directory)
    curl -s -L "https://github.com/sharkdp/bat/releases/download/v${VERSION}/bat_${VERSION}_${ARCH_ALT}.deb" > "${TMPDIR}/bat_${VERSION}_${ARCH_ALT}.deb"

    # Install the package
    echo -e "${GREY}"
    set -x
    dpkg --install "${TMPDIR}/bat_${VERSION}_${ARCH_ALT}.deb"
    rm -rf "${TMPDIR}"
    set +x
    echo -e "${RESET}"

    echo -e "Installed at: ${BG_BLUE}$(command -v bat)${RESET}"
    bat --version
}

install_eza "$(get_latest_github_release eza-community/eza)"
install_fzf "$(get_latest_github_release junegunn/fzf)"
install_bat "$(get_latest_github_release sharkdp/bat)"
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh

echo -e "\n✅ ${GREEN}All programs were installed successfully!${RESET} 🚀"
