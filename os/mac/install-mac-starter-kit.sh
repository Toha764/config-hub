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
docker \
go \
node \
python \
neovim \
yazi \
bat \
btop \
tldr \
lsd \
ffmpegthumbnailer \
poppler \
chafa \
mediainfo \
exiftool

echo "---- Installing GUI applications ----"
brew install --cask \
ghostty \
raycast \
zed \
zen-browser \
docker

echo "---- Installing Oh My Zsh ----"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "---- Cleanup ----"
brew autoremove
brew cleanup

echo "✔ Setup complete"

