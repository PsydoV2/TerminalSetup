#!/bin/bash

set -e  # Exit on error

echo "🔧 Starting terminal setup..."

# ─── Update & Install Basic Packages ─────────────────────
echo "📦 Installing required packages..."
sudo apt update
sudo apt install -y zsh git curl wget lsd neofetch bat htop neovim

# ─── Set Zsh as Default Shell ────────────────────────────
echo "🐚 Setting Zsh as the default shell..."
chsh -s $(which zsh)

# ─── Install Oh My Zsh ───────────────────────────────────
echo "📥 Installing Oh My Zsh..."
export RUNZSH=no
export CHSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ─── Install powerlevel10k Theme ─────────────────────────
echo "🎨 Installing powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# ─── Install Zsh Plugins ─────────────────────────────────
echo "🔌 Installing Zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# ─── Copy Dotfiles ───────────────────────────────────────
echo "📁 Copying configuration files..."
cp .zshrc ~/.zshrc
cp .p10k.zsh ~/.p10k.zsh
cp .aliases ~/.aliases
cp .vimrc ~/.vimrc

# ─── Neovim Lua Config ───────────────────────────────────
echo "📝 Creating Neovim config with lazy.nvim..."

# Create config dir
mkdir -p ~/.config/nvim/lua

# Install lazy.nvim
git clone https://github.com/folke/lazy.nvim.git \
  ~/.config/nvim/lua/lazy.nvim

# init.lua
cat <<EOF > ~/.config/nvim/init.lua
-- Basic options
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.cmd("syntax on")

-- lazy.nvim setup
vim.loader.enable()

-- Bootstrap lazy.nvim if needed
local lazypath = vim.fn.stdpath("config") .. "/lua/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Plugins go here
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {}
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
    end
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme tokyonight-night")
    end
  }
})
EOF

# ─── Font Reminder ───────────────────────────────────────
echo "🔤 Please make sure you're using a Nerd Font (e.g., 'FiraCode Nerd Font Mono') in your terminal for proper icon support."

# ─── Done ────────────────────────────────────────────────
echo "✅ Setup complete. Restart your terminal or run 'exec zsh' to apply changes."
