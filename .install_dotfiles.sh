#!/bin/bash
git clone --bare https://github.com/lachlan443/dotfiles.git $HOME/.dotfiles
function config {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
}
mkdir -p .config-backup
config config --local status.showUntrackedFiles no
config checkout # Attempt to check out the dotfiles
if [ $? -ne 0 ]; then # If checkout fails, handle conflicts
  echo ""
  echo "⚠️  Some files would be overwritten by checkout:"
  conflicted_files=$(config checkout 2>&1 | grep -E "^\s+\." | awk '{print $1}')
#  echo "$conflicted_files"
  echo ""
  
  read -p "Do you want to OVERRIDE these files? [Y/n] " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "Deleting conflicting files..."
    while IFS= read -r file; do
      rm -rf "$HOME/$file"
    done <<< "$conflicted_files"
  else
    echo "Aborting setup. No files were deleted."
    exit 1
  fi
fi
while ! config checkout; do # Try checkout again
  echo ""
  echo "❗ Some files are still blocking checkout."
  read -p "Have you deleted the remaining files manually? Retry? [y/N] " retry
  [[ "$retry" =~ ^[Yy]$ ]] || { echo "Aborting."; exit 1; }
done
echo "Dotfiles setup complete."