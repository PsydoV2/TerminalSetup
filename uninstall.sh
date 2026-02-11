#!/bin/bash

# Disable 'exit on error' to ensure the script continues even if files are missing
set +e 

echo "🔧 Reversing terminal setup and restoring defaults..."

# ─── 1. Reset Default Shell ──────────────────────────────
echo "🐚 Changing shell back to Bash..."
# Using sudo to ensure the shell change is registered correctly
sudo chsh -s $(which bash) $USER

# ─── 2. Remove Oh My Zsh & Extensions ────────────────────
echo "🧹 Removing Oh My Zsh, themes, and plugins..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    rm -rf "$HOME/.oh-my-zsh"
fi

# ─── 3. Delete Configuration Files ───────────────────────
echo "📁 Deleting dotfiles and config folders..."
rm -f "$HOME/.zshrc"
rm -f "$HOME/.p10k.zsh"
rm -f "$HOME/.aliases"
rm -f "$HOME/.vimrc"
rm -rf "$HOME/.config/nvim"

# ─── 4. Uninstall Packages ───────────────────────────────
echo "📦 Uninstalling packages and cleaning up dependencies..."
# 'purge' removes the packages and their system-wide configuration files
sudo apt purge -y zsh lsd neofetch bat htop neovim
sudo apt autoremove -y

# ─── 5. Finalize ─────────────────────────────────────────
echo "✨ Cleanup complete!"
echo "⚠️  IMPORTANT: Please log out and log back in (or restart WSL) for the shell change to take effect."
echo "🚀 Your terminal environment has been restored to default."