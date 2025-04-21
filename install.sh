#!/bin/bash

set -e  # Stoppe bei Fehlern

echo "🔧 Starte Terminal-Setup..."

# ─── Update & Grundpakete ────────────────────────────────
echo "📦 Installiere benötigte Pakete..."
sudo apt update
sudo apt install -y zsh git curl wget lsd neofetch bat htop

# ─── Zsh als Standard-Shell setzen ───────────────────────
echo "🐚 Setze Zsh als Standard-Shell..."
chsh -s $(which zsh)

# ─── Oh My Zsh installieren ──────────────────────────────
echo "📥 Installiere Oh My Zsh..."
export RUNZSH=no
export CHSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ─── Powerlevel10k installieren ──────────────────────────
echo "🎨 Installiere Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# ─── Dotfiles kopieren ───────────────────────────────────
echo "📁 Kopiere Konfigurationsdateien..."
cp .zshrc ~/.zshrc
cp .p10k.zsh ~/.p10k.zsh
cp .aliases ~/.aliases

# ─── Nerd Font Hinweis ───────────────────────────────────
echo "🔤 Bitte stelle sicher, dass du eine NerdFont wie 'FiraCode Nerd Font Mono' im Terminal verwendest."

# ─── Fertig ──────────────────────────────────────────────
echo "✅ Setup abgeschlossen. Starte dein Terminal neu oder gib 'exec zsh' ein."

