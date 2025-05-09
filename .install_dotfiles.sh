#!/bin/bash
git clone --bare https://github.com/lachlan443/dotfiles.git $HOME/.dotfiles
function config {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
}
config config --local status.showUntrackedFiles no
config checkout -f # Force checkout and overwrite existing files
echo "Dotfiles install complete."