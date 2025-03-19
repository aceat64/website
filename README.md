# About The Site

This is my personal website, so all opinions are my own. I made it to better document some of the helpful information I've compiled about a wide variety of topics, but also to show off some of the projects I've done that I think are neat.

## Development

Note: Since I use the Insiders version of Material for MkDocs, you will not able to run this locally unless you are also a sponsor of the project.

I've completely switched to using [uv](https://docs.astral.sh/uv/getting-started/installation/) for managing dependencies, virtual environments and Python versions.

### Dev Server

```shell
uv run mkdocs serve
```

### Build Site

```shell
uv run mkdocs build
```

### Troubleshooting

On my mac, I needed install cairo (`brew install cairo`) and add the following to `~/.zshrc`:

```shell
# Needed to let python know where some libs are
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
export DYLD_LIBRARY_PATH="/usr/local/lib:/opt/homebrew/lib:$DYLD_LIBRARY_PATH"
```

## Copyright

Copyright (c) 2022-2025 Andrew LeCody

This work is licensed under a Creative Commons Attribution 4.0 International License.

You should have received a copy of the license along with this work. If not, see <http://creativecommons.org/licenses/by/4.0/>.
