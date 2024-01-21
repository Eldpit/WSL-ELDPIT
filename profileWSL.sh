#!/bin/bash

# Actualizar el sistema
sudo apt update
sudo apt upgrade -y

#Instalar git
sudo apt install git -y

# Instalar Zsh
sudo apt install zsh -y

# Cambiar el shell predeterminado a Zsh
chsh -s /usr/bin/zsh

# Instalar oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Instalar el tema Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# Instalar plugins de Zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search

# Instalar fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Editar el archivo de configuración de Zsh para incluir Powerlevel10k y los plugins
sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
sed -i 's/plugins=(.*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions history-substring-search)/' ~/.zshrc

# Agregar configuración de fzf al .zshrc
echo 'export FZF_BASE=~/.fzf' >> ~/.zshrc

# Reiniciar Zsh
exec zsh
