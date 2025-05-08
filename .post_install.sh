#!/bin/bash

PACKAGE_FILE=".additional_packages.txt"

# Check if package list file exists
if [[ ! -f "$PACKAGE_FILE" ]]; then
  echo "❌ Package list file '$PACKAGE_FILE' not found!"
  exit 1
fi

echo "🔄 Updating package database..."
sudo pacman -Sy

echo "📦 Reading package list from $PACKAGE_FILE..."

# Filter comments
mapfile -t packages < <(grep -vE '^\s*#|^\s*$' "$PACKAGE_FILE" | sed 's/#.*//' | xargs -n1)

echo "📥 Installing packages: ${packages[*]}"
sudo pacman -S --needed --noconfirm "${packages[@]}"

# Ensure screenshots folder exists
echo "🔧 Creating Screenshots directory"
mkdir -p ~/Pictures/Screenshots


echo "✅ Complete."