#!/bin/bash
git clone --bare https://github.com/lachlan443/dotfiles.git $HOME/.dotfiles
function config {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
}
mkdir -p .config-backup
config config --local status.showUntrackedFiles no

# Force checkout and overwrite existing files
config checkout -f .  # This will force overwrite any conflicting files

echo "Dotfiles install complete."