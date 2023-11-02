---
description: My personal setup on macOS for development work.
---

# macOS Setup

Originally I wrote this guide to remind myself how to setup my M1 Macbook the way I like it. A few friends and coworkers expressed interest in my setup, so I cleaned up the notes (a bit) and created this guide. You don't need to follow this guide completely, I encourage you to pick-and-choose the pieces you want to use and to tweak things to fit your needs. I also love to see how other people have setup their systems, so please share your configs!

## Recommended Software

Download and install these following the instructions on their websites:

- [iTerm2](https://iterm2.com/downloads.html)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Homebrew](https://brew.sh/)

## Command Line Tools

### Btop++

TUI resource monitoring. C++ version and continuation of [bashtop](https://github.com/aristocratos/bashtop) and [bpytop](https://github.com/aristocratos/bpytop).

```shell
brew install btop
```

_<https://github.com/aristocratos/btop>_

---

### Mosh

Better SSH for high latency or unreliable connections.

```shell
brew install mosh
```

_<https://mosh.org/>_

---

### mtr (traceroute)

TUI traceroute utility.

```shell
brew install mtr
```

_<https://github.com/traviscross/mtr>_

---

### nano

A small and friendly editor. As of macOS 12.3 nano was replaced with a symlink to pico. :angry:

```shell
brew install nano
```

_<https://www.nano-editor.org/>_

---

### Nmap

Network scanner.

```shell
brew install nmap
```

_<https://nmap.org/>_

---

### jq

Command line JSON parser.

```shell
brew install jq
```

_<https://stedolan.github.io/jq/>_

---

### fq

Like JQ but for binary formats.

```shell
brew install wader/tap/fq
```

_<https://github.com/wader/fq>_

---

### bat

A cat(1) clone with syntax highlighting and Git integration.

```shell
brew install bat
brew install eth-p/software/bat-extras
```

While it's optional, I recommend installing the [bat-extras](https://github.com/eth-p/bat-extras), it's a collection of bash scripts that integrate `bat` with various command line tools.

To easily format help output from a command, I put the following alias and function in my `~/.zshrc` file:

```shell title="~/.zshrc"
alias bathelp='bat --plain --language=help'
help() {
    "$@" --help 2>&1 | bathelp
}
```

_<https://github.com/sharkdp/bat>_

---

### fd

A simple, fast and user-friendly alternative to `find`

```shell
brew install fd
```

_<https://github.com/sharkdp/fd>_

---

## Vim Plugins

vim-plug: Minimalist Vim Plugin Manager.

```shell
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

??? example "~/.vimrc"

    ``` vim
    call plug#begin()
    " The default plugin directory will be as follows:
    "   - Vim (Linux/macOS): '~/.vim/plugged'
    "   - Vim (Windows): '~/vimfiles/plugged'
    "   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
    " You can specify a custom plugin directory by passing it as the argument
    "   - e.g. `call plug#begin('~/.vim/plugged')`
    "   - Avoid using standard Vim directory names like 'plugin'

    " Make sure you use single quotes
    Plug 'tpope/vim-sensible'

    " Uncomment to enable catppuccin theme
    " Plug 'catppuccin/vim', { 'as': 'catppuccin' }

    " Initialize plugin system
    " - Automatically executes `filetype plugin indent on` and `syntax enable`.
    call plug#end()
    " You can revert the settings after the call like so:
    "   filetype indent off   " Disable file-type-specific indentation
    "   syntax off            " Disable syntax highlighting

    set termguicolors
    colorscheme catppuccin_mocha
    ```

    Afterwards you'll need to run `:PlugInstall` from within vim.

_<https://github.com/junegunn/vim-plug>_

---

## Version Managers

There are helpful tools to install and run multiple versions of various programming languages.

### Python (pyenv)

```shell
brew install pyenv
```

_<https://github.com/pyenv/pyenv>_

---

### NodeJS (nvm)

Once the install completes, be sure to follow the instructions provided and add the required lines to your ~/.zhsrc file.

```shell
brew install nvm
```

_<https://github.com/nvm-sh/nvm>_

---

### Terraform (tfenv)

```shell
brew install tfenv
```

_<https://github.com/tfutils/tfenv>_

## Developer Tools

### PostgreSQL

Database software.

```shell
brew install postgresql
```

_<https://www.postgresql.org/>_

---

### Lefthook

Git hooks manager, useful for development.

```shell
brew install lefthook
```

_<https://github.com/evilmartians/lefthook>_

---

### Poetry

A Python dependency manager and packaging tool.

```shell
curl -sSL https://install.python-poetry.org | python3 -
```

If you chose to install `pyenv`, I suggest enabling this option so that Poetry will default to the active/global version of Python:

``` shell
poetry config virtualenvs.prefer-active-python true
```

_<https://python-poetry.org/>_

---

### git-delta

A syntax-highlighting pager for git, diff, and grep output.

```shell
brew install git-delta
```

Update your `~/.gitconfig` file:

```toml title="~/.gitconfig"
[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only
[add.interactive]
    useBuiltin = false # required for git 2.37.0

[delta]
    navigate = true    # use n and N to move between diff sections
    light = false      # set to true if you're in a terminal w/ a light background color (e.g. the default macOS terminal)

[merge]
    conflictstyle = diff3

[diff]
    colorMoved = default
```

_<https://github.com/dandavison/delta>_

---

### Prettier

Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML.

```shell
brew install prettier
```

_<https://prettier.io/>_

---

### hadolint

 Dockerfile linter, validate inline bash, written in Haskell.

```shell
brew install hadolint
```

_<https://github.com/hadolint/hadolint>_

---

### dive

 A tool for exploring each layer in a docker image.

```shell
brew install dive
```

_<https://github.com/wagoodman/dive>_

---

## Kubernetes Tools

### kubectl

Basic Kubernetes command line tools, such as kubectl.

```shell
brew install kubernetes-cli
```

_<https://kubernetes.io/>_

---

### krew

Krew is the plugin manager for kubectl command-line tool.

Follow the install instructions: <https://krew.sigs.k8s.io/docs/user-guide/setup/install/>

The list of available plugins can be found here: <https://krew.sigs.k8s.io/plugins/>

#### Plugins

**get-all**: Like `kubectl get all` but _really_ everything

```shell
kubectl krew install get-all
```

---

### kubectx

Switch between Kubernetes contexts faster and easier.

```shell
brew install kubectx
```

_<https://github.com/ahmetb/kubectx>_

---

### Helm

Kubernetes package manager.

```shell
brew install helm
```

_<https://helm.sh/>_

---

### k9s

TUI for Kubernetes.

```shell
brew install derailed/k9s/k9s
```

_<https://k9scli.io/>_

## Fonts

```shell
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font font-meslo-lg-nerd-font font-ubuntu-mono-nerd-font
```

## ZSH Setup

### Features

<div class="grid cards" markdown>

- [Oh My ZSH](https://ohmyz.sh/)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [terminal-notifier](https://github.com/julienXX/terminal-notifier)
- [autoupdate](https://github.com/TamCore/autoupdate-oh-my-zsh-plugins)
- [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting)
- [Powerlevel10k Theme](https://github.com/romkatv/powerlevel10k)

</div>

![https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/prompt-styles-high-contrast.png](https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/prompt-styles-high-contrast.png)

### Step-By-Step Instructions

1. Install Oh My ZSH:

    ```shell
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```

2. Restart iTerm
3. Install powerlevel10k:

    ```shell
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    ```

4. Edit `~/.zshrc`, set `ZSH_THEME="powerlevel10k/powerlevel10k"`
5. Restart iTerm
6. Follow setup directions from p10k
7. Install terminal-notifier, required for the `bgnotify` Oh My ZSH plugin:

    ```shell
    brew install terminal-notifier
    ```

8. Install zsh-autosuggestions:

    ```shell
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    ```

9. Install autoupdate:

    ```shell
    git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $ZSH_CUSTOM/plugins/autoupdate
    ```

10. Install fast-syntax-highlighting:

    ```shell
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
     ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
    ```

11. Edit `~/.zshrc`

    1. Add the following lines to the end of the file:

        ```shell
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
        bgnotify_threshold=30
        ```

    2. Edit the `plugins` setting:

        ```shell
        plugins=(
            autoupdate
            aws
            bgnotify
            fast-syntax-highlighting
            macos
            terraform
            safe-paste
            zsh-autosuggestions
        )
        ```

12. Install fzf for better history searching (ctrl-r):

    ```shell
    brew install fzf

    # To install useful key bindings and fuzzy completion:
    $(brew --prefix)/opt/fzf/install
    ```

### Optional: VS Code Settings

VS Code users will need to add the following to their `settings.json`:

```json
"terminal.external.osxExec": "iTerm.app",
"terminal.integrated.defaultProfile.osx": "zsh",
"terminal.integrated.fontFamily": "MesloLGS Nerd Font Mono"
```
