#!/bin/bash

set -e

# Always resolve paths relative to this script, regardless of where it's called from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔧 Starting terminal setup..."

# ─── Component Selection ──────────────────────────────────
INSTALL_NEOVIM=true
INSTALL_LSD=true
INSTALL_BAT=true
INSTALL_NEOFETCH=true
INSTALL_HTOP=true
INSTALL_P10K=true
INSTALL_AUTOSUGG=true
INSTALL_SYNTHIGH=true

if command -v whiptail &>/dev/null; then
  CHOICES=$(whiptail --title "Terminal Setup" \
    --checklist "Select components to install:\n(SPACE to toggle, ENTER to confirm)" \
    20 62 8 \
    "neovim"   "Neovim (PPA, 0.9+) + Lua config"      ON \
    "lsd"      "lsd     – modern 'ls' with icons"      ON \
    "bat"      "bat     – modern 'cat' with syntax hl" ON \
    "neofetch" "neofetch – system info on startup"     ON \
    "htop"     "htop    – interactive process viewer"  ON \
    "p10k"     "Powerlevel10k theme"                   ON \
    "autosugg" "zsh-autosuggestions plugin"            ON \
    "synthigh" "zsh-syntax-highlighting plugin"        ON \
    3>&1 1>&2 2>&3) || { echo "Cancelled."; exit 0; }

  # whiptail output varies between systems (quoted or unquoted) — match without quotes
  [[ "$CHOICES" != *neovim*   ]] && INSTALL_NEOVIM=false
  [[ "$CHOICES" != *lsd*      ]] && INSTALL_LSD=false
  [[ "$CHOICES" != *bat*      ]] && INSTALL_BAT=false
  [[ "$CHOICES" != *neofetch* ]] && INSTALL_NEOFETCH=false
  [[ "$CHOICES" != *htop*     ]] && INSTALL_HTOP=false
  [[ "$CHOICES" != *p10k*     ]] && INSTALL_P10K=false
  [[ "$CHOICES" != *autosugg* ]] && INSTALL_AUTOSUGG=false
  [[ "$CHOICES" != *synthigh* ]] && INSTALL_SYNTHIGH=false
else
  # Fallback: individual y/n prompts
  echo ""
  echo "Select components to install (Enter = yes, n = skip):"
  ask() { read -rp "  Install $1? [Y/n] " r; [[ "${r,,}" != "n" ]]; }
  ask "Neovim (PPA, 0.9+) + Lua config" || INSTALL_NEOVIM=false
  ask "lsd (modern ls with icons)"       || INSTALL_LSD=false
  ask "bat (modern cat with syntax hl)"  || INSTALL_BAT=false
  ask "neofetch (system info on startup)"|| INSTALL_NEOFETCH=false
  ask "htop (interactive process viewer)"|| INSTALL_HTOP=false
  ask "Powerlevel10k theme"              || INSTALL_P10K=false
  ask "zsh-autosuggestions plugin"       || INSTALL_AUTOSUGG=false
  ask "zsh-syntax-highlighting plugin"   || INSTALL_SYNTHIGH=false
fi

echo ""
echo "📋 Installing selected components..."

# ─── Base Packages ────────────────────────────────────────
echo "📦 Installing base packages (zsh, git, curl, wget)..."
sudo apt update
sudo apt install -y zsh git curl wget

# ─── Optional CLI Tools ───────────────────────────────────
PKGS=()
$INSTALL_LSD      && PKGS+=(lsd)
$INSTALL_NEOFETCH && PKGS+=(neofetch)
$INSTALL_HTOP     && PKGS+=(htop)
$INSTALL_BAT      && PKGS+=(bat)

if [ ${#PKGS[@]} -gt 0 ]; then
  echo "📦 Installing: ${PKGS[*]}..."
  sudo apt install -y "${PKGS[@]}"
fi

# ─── Neovim via PPA ──────────────────────────────────────
if $INSTALL_NEOVIM; then
  echo "📝 Installing Neovim (via PPA for version 0.9+)..."
  if ! command -v nvim &>/dev/null || [[ "$(nvim --version | head -1 | grep -oP '\d+\.\d+')" < "0.9" ]]; then
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo apt update
    sudo apt install -y neovim
  else
    echo "   Neovim already up-to-date, skipping."
  fi
fi

# ─── Set Zsh as Default Shell ────────────────────────────
echo "🐚 Setting Zsh as the default shell..."
chsh -s $(which zsh)

# ─── Install Oh My Zsh ───────────────────────────────────
echo "📥 Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  export RUNZSH=no
  export CHSH=no
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "   Oh My Zsh already installed, skipping."
fi

# ─── Powerlevel10k ───────────────────────────────────────
if $INSTALL_P10K; then
  echo "🎨 Installing Powerlevel10k theme..."
  P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  else
    echo "   Powerlevel10k already installed, skipping."
  fi
fi

# ─── Zsh Plugins ─────────────────────────────────────────
if $INSTALL_AUTOSUGG; then
  echo "🔌 Installing zsh-autosuggestions..."
  AUTOSUGG_DIR="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  [ ! -d "$AUTOSUGG_DIR" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGG_DIR" \
    || echo "   zsh-autosuggestions already installed, skipping."
fi

if $INSTALL_SYNTHIGH; then
  echo "🔌 Installing zsh-syntax-highlighting..."
  SYNTHIGH_DIR="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  [ ! -d "$SYNTHIGH_DIR" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$SYNTHIGH_DIR" \
    || echo "   zsh-syntax-highlighting already installed, skipping."
fi

# ─── Backup existing dotfiles ────────────────────────────
echo "📁 Backing up existing dotfiles..."
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
for file in .zshrc .p10k.zsh .aliases .vimrc; do
  [ -f "$HOME/$file" ] && cp "$HOME/$file" "$BACKUP_DIR/$file" && echo "   Backed up ~/$file"
done
[ -d "$HOME/.config/nvim" ] && cp -r "$HOME/.config/nvim" "$BACKUP_DIR/nvim" && echo "   Backed up ~/.config/nvim"
echo "   Backup saved to $BACKUP_DIR"

# ─── Copy & Patch .zshrc ─────────────────────────────────
echo "📄 Configuring .zshrc..."
cp "$SCRIPT_DIR/.zshrc" ~/.zshrc

# Set theme
if $INSTALL_P10K; then
  cp "$SCRIPT_DIR/.p10k.zsh" ~/.p10k.zsh
else
  sed -i 's|^ZSH_THEME=.*|ZSH_THEME="robbyrussell"|' ~/.zshrc
  sed -i '/p10k\.zsh/d' ~/.zshrc
  sed -i '/POWERLEVEL9K_INSTANT_PROMPT/d' ~/.zshrc
  sed -i '/p10k-instant-prompt/d' ~/.zshrc
fi

# Remove neofetch line if not installed
$INSTALL_NEOFETCH || sed -i '/neofetch/d' ~/.zshrc

# ─── Aliases ─────────────────────────────────────────────
cp "$SCRIPT_DIR/.aliases" ~/.aliases

# ─── Vimrc ───────────────────────────────────────────────
[ -f "$SCRIPT_DIR/.vimrc" ] && cp "$SCRIPT_DIR/.vimrc" ~/.vimrc

# ─── Clear p10k cache ────────────────────────────────────
# Force regeneration with the new .zshrc on next shell start
rm -f "${XDG_CACHE_HOME:-$HOME/.cache}"/p10k-instant-prompt-*.zsh

# ─── Neovim Config ───────────────────────────────────────
if $INSTALL_NEOVIM; then
  echo "📝 Setting up Neovim config..."
  mkdir -p ~/.config/nvim
  cp "$SCRIPT_DIR/nvim/init.lua" ~/.config/nvim/init.lua
fi

# ─── Font Reminder ───────────────────────────────────────
echo ""
echo "🔤 Reminder: Use a Nerd Font (e.g. 'FiraCode Nerd Font Mono') for proper icon support."
echo "   Download: https://www.nerdfonts.com/font-downloads"

# ─── Done ────────────────────────────────────────────────
echo ""
echo "✅ Setup complete! Restart your terminal or run 'exec zsh' to apply changes."
echo "   Backups of previous configs are in: $BACKUP_DIR"
