# Dotfiles Setup 

This repo uses GNU Stow to symlink config files into your home directory (`~`) instead of copying them.
---

## 1. Install Stow

* macOS:
  ```
  brew install stow
  ```
* Linux:
  ```
  sudo apt install stow
  ```
---

## 2. Clone the repo
```
git clone https://github.com/Toha764/dotfiles ~/dotfiles
cd ~/dotfiles
```
---

## 3. Apply configs

  `stow -d <parent directory> -t ~ <package name or * for all> `
### OS-specific configs

* macOS:

  ```
  stow -d ~/dotfiles/os/mac -t ~ *
  ```

* Linux:

  ```
  stow -d ~/dotfiles/os/linux -t ~ *
  ```

Or install just one:

```
stow -d ~/dotfiles/os/mac -t ~ zsh
```

---

### Shared configs (packages)

Example:

```
stow -d ~/dotfiles/packages -t ~ tmux
```

---

Stow creates symlinks in `~` pointing to files in this repo.

---

## Useful commands

* Reapply a package:

  ```
  stow -R tmux
  ```

* Remove a package:

  ```
  stow -D tmux
  ```

---
