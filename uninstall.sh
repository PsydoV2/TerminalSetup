#!/bin/bash

# Disable 'exit on error' to ensure the script continues even if files are missing
set +e

echo "🔧 Reversing terminal setup and restoring defaults..."

# ─── 1. Reset Default Shell ──────────────────────────────
echo "🐚 Changing shell back to Bash..."
sudo chsh -s $(which bash) $USER

# ─── 2. Remove Oh My Zsh & Extensions ────────────────────
echo "🧹 Removing Oh My Zsh, themes, and plugins..."
if [ -d "$HOME/.oh-my-zsh" ]; then
  rm -rf "$HOME/.oh-my-zsh"
fi

# ─── 3. Delete Configuration Files ───────────────────────
echo "📁 Deleting dotfiles..."
rm -f "$HOME/.zshrc"
rm -f "$HOME/.p10k.zsh"
rm -f "$HOME/.aliases"
rm -f "$HOME/.vimrc"

# ─── 4. Remove Neovim Config (with backup) ───────────────
if [ -d "$HOME/.config/nvim" ]; then
  BACKUP="$HOME/.config/nvim_backup_$(date +%Y%m%d_%H%M%S)"
  echo "⚠️  Backing up ~/.config/nvim to $BACKUP before deletion..."
  mv "$HOME/.config/nvim" "$BACKUP"
  echo "   Backup saved. Remove it manually with: rm -rf $BACKUP"
fi

# ─── 5. Uninstall Packages ───────────────────────────────
echo "📦 Uninstalling packages and cleaning up dependencies..."
# Note: git, curl, wget are intentionally kept as they are general system tools.
# 'purge' removes packages and their system-wide configuration files.
sudo apt purge -y zsh lsd neofetch bat htop neovim
sudo apt autoremove -y

# ─── 6. Finalize ─────────────────────────────────────────
echo "✨ Cleanup complete!"
echo "⚠️  IMPORTANT: Please log out and log back in (or restart WSL) for the shell change to take effect."
echo "🚀 Your terminal environment has been restored to default."
