# 💻 My ZSH Dotfiles Setup for WSL (Windows)

This repository contains my personal terminal configuration for **WSL on Windows**, using **Zsh**, **Oh My Zsh**, and **powerlevel10k** – with a clean and minimal look, custom Windows Terminal profile, and a transparent background wallpaper.

## 📦 What’s included

- `.zshrc` – Zsh configuration with plugins and clean prompt
- `.p10k.zsh` – powerlevel10k config (Zen mode)
- `.aliases` – Custom aliases for fast command shortcuts
- `install.sh` – One-step installer
- Optional: `fonts/` folder with NerdFont (if not installed)
- Optional: Windows Terminal profile JSON snippet

## ⚙️ Getting started with WSL on Windows

Before using this terminal setup, make sure WSL and Ubuntu are installed on your Windows machine.

### ✅ Quick install (Windows 10/11)

Open **PowerShell as Administrator** and run:

```powershell
wsl --install
```

This will automatically:

- Enable WSL
- Install the latest Ubuntu distribution
- Set up WSL 2 as default

After the install is complete, restart your computer.

### 🧠 Manual WSL setup (if needed)

If `wsl --install` doesn't work (older Windows), follow these steps:

1. Enable **Virtual Machine Platform** and **WSL** features:

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

2. Restart your PC
3. Download and install a Linux distribution (e.g. Ubuntu) from the [Microsoft Store](https://aka.ms/wslstore)
4. Set WSL version 2 as default:

```powershell
wsl --set-default-version 2
```

---

Once you’ve installed Ubuntu and launched it for the first time, you can continue with the terminal setup below 👇

## 🧰 Tools installed by `install.sh`

- `zsh`
- `git`
- `curl`, `wget`
- `lsd` (modern `ls` with icons)
- `neofetch` (system info on startup)
- `bat` (modern `cat`)
- `htop` (interactive process viewer)

## 🚀 Installation

```bash
git clone https://github.com/PsydoV2/TerminalSetup
cd TerminalSetup
chmod +x install.sh
./install.sh
```

Then restart your terminal or run:

```bash
exec zsh
```

## 🎨 Windows Terminal Configuration

Here’s the config I use for my Ubuntu WSL profile:

```jsonc
{
  "name": "Ubuntu",
  "source": "Microsoft.WSL",
  "font": {
    "face": "FiraCode Nerd Font Mono",
    "size": 15
  },
  "colorScheme": "IBM 5153",
  "opacity": 75,
  "useAcrylic": true,
  "scrollbarState": "hidden",
  "backgroundImage": "\\wsl.localhost/Ubuntu/home/falter/terminalWallpaper.png",
  "experimental.retroTerminalEffect": false,
  "guid": "{3c411106-319b-56c8-93ba-e36c9825719e}",
  "hidden": false
}
```

📌 **Make sure the image path is valid on your system.**  
You can place your background image inside the repository and adjust the path accordingly.

## 🔤 Fonts

To display symbols/icons correctly, use a Nerd Font like:

[FiraCode Nerd Font Mono](https://www.nerdfonts.com/font-downloads)

- Install via right-click → "Install for all users"
- Set it as your Windows Terminal font

## 🧼 Features

- ✅ Minimalistic powerlevel10k prompt (Zen mode)
- ✅ Git status shown cleanly in prompt
- ✅ `lsd` for colorized, icon-rich directory listings
- ✅ Handy aliases like `ll`, `gs`, `..`, `c`, `reload`
- ✅ Transparent background with wallpaper
- ✅ NerdFont support for dev icons

## 🖼 Screenshot

![screenshot](./screenshot.png)
