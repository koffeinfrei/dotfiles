<div align="center">

![Dotfiles logo](logo.svg)

</div>
<h1 align="center">dotfiles</h1>


## Prerequisites

* Git
* Ruby (use rbenv or something similar to install)
* Rake (`gem install rake`)

## Install

1. Clone the repository. **Don't do this in the home directory!**

    ```bash
    $ cd ~/src # cd to the project directoy
    $ git clone --recurse-submodules git@github.com:koffeinfrei/dotfiles.git
    ```

    Alternativerly clone and then recursively update the submodules

    ```bash
    $ git clone git@github.com:koffeinfrei/dotfiles.git
    $ git submodule update --init --recursive
    ```

1. Install the dotfiles

    ```bash
    $ rake
    ```

    The default task executes the following tasks, each of which can also be run separately.

    1. Install the required packages (debian based, i.e. `apt` package manager)

        ```bash
        $ rake packages
        ```

    1. Create symlinks to the dotfiles

        ```bash
        $ rake install
        ```

    1. Optional: Sets up the vim plugin manager (Plug)

        ```bash
        $ rake vim
        ```

    1. Optional: Creates a symlink for neovim as vim

        ```bash
        $ rake neovim
        ```

## Uninstall

```bash
$ rake uninstall
```

<br>

Made with ☕️  by [Koffeinfrei](https://github.com/koffeinfrei)
