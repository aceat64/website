# About The Site

This is my personal website, so all opinions are my own. I made it to better document some of the helpful information I've compiled about a wide variety of topics, but also to show off some of the projects I've done that I think are neat.

## Development

Note: Since I use the Insiders version of Material for MkDocs, you will not able to run this locally unless you are also a sponsor of the project.

Requires [Poetry](https://python-poetry.org/), Python 3.11 or higher and a GitHub personal access token (`$GH_TOKEN`). I recommend using `pyenv` to install Python.

### Configure access to Insiders

```shell
poetry config repositories.github-squidfunk-mkdocs https://github.com/squidfunk/mkdocs-material-insiders.git
poetry config http-basic.github-squidfunk-mkdocs username $GH_TOKEN
```

### Dev Server

```shell
poetry run mkdocs serve
```

### Build Site

```shell
poetry run mkdocs build
```

## Copyright

Copyright (c) 2023 Andrew LeCody

This work is licensed under a Creative Commons Attribution 4.0 International License.

You should have received a copy of the license along with this
work. If not, see <http://creativecommons.org/licenses/by/4.0/>.
