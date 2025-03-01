#!/bin/bash

# Install Homebrew if it's not installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -d "/home/linuxbrew/.linuxbrew" ]; then
     eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
     brew update && brew upgrade 
fi

# List of apps to install
apps=(
    stow
    tmux
    fzf
    direnv
)

# Install each app using Homebrew
for app in "${apps[@]}"; do
    if ! brew list "$app" &> /dev/null; then
        echo "Installing $app..."
        brew install "$app"
    else
        echo "$app is already installed."
    fi
done

# Create the .dotfiles directory in the home directory if it doesn't exist
if [ ! -d "$HOME/.dotfiles" ]; then
    mkdir -p "$HOME/.dotfiles"
fi

# Define the directory containing your dotfiles
DOTFILES_DIR="$HOME/.dotfiles"

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "stow could not be found, please install it first."
    exit 1
fi

# Change to the dotfiles directory
cd "$DOTFILES_DIR" || { echo "Directory $DOTFILES_DIR not found."; exit 1; }

# Stow each directory
stow */ -v -t ~ 

echo "Dotfiles have been successfully installed."