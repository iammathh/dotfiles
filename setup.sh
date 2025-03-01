#!/bin/bash

# Script to install dotfiles in devcontainer ( I'm using this for devpods )

echo "Installing dotfiles from setup.sh into devcontainer..."

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
    git
    kubectl
    kubectx
    vim
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

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "stow could not be found, please install it first."
    exit 1
fi

# Define the directory containing your dotfiles
DOTFILES_DIR="$HOME/dotfiles"

# Change to the dotfiles directory
cd "$DOTFILES_DIR" || { echo "Directory $DOTFILES_DIR not found."; exit 1; }

# Remove .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    echo ".bashrc found. Removing .bashrc..."
    rm "$HOME/.bashrc"
fi

# Stow all the dotfiles 
stow */ -v -t ~ 


# Install TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 
fi

# Define the aliases
ALIAS_CMD="alias kubectl='kubectl --insecure-skip-tls-verify'"
ALIAS_K_CMD="alias k='kubectl --insecure-skip-tls-verify'"

# Detect shell configuration file
if [[ $SHELL == *"zsh"* ]]; then
    BASHRC_FILE=~/.zshrc
elif [[ $SHELL == *"bash"* ]]; then
    BASHRC_FILE=~/.bashrc
else
    echo "Unsupported shell. Please manually add the aliases to your shell config."
    exit 1
fi

# Remove all existing 'kubectl' alias if it exists
sed -i '/^alias k=/d' $BASHRC_FILE
sed -i '/^alias kubectl=/d' $BASHRC_FILE
sed -i '/^source <(kubectl completion bash)/d' $BASHRC_FILE
sed -i '/^complete -o default -F __start_kubectl k/d' $BASHRC_FILE

# Append the new lines to the end of the .bashrc file
cat <<EOL >> "$BASHRC_FILE"

# kubectl
alias kubectl='kubectl --insecure-skip-tls-verify'
alias k='kubectl'
source <(kubectl completion bash)
complete -o default -F __start_kubectl k
EOL

# Apply changes
source $BASHRC_FILE

# Add direnv hook to the shell config file
echo 'direnv allow .' >> $BASHRC_FILE

# End of script
echo "Aliases updated successfully! You can now use 'kubectl' and 'k' with --insecure-skip-tls-verify."
echo "Dotfiles have been successfully installed."