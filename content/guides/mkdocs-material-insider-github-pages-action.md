---
description: Guide to deploy a static site using Material for MkDocs Insiders on GitHub Pages using Poetry and GitHub Actions
hide:
    - toc
---

# Deploy Material for MkDocs Insiders Using GitHub Actions

This site is built using [Material for MkDocs Insiders](https://squidfunk.github.io/mkdocs-material/insiders/), the sponsorware version of Material for MkDocs, which includes a number of features not in the publically available version. Notable features used by this site are:

* [Blog plugin](https://squidfunk.github.io/mkdocs-material/setup/setting-up-a-blog/)
* [Privacy plugin](https://squidfunk.github.io/mkdocs-material/setup/ensuring-data-privacy/#built-in-privacy-plugin)
* [Grid cards](https://squidfunk.github.io/mkdocs-material/reference/grids/#using-card-grids)
* [Automatic light / dark mode](https://squidfunk.github.io/mkdocs-material/setup/changing-the-colors/#automatic-light-dark-mode)
* [Rich search previews](https://squidfunk.github.io/mkdocs-material/blog/2021/09/13/search-better-faster-smaller/#rich-search-previews)

## Getting Started

You will need Python 3.10 (I strongly recommend using [pyenv](https://github.com/pyenv/pyenv)), [Poetry](https://python-poetry.org/) and a GitHub repository. If you are on macOS, check out my guide on [macOS Setup](/guides/macos-setup) to get your development environment up and running.

### Poetry Init

First you need to create a `pyproject.toml` file, which will define the packages uses for building the site. This can be done interactively by running `poetry init` in the base folder of your repo.

``` shell
poetry init
```

The output should look something like below. Don't define your dependencies interactively, you'll setup a GitHub token in later steps which will let us access the Insiders repo. For the rest of the prompts, the defaults are typically good enough.

``` shell
$ poetry init

This command will guide you through creating your pyproject.toml config.

Package name [website-test]:  
Version [0.1.0]:  
Description []:  
Author [Andrew LeCody <andrewlecody@gmail.com>, n to skip]:  
License []:  
Compatible Python versions [^3.10]:  

Would you like to define your main dependencies interactively? (yes/no) [yes] no
Would you like to define your development dependencies interactively? (yes/no) [yes] no
Generated file

[tool.poetry]
name = "website-test"
version = "0.1.0"
description = ""
authors = ["Andrew LeCody <andrewlecody@gmail.com>"]
readme = "README.md"
packages = [{include = "website_test"}]

[tool.poetry.dependencies]
python = "^3.10"


[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"


Do you confirm generation? (yes/no) [yes]
```

### GitHub Token

You need to create a Personal Access Token and set it as the environment variable `$GH_TOKEN`.

1. Go to <https://github.com/settings/tokens>
2. Click on "Generate a new token" in the top right.
3. Enter a name for your token and set the expiration. You'll have to generate a new token once this one expires.
4. Select just the `repo` scope.
5. Generate the token, on the next page you need to copy the token (it should start with `ghp_`).
6. Edit the settings file for your shell (`~/.bashrc` or `~/.zshrc`)

    ``` shell
    export GH_TOKEN="paste_token_here"
    ```

7. Reload your shell (or just run that `export` command) so that the `$GH_TOKEN` environment variable is active.
8. You can verify the variable is loaded by running `echo $GH_TOKEN`, if your token appears, you are ready to continue.

### Configure Poetry

Poetry needs to be told how to access the Insiders repo, using the GitHub token you generated.

```shell
poetry config repositories.github-squidfunk-mkdocs https://github.com/squidfunk/mkdocs-material-insiders.git
poetry config http-basic.github-squidfunk-mkdocs username $GH_TOKEN
```

Now you are ready to install Material for MkDocs Insiders.

``` shell
poetry add git+https://github.com/squidfunk/mkdocs-material-insiders.git
```

This is optional, but I install some additional packages. I use the minify plugin to shrink the built HTML files, while Pillow and CairoSVG are needed for the social media cards.

``` shell
poetry add mkdocs-minify-plugin Pillow CairoSVG
```

### Build Your Site

There are a lot of great guides out there on building a site with MkDocs so I won't get into it. Feel free to check out my repo on GitHub to see how I have this site setup: <https://github.com/aceat64/website>

Since mkdocs was installed via Poetry, you'll need to call it with `poetry run mkdocs`. For example, to run the development server:

``` shell
poetry run mkdocs serve
```

### GitHub Pages

If you haven't already, go into the settings for you GitHub repo and enable Pages. Under "Build and deployment" you'll want to select "GitHub Actions" as the source.

### GitHub Actions

All that's left now is to configure a workflow to build and publish the site. Place the following file in your repo, commit your changes, push to GitHub and sit back!

``` yaml title=".github/workflows/pages.yaml"
--8<-- ".github/workflows/pages.yaml"
```
