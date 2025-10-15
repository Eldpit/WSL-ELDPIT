#!/bin/bash

# Actualizar el sistema
sudo apt update
sudo apt upgrade -y

#Instalar git y curl
sudo apt install git curl -y

# Instalar Zsh
sudo apt install zsh -y

# Cambiar el shell predeterminado a Zsh
chsh -s /usr/bin/zsh

# Instalar oh-my-zsh
sh -c "RUNZSH=no; $(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Instalar el tema Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# ===== INSTALACIÓN DE PLUGINS DE ZSH =====
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "🔌 Instalando plugins de Zsh..."
echo "═══════════════════════════════════════════════════════════"

# Plugins esenciales de la comunidad
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    echo "Instalando zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    echo "Instalando zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-completions ]; then
    echo "Instalando zsh-completions..."
    git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
fi

if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search ]; then
    echo "Instalando zsh-history-substring-search..."
    git clone https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search
fi

# Plugin adicional: you-should-use (sugiere aliases existentes)
if [ ! -d ~/.oh-my-zsh/custom/plugins/you-should-use ]; then
    echo "Instalando you-should-use..."
    git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ~/.oh-my-zsh/custom/plugins/you-should-use
fi

# Plugin adicional: zsh-interactive-cd (navegación interactiva)
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-interactive-cd ]; then
    echo "Instalando zsh-interactive-cd..."
    git clone https://github.com/changyuheng/zsh-interactive-cd.git ~/.oh-my-zsh/custom/plugins/zsh-interactive-cd
fi

echo "✓ Plugins de Zsh instalados"

# Instalar fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# ===== INSTALACIÓN DE HOMEBREW =====
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "📦 Instalando Homebrew (gestor de paquetes)..."
echo "═══════════════════════════════════════════════════════════"

# Verificar si Homebrew ya está instalado
if command -v brew &> /dev/null; then
    echo "✓ Homebrew ya está instalado"
    brew --version
else
    echo "Descargando e instalando Homebrew..."
    # Instalar dependencias necesarias primero
    sudo apt install build-essential procps curl file git -y

    # Instalar Homebrew de forma no interactiva
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Verificar instalación
    if [ $? -eq 0 ]; then
        echo "✓ Homebrew instalado exitosamente"
    else
        echo "✗ Error al instalar Homebrew. Intenta instalarlo manualmente."
        exit 1
    fi
fi

# Configurar Homebrew en el PATH si no está ya configurado
if ! grep -q "linuxbrew" ~/.zshrc; then
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
fi

# Cargar Homebrew en la sesión actual
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Actualizar Homebrew
echo "Actualizando Homebrew..."
brew update

# Instalar herramientas CLI modernas con mejor interfaz visual
echo "Instalando herramientas CLI modernas..."
brew install bat           # cat mejorado con sintaxis coloreada
brew install eza           # ls moderno con iconos y colores
brew install btop          # monitor del sistema ultra visual
brew install fastfetch     # información del sistema con estilo
brew install delta         # visor de diffs de git mejorado
brew install glow          # renderizador de markdown en terminal
brew install lazygit       # interfaz TUI para git
brew install ncdu          # analizador de espacio en disco visual
brew install tldr          # páginas de ayuda simplificadas

# Herramientas adicionales para Kali/Pentesting con mejor UI (opcional)
echo "Instalando herramientas adicionales para pentesting..."
brew install httpie        # cliente HTTP intuitivo para APIs
brew install jq            # procesador JSON con sintaxis coloreada
brew install ripgrep       # búsqueda ultrarrápida (rg)
brew install fd            # alternativa moderna a find
brew install dog           # alternativa moderna a dig
brew install procs         # alternativa moderna a ps

# ===== CONFIGURACIÓN DE ZSH =====
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "⚙️  Configurando Zsh..."
echo "═══════════════════════════════════════════════════════════"

# Configurar el tema Powerlevel10k
sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Configurar plugins (incluye plugins nativos de Oh-My-Zsh y custom)
sed -i 's/plugins=(.*)/plugins=(git sudo command-not-found copypath copybuffer dirhistory extract web-search colored-man-pages zsh-autosuggestions zsh-syntax-highlighting zsh-completions zsh-history-substring-search you-should-use zsh-interactive-cd fzf)/' ~/.zshrc

# Configuraciones adicionales de Zsh
cat >> ~/.zshrc << 'EOF'

# ===== CONFIGURACIÓN DE ZSH MEJORADA =====

# Historial mejorado
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY          # Guardar timestamp en el historial
setopt HIST_EXPIRE_DUPS_FIRST    # Eliminar duplicados primero cuando el historial se llena
setopt HIST_IGNORE_DUPS          # No guardar comandos duplicados
setopt HIST_IGNORE_ALL_DUPS      # Eliminar comandos antiguos duplicados
setopt HIST_FIND_NO_DUPS         # No mostrar duplicados en búsqueda
setopt HIST_IGNORE_SPACE         # No guardar comandos que empiezan con espacio
setopt HIST_SAVE_NO_DUPS         # No guardar duplicados en el archivo
setopt HIST_VERIFY               # Mostrar comando antes de ejecutar del historial
setopt SHARE_HISTORY             # Compartir historial entre sesiones

# Corrección ortográfica
setopt CORRECT                   # Corregir comandos
setopt CORRECT_ALL               # Corregir todos los argumentos

# Autocompletado mejorado
setopt AUTO_LIST                 # Listar opciones automáticamente
setopt AUTO_MENU                 # Usar menú de completado
setopt ALWAYS_TO_END             # Mover cursor al final después de completar
setopt COMPLETE_IN_WORD          # Completar desde ambos extremos de la palabra
setopt LIST_PACKED               # Hacer lista de completado más compacta

# Navegación mejorada
setopt AUTO_CD                   # Cambiar a directorio solo escribiendo su nombre
setopt AUTO_PUSHD                # Hacer cd push el directorio anterior
setopt PUSHD_IGNORE_DUPS         # No duplicar directorios en la pila
setopt PUSHD_SILENT              # No imprimir la pila después de pushd/popd

# Configuración de autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Configuración de you-should-use
export YSU_MESSAGE_POSITION="after"
EOF

echo "✓ Zsh configurado con opciones avanzadas"

# Agregar configuración de fzf al .zshrc
echo 'export FZF_BASE=~/.fzf' >> ~/.zshrc

# ===== CONFIGURACIÓN BÁSICA DE POWERLEVEL10K =====
echo ""
echo "═══════════════════════════════════════════════════════════"
echo "🎨 Configurando Powerlevel10k..."
echo "═══════════════════════════════════════════════════════════"

# Crear archivo de configuración básico de Powerlevel10k
cat > ~/.p10k.zsh << 'P10K_EOF'
# Configuración básica de Powerlevel10k para WSL Kali
# El usuario puede ejecutar 'p10k configure' para personalizar

# Instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Estilo del prompt
typeset -g POWERLEVEL9K_MODE='nerdfont-complete'
typeset -g POWERLEVEL9K_ICON_PADDING=moderate

# Elementos del prompt izquierdo
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon                 # Icono del sistema
  dir                     # Directorio actual
  vcs                     # Git status
  newline                 # Nueva línea
  prompt_char             # Indicador de prompt
)

# Elementos del prompt derecho
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status                  # Estado del último comando
  command_execution_time  # Tiempo de ejecución
  background_jobs         # Jobs en background
  direnv                  # Direnv
  virtualenv             # Python virtualenv
  anaconda               # Anaconda
  pyenv                  # Pyenv
  rbenv                  # Rbenv
  nodenv                 # Nodenv
  nvm                    # Node version manager
  terraform              # Terraform workspace
  kubecontext            # Kubernetes context
  time                   # Hora actual
)

# Configuración del directorio
typeset -g POWERLEVEL9K_DIR_FOREGROUND=254
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2

# Configuración de Git
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=2
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=3
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=1

# Prompt character
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=2
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=1

# Iconos personalizados para Kali
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=1
typeset -g POWERLEVEL9K_LINUX_DEBIAN_ICON='🐉'

# Tiempo de ejecución de comandos
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=2

# Configuración de colores
typeset -g POWERLEVEL9K_TIME_FOREGROUND=7
typeset -g POWERLEVEL9K_STATUS_OK=false
typeset -g POWERLEVEL9K_STATUS_ERROR=true

# Transient prompt (simplifica el historial)
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
P10K_EOF

# Agregar sourcing de p10k al .zshrc
echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc

echo "✓ Powerlevel10k configurado (ejecuta 'p10k configure' para personalizar)"

# Agregar aliases para las herramientas modernas
cat >> ~/.zshrc << 'EOF'

# ===== ALIASES PARA HERRAMIENTAS MODERNAS =====
alias cat='bat --style=auto'
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias lt='eza --tree --icons --group-directories-first'
alias tree='eza --tree --icons'
alias top='btop'

# Git aliases mejorados
alias lg='lazygit'
alias gd='git diff'
alias gds='git diff --staged'
alias glog='git log --oneline --graph --decorate --all'

# Aliases para herramientas de pentesting mejoradas
alias find='fd'
alias grep='rg'
alias ps='procs'
alias dig='dog'
alias http='httpie'

# Otros aliases útiles
alias df='ncdu'
alias help='tldr'
alias sysinfo='fastfetch'

# Alias para ver archivos comunes en pentesting
alias viewhosts='bat /etc/hosts'
alias viewresolv='bat /etc/resolv.conf'

# Configuración de BAT (cat mejorado)
export BAT_THEME="TwoDark"
export BAT_STYLE="numbers,changes,header"

# Configuración de FZF con preview usando bat
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Configuración de RIPGREP
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
EOF

# Crear configuración de ripgrep
cat > ~/.ripgreprc << 'EOF'
# Usar colores
--colors=line:fg:yellow
--colors=line:style:bold
--colors=path:fg:green
--colors=path:style:bold
--colors=match:fg:black
--colors=match:bg:yellow
--colors=match:style:nobold

# Smart case
--smart-case
EOF

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✨ Configuración de WSL Kali completada exitosamente! ✨"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "📦 HERRAMIENTAS BÁSICAS INSTALADAS:"
echo "  🎨 bat       - cat con sintaxis coloreada (alias: cat)"
echo "  📁 eza       - ls moderno con iconos (alias: ls, ll, la)"
echo "  📊 btop      - monitor del sistema visual (alias: top)"
echo "  🚀 fastfetch - información del sistema (alias: sysinfo)"
echo "  🔍 delta     - diffs de git mejorados"
echo "  📝 glow      - markdown en terminal"
echo "  🌿 lazygit   - interfaz TUI para git (alias: lg)"
echo "  💾 ncdu      - análisis de disco (alias: df)"
echo "  📚 tldr      - ayuda simplificada (alias: help)"
echo ""
echo "🔐 HERRAMIENTAS PARA PENTESTING:"
echo "  🌐 httpie    - cliente HTTP moderno (alias: http)"
echo "  📋 jq        - procesador JSON"
echo "  🔎 ripgrep   - búsqueda ultrarrápida (alias: grep)"
echo "  📂 fd        - find moderno (alias: find)"
echo "  🌍 dog       - DNS queries moderno (alias: dig)"
echo "  ⚙️  procs     - ps mejorado (alias: ps)"
echo ""
echo "⌨️  COMANDOS ÚTILES:"
echo "  • sysinfo    → Ver información del sistema"
echo "  • btop       → Monitor del sistema"
echo "  • lg         → Interfaz Git"
echo "  • glow FILE  → Ver markdown"
echo "  • viewhosts  → Ver /etc/hosts"
echo ""
echo "Por favor, cierra y vuelve a abrir tu terminal para aplicar todos los cambios."
echo "Luego ejecuta 'sysinfo' para ver tu configuración!"
echo "════════════════════════════════════════════════════════════"

# Reiniciar Zsh
exec zsh
