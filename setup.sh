#!/usr/bin/env bash

# backup system .bashrc
if [ -f "$HOME/.bashrc" ] && [ ! -L "$HOME/.bashrc" ]; then
  mv -v "$HOME/.bashrc" "$HOME/.bashrc_default"
fi

if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
  mv -v "$HOME/.zshrc" "$HOME/.zshrc_default"
fi

# link dotfiles (skip .git directory and setup.sh; handle .cargo/config separately; dont copy README)
for file in "$HOME/dotfiles/".*  "$HOME/dotfiles/"*; do
  file="$(basename "$file")"

  if [ "$file" = ".git" ] || [ "$file" = "setup.sh" ] || [ "$file" = ".cargo" ] || [ "$file" = "README.md" ] || [ "$file" = "lint.sh" ]; then
    continue
  fi

  if [ ! -e "$HOME/$file" ]; then
    ln -sv "$HOME/dotfiles/$file" "$HOME"
  fi
done

if [ ! -L "$HOME/.cargo/config" ]; then
  if [ ! -d "$HOME/.cargo" ]; then
    mkdir "$HOME/.cargo"
  fi

  ln -sv "$HOME/.cargo/config" "$HOME/.cargo/"
fi

# TO RUN:
# git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
