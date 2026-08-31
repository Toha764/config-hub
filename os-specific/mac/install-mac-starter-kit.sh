#!/usr/bin/env bash
set -e

echo "---- Ensuring Xcode Command Line Tools ----"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
fi

echo "---- Installing Homebrew (if missing) ----"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update

echo "---- Installing CLI developer stack ----"
brew install \
  bat \
  btop \
  chafa \
  docker \
  exiftool \
  eza \
  fastfetch \
  fd \
  ffmpegthumbnailer \
  fzf \
  gh \
  go \
  jq \
  lazydocker \
  lazygit \
  mackup \
  neovim \
  node \
  pet \
  poppler \
  python \
  ripgrep \
  stow \
  tlrc \
  tmux \
  wget \
  yazi \
  zoxide

echo "---- Installing GUI applications ----"
brew install --cask \
  docker \
  font-jetbrains-mono-nerd-font \
  ghostty \
  karabiner-elements \
  raycast \
  zed \
  zen-browser

echo "---- Installing Oh My Zsh ----"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "---- Cleanup ----"
brew autoremove
brew cleanup

echo "✔ Setup complete"

