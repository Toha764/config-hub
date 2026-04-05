# Installation Guide

### Stow

Packages are managed by `stow`. Which allows you to neatly organize your files in a directory structure and then create symbolic links to the appropriate locations in your home directory or system directories.

Files are structured for os compatibility in mind. Everything in `packages` and `dotfiles/` is compatible with both os.

1. clone the repository
2. Install `stow`
3. For OS specific Configs:
   Mac:
   All configs at once- `stow -d ~/dotfiles/os/mac -t ~ *`
   Specific config- ie. `stow -d ~/dotfiles/os/mac -t ~ zsh`
   Linux:
   All configs at once- `stow -d ~/dotfiles/os/linux -t ~ *`
   Specific config- ie.`stow -d ~/dotfiles/os/linux -t ~ zsh`
4. For Shared Packages: ie. `stow -d ~/dotfiles/packages -t ~ tmux`

> `stow` command doesn't take / (slashes) and they only work at package level, so you have to use -d flag.

### Quick Example of Stow

When you do `stow zsh`. It creates a symlink (a shortcut) in your home directory (~) pointing to the file in this repo aka `~dotfiles`. In `zsh/` contains `.zshrc` so a shortcut will be created in the home directory named -`.zshrc`, if the file strcuture were `zsh/.config/.zshrc` then symlink would be created inside `~/.config` instead (assuming it exists) of home directory.

Learn more on how [stow](https://linuxvox.com/blog/stow-linux/) works.
