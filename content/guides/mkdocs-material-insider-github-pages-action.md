---
description: Guide to deploy a static site using Material for MkDocs Insiders on GitHub Pages using uv and GitHub Actions
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

This guide assumes that you have already installed [uv](https://docs.astral.sh/uv/), made a GitHub repo and cloned it to your local system. For the Insiders version you will need to be able to [clone repos with HTTPS URLs](https://docs.github.com/en/get-started/git-basics/about-remote-repositories#cloning-with-https-urls), some IDEs like [VS Code](https://code.visualstudio.com/) handle it for you automatically.

If you are on macOS, check out my guide on [macOS Setup](macos-setup.md) to get your development environment up and running.

### Project Setup

``` yaml title="pyproject.toml"
[project]
name = "website"
version = "0.1.0"
requires-python = ">=3.12"
dependencies = [
    "mkdocs-material[imaging]",
    "mkdocs-minify-plugin>=0.8.0",
]

[tool.uv.sources]
mkdocs-material = { git = "https://github.com/squidfunk/mkdocs-material-insiders" }

```

### Build Your Site

There are a lot of great guides out there on building a site with MkDocs so I won't get into it. Feel free to check out my repo on GitHub to see how I have this site setup: <https://github.com/aceat64/website>

Since `mkdocs` was installed via `uv`, you'll need to call it with `uv run mkdocs`. For example, to run the development server:

``` shell
poetry run mkdocs serve
```

### GitHub Pages

If you haven't already, go into the settings for you GitHub repo and enable Pages. Under "Build and deployment" you'll want to select "GitHub Actions" as the source.

### GitHub Actions

All that's left now is to configure a workflow to build and publish the site. Place the following file in your repo, commit your changes, push to GitHub and sit back!

``` yaml title=".github/workflows/pages.yaml"
name: Pages
on:
  push:
    branches:
      - main
  # workflow_dispatch allows the site to be rebuilt and published manually if needed
  workflow_dispatch:

# Grant GITHUB_TOKEN the permissions required to make a Pages deployment
permissions:
  pages: write # to deploy to Pages
  id-token: write # to verify the deployment originates from an appropriate source

# Prevent the action from running multiple times in parallel
concurrency: pages-build-and-deploy

jobs:
  build:
    runs-on: ubuntu-latest
    # Running this action on a fork will likely fail anyway
    # unless the forked repo also has access to material for mkdocs insiders
    if: github.event.repository.fork == false

    steps:
      - uses: actions/checkout@v4

      - name: Install dependencies
        run: sudo apt-get install pngquant

      - uses: actions/setup-python@v5
        with:
          python-version-file: 'pyproject.toml'

      - uses: astral-sh/setup-uv@v5

      # Insiders is the sponsorware version of Material for MkDocs
      # https://squidfunk.github.io/mkdocs-material/insiders/
      - name: Configure auth for Insiders
        run: |
          echo "https://github:${{ secrets.GH_TOKEN }}@github.com" >> $HOME/.git-credentials
          git config --global credential.helper store

      - name: Install the project
        run: uv sync --all-extras --dev

      # The .cache directory is used for 3rd party assets, as part of the privacy plugin.
      # It is also used to cache the generated social media cards.
      # Persisting the cache across builds dramatically speeds up the process.
      - name: Load site cache
        uses: actions/cache@v4
        with:
          key: mkdocs
          path: .cache

      - name: Build site
        run: uv run mkdocs build

      # Upload the built site as an artifact, this will be used by the deploy job.
      - uses: actions/upload-pages-artifact@v3
        with:
          path: "site"

      - name: Minimize uv cache
        run: uv cache prune --ci
  deploy:
    needs: build

    # Deploy to the github-pages environment
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}

    # Specify runner + deployment step
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```
