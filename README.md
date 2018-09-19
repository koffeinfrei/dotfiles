# .files

## Prerequisites

* Git
* Ruby (use rbenv or something similar to install)
* Rake (`gem install rake`)

## Install


```bash
# 1. Clone the repository (not in your home directory!)

$ git clone git@github.com:koffeinfrei/dotfiles.git

# 2. Create symlinks to the dotfiles

$ rake install

# 3. Optional: Sets up the vim plugin manager (Plug)

$ rake vim

# 4. Optional: Creates a symlink for neovim as vim

$ rake neovim
```

## Uninstall

```bash
$ rake uninstall
```
