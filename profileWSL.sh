#!/bin/bash

################################################################################
# WSL KALI LINUX - SCRIPT DE CONFIGURACIÓN PROFESIONAL
################################################################################
# Este script configura un entorno de desarrollo y pentesting profesional
# en WSL con Kali Linux, incluyendo:
#   - Zsh con Oh-My-Zsh y Powerlevel10k
#   - Homebrew y herramientas CLI modernas
#   - Plugins esenciales y configuraciones optimizadas
#   - Alias profesionales y funciones útiles para pentesting
#
# Autor: Eldpit
# Repositorio: https://github.com/Eldpit/WSL-ELDPIT
################################################################################

set -e  # Salir si hay errores

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con color
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info "Iniciando configuración del entorno WSL Kali..."

# ===== ACTUALIZACIÓN DEL SISTEMA =====
echo ""
echo "═══════════════════════════════════════════════════════════"
print_info "Actualizando el sistema..."
echo "═══════════════════════════════════════════════════════════"
sudo apt update
sudo apt upgrade -y
print_success "Sistema actualizado"

# ===== INSTALACIÓN DE DEPENDENCIAS BÁSICAS =====
echo ""
echo "═══════════════════════════════════════════════════════════"
print_info "Instalando dependencias básicas..."
echo "═══════════════════════════════════════════════════════════"
sudo apt install git curl wget build-essential -y
print_success "Dependencias instaladas"

# ===== INSTALACIÓN DE ZSH =====
echo ""
echo "═══════════════════════════════════════════════════════════"
print_info "Instalando Zsh..."
echo "═══════════════════════════════════════════════════════════"
sudo apt install zsh -y
print_success "Zsh instalado"

# Cambiar el shell predeterminado a Zsh
print_info "Configurando Zsh como shell predeterminado..."
chsh -s /usr/bin/zsh
print_success "Shell predeterminado cambiado a Zsh"

# ===== INSTALACIÓN DE OH-MY-ZSH =====
echo ""
echo "═══════════════════════════════════════════════════════════"
print_info "Instalando Oh-My-Zsh..."
echo "═══════════════════════════════════════════════════════════"
if [ -d ~/.oh-my-zsh ]; then
    print_warning "Oh-My-Zsh ya está instalado, omitiendo..."
else
    sh -c "RUNZSH=no; $(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    print_success "Oh-My-Zsh instalado"
fi

# ===== INSTALACIÓN DE POWERLEVEL10K =====
echo ""
echo "═══════════════════════════════════════════════════════════"
print_info "Instalando tema Powerlevel10k..."
echo "═══════════════════════════════════════════════════════════"
if [ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]; then
    print_warning "Powerlevel10k ya está instalado, omitiendo..."
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
    print_success "Powerlevel10k instalado"
fi

# ===== INSTALACIÓN DE PLUGINS DE ZSH =====
echo ""
echo "═══════════════════════════════════════════════════════════"
print_info "Instalando plugins esenciales de Zsh..."
echo "═══════════════════════════════════════════════════════════"

# Array de plugins a instalar
declare -A plugins=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
    ["zsh-completions"]="https://github.com/zsh-users/zsh-completions"
    ["zsh-history-substring-search"]="https://github.com/zsh-users/zsh-history-substring-search"
    ["you-should-use"]="https://github.com/MichaelAquilina/zsh-you-should-use"
    ["zsh-interactive-cd"]="https://github.com/changyuheng/zsh-interactive-cd"
)

# Instalar cada plugin si no existe
for plugin in "${!plugins[@]}"; do
    plugin_dir=~/.oh-my-zsh/custom/plugins/$plugin
    if [ ! -d "$plugin_dir" ]; then
        print_info "Instalando $plugin..."
        git clone --depth=1 "${plugins[$plugin]}" "$plugin_dir"
    else
        print_warning "$plugin ya está instalado, omitiendo..."
    fi
done

print_success "Todos los plugins de Zsh instalados"

# ===== INSTALACIÓN DE FZF =====
echo ""
echo "═══════════════════════════════════════════════════════════"
print_info "Instalando FZF (fuzzy finder)..."
echo "═══════════════════════════════════════════════════════════"
if [ -d ~/.fzf ]; then
    print_warning "FZF ya está instalado, omitiendo..."
else
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish
    print_success "FZF instalado"
fi

# ===== INSTALACIÓN DE HOMEBREW =====
echo ""
echo "═══════════════════════════════════════════════════════════"
print_info "Configurando Homebrew (gestor de paquetes)..."
echo "═══════════════════════════════════════════════════════════"

# Verificar si Homebrew ya está instalado
if command -v brew &> /dev/null; then
    print_success "Homebrew ya está instalado ($(brew --version | head -n1))"
else
    print_info "Instalando dependencias de Homebrew..."
    sudo apt install build-essential procps curl file git -y

    print_info "Descargando e instalando Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [ $? -eq 0 ]; then
        print_success "Homebrew instalado exitosamente"
    else
        print_error "Error al instalar Homebrew. Intenta instalarlo manualmente."
        exit 1
    fi
fi

# Configurar Homebrew en el PATH si no está ya configurado
if ! grep -q "linuxbrew" ~/.zshrc 2>/dev/null; then
    print_info "Configurando Homebrew en .zshrc..."
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
fi

# Cargar Homebrew en la sesión actual
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" 2>/dev/null || true

# Actualizar Homebrew
print_info "Actualizando Homebrew..."
brew update

print_success "Homebrew configurado correctamente"

# ===== INSTALACIÓN DE HERRAMIENTAS CLI MODERNAS =====
echo ""
echo "═══════════════════════════════════════════════════════════"
print_info "Instalando herramientas CLI modernas..."
echo "═══════════════════════════════════════════════════════════"

# Lista de herramientas esenciales a instalar
tools_essential=(
    "bat:cat mejorado con sintaxis coloreada"
    "eza:ls moderno con iconos y colores"
    "btop:monitor del sistema ultra visual"
    "fastfetch:información del sistema con estilo"
    "delta:visor de diffs de git mejorado"
    "glow:renderizador de markdown en terminal"
    "lazygit:interfaz TUI para git"
    "ncdu:analizador de espacio en disco visual"
    "tldr:páginas de ayuda simplificadas"
    "yazi:explorador de archivos tipo TUI"
    "zellij:multiplexor de terminal moderno"
    "atuin:historial de shell con búsqueda potente"
    "gping:ping con visualización en tiempo real"
    "zoxide:navegación inteligente de directorios"
)

# Instalar herramientas esenciales
for tool_info in "${tools_essential[@]}"; do
    tool="${tool_info%%:*}"
    if ! brew list "$tool" &>/dev/null; then
        print_info "Instalando $tool..."
        brew install "$tool"
    else
        print_warning "$tool ya está instalado, omitiendo..."
    fi
done

print_success "Herramientas esenciales instaladas"

# ===== INSTALACIÓN DE HERRAMIENTAS PARA PENTESTING =====
echo ""
echo "═══════════════════════════════════════════════════════════"
print_info "Instalando herramientas para pentesting..."
echo "═══════════════════════════════════════════════════════════"

tools_pentesting=(
    "httpie:cliente HTTP intuitivo para APIs"
    "jq:procesador JSON con sintaxis coloreada"
    "ripgrep:búsqueda ultrarrápida (rg)"
    "fd:alternativa moderna a find"
    "dog:alternativa moderna a dig"
    "procs:alternativa moderna a ps"
)

# Instalar herramientas de pentesting
for tool_info in "${tools_pentesting[@]}"; do
    tool="${tool_info%%:*}"
    if ! brew list "$tool" &>/dev/null; then
        print_info "Instalando $tool..."
        brew install "$tool"
    else
        print_warning "$tool ya está instalado, omitiendo..."
    fi
done

print_success "Herramientas de pentesting instaladas"

# ===== CONFIGURACIÓN DE ZSH =====
echo ""
echo "═══════════════════════════════════════════════════════════"
print_info "Configurando Zsh con plugins y tema..."
echo "═══════════════════════════════════════════════════════════"

# Backup del .zshrc original
if [ -f ~/.zshrc ] && [ ! -f ~/.zshrc.backup ]; then
    print_info "Creando backup de .zshrc..."
    cp ~/.zshrc ~/.zshrc.backup
fi

# Configurar el tema Powerlevel10k
print_info "Configurando tema Powerlevel10k..."
sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Configurar plugins (incluye plugins nativos de Oh-My-Zsh y custom)
print_info "Configurando plugins de Zsh..."
sed -i 's/plugins=(.*)/plugins=(git sudo command-not-found copypath copybuffer dirhistory extract web-search colored-man-pages zsh-autosuggestions zsh-syntax-highlighting zsh-completions zsh-history-substring-search you-should-use zsh-interactive-cd fzf)/' ~/.zshrc

print_success "Configuración básica de Zsh completada"

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

print_success "Powerlevel10k configurado (ejecuta 'p10k configure' para personalizar)"

# ===== AGREGAR ALIASES Y FUNCIONES AL .ZSHRC =====
echo ""
echo "═══════════════════════════════════════════════════════════"
print_info "Agregando aliases profesionales y funciones útiles..."
echo "═══════════════════════════════════════════════════════════"

# Agregar aliases para las herramientas modernas
cat >> ~/.zshrc << 'EOF'

# ===== ALIASES PROFESIONALES =====

# Navegación y visualización de archivos
alias c='clear'
alias h='history'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# Alias seguros para comandos destructivos
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# Listado de archivos mejorado con eza
if command -v eza &> /dev/null; then
    alias l='eza --icons --group-directories-first'
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lh --icons --group-directories-first --git'
    alias la='eza -lha --icons --group-directories-first --git'
    alias lt='eza --tree --level=2 --icons --group-directories-first'
    alias lta='eza --tree --level=2 --icons --group-directories-first -a'
    alias llt='eza --tree --level=3 --long --icons --group-directories-first'
fi

# Visualización de archivos con bat
if command -v bat &> /dev/null; then
    alias bat='bat --style=auto'
    alias bcat='/bin/cat'  # mantener cat original disponible
    # Solo sobrescribir cat si bat está instalado y funciona correctamente
    alias cat='bat --paging=never'
    alias catp='bat --paging=always'  # cat con paginación
    alias cath='bat --style=header'   # cat con solo cabecera
fi

# Monitor del sistema
if command -v btop &> /dev/null; then
    alias btop='btop'
    alias top='btop'
    alias htop='btop'
fi

# Git aliases profesionales
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gst='git status'
alias gss='git status -s'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --decorate --graph'
alias gla='git log --oneline --decorate --graph --all'
alias glg='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias glog='git log --oneline --graph --decorate --all'

# Git avanzado
alias gclean='git clean -fd'
alias greset='git reset --hard HEAD'
alias gundo='git reset HEAD~1 --soft'
alias gamend='git commit --amend --no-edit'
alias gstash='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'

# Lazygit (interfaz TUI para Git)
if command -v lazygit &> /dev/null; then
    alias lg='lazygit'
fi

# Herramientas de búsqueda modernas
if command -v fd &> /dev/null; then
    alias fd='fd --hidden --follow'
    # No sobrescribir find, mantenerlo disponible
fi

if command -v rg &> /dev/null; then
    alias rg='rg --smart-case --hidden'
    alias rgi='rg --no-ignore --hidden'  # buscar incluso en archivos ignorados
    # No sobrescribir grep, mantenerlo disponible
fi

# Administración de procesos
if command -v procs &> /dev/null; then
    alias px='procs'
fi

# Utilidades de red
if command -v dog &> /dev/null; then
    alias dog='dog'
fi

if command -v httpie &> /dev/null; then
    alias http='http --pretty=all --style=monokai'
    alias https='http --default-scheme=https'
fi

if command -v gping &> /dev/null; then
    alias gping='gping'
fi

# Gestión de archivos y exploración
if command -v yazi &> /dev/null; then
    alias fm='yazi'
    alias y='yazi'
fi

if command -v zellij &> /dev/null; then
    alias zj='zellij'
fi

# Análisis de disco
if command -v ncdu &> /dev/null; then
    alias ncdu='ncdu --color dark'
    alias diskusage='ncdu'
fi

# Ayuda y documentación
if command -v tldr &> /dev/null; then
    alias tldr='tldr --theme ocean'
fi

# Información del sistema
if command -v fastfetch &> /dev/null; then
    alias ff='fastfetch'
    alias neofetch='fastfetch'
fi

# Historial mejorado con Atuin
if command -v atuin &> /dev/null; then
    alias hist='atuin search'
fi

# Markdown en terminal
if command -v glow &> /dev/null; then
    alias glow='glow --pager'
    alias md='glow'
fi

# Docker (si está instalado)
if command -v docker &> /dev/null; then
    alias d='docker'
    alias dc='docker compose'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias di='docker images'
    alias dex='docker exec -it'
    alias dlog='docker logs -f'
    alias dstop='docker stop $(docker ps -q)'
    alias dclean='docker system prune -af'
fi

# Python
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# Pentesting - Aliases específicos
alias ports='netstat -tulanp'
alias myip='curl -s ifconfig.me'
alias localip='ip -4 addr show | grep -oP "(?<=inet\s)\d+(\.\d+){3}"'
alias listening='lsof -i -P -n | grep LISTEN'
alias openports='ss -tuln'

# Visualización rápida de archivos de configuración comunes
alias hosts='bat /etc/hosts 2>/dev/null || cat /etc/hosts'
alias resolv='bat /etc/resolv.conf 2>/dev/null || cat /etc/resolv.conf'
alias fstab='bat /etc/fstab 2>/dev/null || cat /etc/fstab'
alias bashrc='bat ~/.bashrc 2>/dev/null || cat ~/.bashrc'
alias zshrc='bat ~/.zshrc 2>/dev/null || cat ~/.zshrc'

# Actualización del sistema
alias update='sudo apt update && sudo apt upgrade -y'
alias autoclean='sudo apt autoremove -y && sudo apt autoclean'
alias install='sudo apt install'
alias search='apt search'

# Aliases útiles para WSL
alias winhome='cd /mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d "\r")'
alias windownloads='cd /mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d "\r")/Downloads'

# Atajos para edición rápida
alias v='vim'
alias nv='nvim'
alias zshconfig='${EDITOR:-nano} ~/.zshrc'
alias aliasconfig='${EDITOR:-nano} ~/.zshrc && source ~/.zshrc'

# ===== FUNCIONES ÚTILES =====

# Función para crear directorio y entrar en él
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Función para extraer cualquier tipo de archivo comprimido
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' no se puede extraer con extract()" ;;
        esac
    else
        echo "'$1' no es un archivo válido"
    fi
}

# Función para buscar en historial
hgrep() {
    history | grep "$@"
}

# Función para buscar procesos
psgrep() {
    ps aux | grep -v grep | grep -i -e VSZ -e "$@"
}

# Función para backup rápido de archivos
backup() {
    cp "$1"{,.bak-$(date +%Y%m%d-%H%M%S)}
}

# Función para calcular el tamaño de un directorio
dirsize() {
    du -sh "$1" 2>/dev/null
}

# ===== FUNCIONES PARA PENTESTING =====

# Escaneo rápido de puertos con nmap
portscan() {
    if [ -z "$1" ]; then
        echo "Uso: portscan <target>"
        return 1
    fi
    echo "Escaneando puertos comunes en $1..."
    nmap -sV -sC -O "$1"
}

# Escaneo completo de puertos
fullscan() {
    if [ -z "$1" ]; then
        echo "Uso: fullscan <target>"
        return 1
    fi
    echo "Escaneando todos los puertos en $1..."
    nmap -p- -T4 -A "$1"
}

# Información de subdominios (requiere subfinder o similar)
subdomains() {
    if [ -z "$1" ]; then
        echo "Uso: subdomains <domain>"
        return 1
    fi
    echo "Buscando subdominios de $1..."
    if command -v subfinder &> /dev/null; then
        subfinder -d "$1"
    else
        echo "Instala subfinder: go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    fi
}

# Información WHOIS formateada
whoisinfo() {
    if [ -z "$1" ]; then
        echo "Uso: whoisinfo <domain>"
        return 1
    fi
    whois "$1" | grep -E "Domain Name|Registrar|Creation Date|Expiration Date|Name Server"
}

# Análisis de cabeceras HTTP
httpheaders() {
    if [ -z "$1" ]; then
        echo "Uso: httpheaders <url>"
        return 1
    fi
    curl -s -I "$1" | grep -E "Server|X-|Content-Type|Set-Cookie"
}

# Escaneo de tecnologías web (requiere whatweb)
webtech() {
    if [ -z "$1" ]; then
        echo "Uso: webtech <url>"
        return 1
    fi
    if command -v whatweb &> /dev/null; then
        whatweb -a 3 "$1"
    else
        echo "Instala whatweb: sudo apt install whatweb"
    fi
}

# Generar wordlist personalizada
genwordlist() {
    if [ -z "$2" ]; then
        echo "Uso: genwordlist <output_file> <base_words...>"
        echo "Ejemplo: genwordlist passwords.txt password admin 123456"
        return 1
    fi
    output="$1"
    shift
    for word in "$@"; do
        echo "$word" >> "$output"
        echo "${word}123" >> "$output"
        echo "${word}2024" >> "$output"
        echo "${word}!" >> "$output"
        echo "${word}@" >> "$output"
    done
    echo "Wordlist generada en $output"
}

# Buscar archivos por extensión
findext() {
    if [ -z "$1" ]; then
        echo "Uso: findext <extension> [directorio]"
        echo "Ejemplo: findext txt /home/user"
        return 1
    fi
    local dir="${2:-.}"
    if command -v fd &> /dev/null; then
        fd -e "$1" "$dir"
    else
        find "$dir" -type f -name "*.$1" 2>/dev/null
    fi
}

# Convertir IP a hexadecimal (útil para bypass de filtros)
ip2hex() {
    if [ -z "$1" ]; then
        echo "Uso: ip2hex <ip_address>"
        return 1
    fi
    printf '0x%02x%02x%02x%02x\n' $(echo "$1" | tr '.' ' ')
}

# Decodificar base64 de forma rápida
b64decode() {
    if [ -z "$1" ]; then
        echo "Uso: b64decode <base64_string>"
        return 1
    fi
    echo "$1" | base64 -d
    echo
}

# Codificar en base64
b64encode() {
    if [ -z "$1" ]; then
        echo "Uso: b64encode <string>"
        return 1
    fi
    echo -n "$1" | base64
}

# URL encode
urlencode() {
    if [ -z "$1" ]; then
        echo "Uso: urlencode <string>"
        return 1
    fi
    python3 -c "import urllib.parse; print(urllib.parse.quote('$1'))"
}

# URL decode
urldecode() {
    if [ -z "$1" ]; then
        echo "Uso: urldecode <string>"
        return 1
    fi
    python3 -c "import urllib.parse; print(urllib.parse.unquote('$1'))"
}

# ===== CONFIGURACIÓN DE HERRAMIENTAS =====

# Configuración de BAT (cat mejorado)
export BAT_THEME="TwoDark"
export BAT_STYLE="numbers,changes,header"
export BAT_PAGER="less -RF"

# Configuración de FZF con preview usando bat
if command -v bat &> /dev/null; then
    export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border --info=inline --preview 'bat --color=always --style=numbers --line-range=:500 {}' --preview-window=right:50%:wrap"
else
    export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border --info=inline"
fi

export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || tree -C {} 2>/dev/null || ls -lh {}' --preview-window=right:50%:wrap"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# Usar fd con fzf si está disponible
if command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'
fi

# Configuración de RIPGREP
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Configuración de LESS (mejorar visualización)
export LESS='-R -F -X -i -M -W'
export LESSCHARSET='utf-8'

# Editor preferido
export EDITOR='nano'
export VISUAL='nano'

# Configuración de PATH para herramientas comunes
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Go (si se instala)
if [ -d "$HOME/go" ]; then
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
fi

# Inicializar Atuin si está instalado
if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init zsh)"
fi

# Inicializar zoxide si está instalado (navegación inteligente de directorios)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi
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

print_success "Aliases y funciones agregados correctamente"

# ===== RESUMEN FINAL =====
echo ""
echo "════════════════════════════════════════════════════════════════════════════"
echo ""
print_success "¡CONFIGURACIÓN DE WSL KALI COMPLETADA EXITOSAMENTE!"
echo ""
echo "════════════════════════════════════════════════════════════════════════════"
echo ""
echo "${GREEN}📦 HERRAMIENTAS CLI MODERNAS INSTALADAS:${NC}"
echo "  ${BLUE}•${NC} bat       - Visor de archivos con sintaxis coloreada"
echo "  ${BLUE}•${NC} eza       - Listado de archivos moderno (ls, ll, la, lt)"
echo "  ${BLUE}•${NC} btop      - Monitor del sistema interactivo"
echo "  ${BLUE}•${NC} fastfetch - Información del sistema (alias: ff)"
echo "  ${BLUE}•${NC} delta     - Visor de diffs de Git mejorado"
echo "  ${BLUE}•${NC} glow      - Renderizador de Markdown (alias: md)"
echo "  ${BLUE}•${NC} lazygit   - Interfaz TUI para Git (alias: lg)"
echo "  ${BLUE}•${NC} ncdu      - Análisis de uso de disco (alias: diskusage)"
echo "  ${BLUE}•${NC} tldr      - Páginas de ayuda simplificadas"
echo "  ${BLUE}•${NC} yazi      - Explorador de archivos TUI (alias: fm, y)"
echo "  ${BLUE}•${NC} zellij    - Multiplexor de terminal (alias: zj)"
echo "  ${BLUE}•${NC} atuin     - Historial avanzado de comandos (alias: hist)"
echo "  ${BLUE}•${NC} gping     - Ping con visualización en tiempo real"
echo "  ${BLUE}•${NC} zoxide    - Navegación inteligente de directorios"
echo ""
echo "${GREEN}🔐 HERRAMIENTAS PARA PENTESTING:${NC}"
echo "  ${BLUE}•${NC} httpie    - Cliente HTTP moderno (alias: http, https)"
echo "  ${BLUE}•${NC} jq        - Procesador JSON"
echo "  ${BLUE}•${NC} ripgrep   - Búsqueda ultrarrápida de texto (alias: rg)"
echo "  ${BLUE}•${NC} fd        - Búsqueda de archivos moderna"
echo "  ${BLUE}•${NC} dog       - Cliente DNS moderno"
echo "  ${BLUE}•${NC} procs     - Visor de procesos mejorado (alias: px)"
echo ""
echo "${GREEN}⌨️  ALIASES DE GIT PROFESIONALES:${NC}"
echo "  ${BLUE}•${NC} g, ga, gaa, gst, gc, gcm, gco, gb, gp, gpl, gf, gd, gl, glog"
echo "  ${BLUE}•${NC} gclean, greset, gundo, gamend, gstash, gstp"
echo ""
echo "${GREEN}🛠️  FUNCIONES ÚTILES PARA PENTESTING:${NC}"
echo "  ${BLUE}•${NC} portscan <target>     - Escaneo rápido de puertos con nmap"
echo "  ${BLUE}•${NC} fullscan <target>     - Escaneo completo de puertos"
echo "  ${BLUE}•${NC} subdomains <domain>   - Búsqueda de subdominios"
echo "  ${BLUE}•${NC} whoisinfo <domain>    - Información WHOIS resumida"
echo "  ${BLUE}•${NC} httpheaders <url>     - Análisis de cabeceras HTTP"
echo "  ${BLUE}•${NC} webtech <url>         - Detección de tecnologías web"
echo "  ${BLUE}•${NC} findext <ext> [dir]   - Buscar archivos por extensión"
echo "  ${BLUE}•${NC} b64encode/decode      - Codificación/decodificación Base64"
echo "  ${BLUE}•${NC} urlencode/decode      - Codificación/decodificación URL"
echo "  ${BLUE}•${NC} ip2hex <ip>           - Convertir IP a hexadecimal"
echo ""
echo "${GREEN}🎯 FUNCIONES GENERALES ÚTILES:${NC}"
echo "  ${BLUE}•${NC} mkcd <dir>            - Crear directorio y entrar en él"
echo "  ${BLUE}•${NC} extract <file>        - Extraer cualquier archivo comprimido"
echo "  ${BLUE}•${NC} backup <file>         - Crear backup con timestamp"
echo "  ${BLUE}•${NC} hgrep <term>          - Buscar en historial"
echo "  ${BLUE}•${NC} psgrep <term>         - Buscar procesos"
echo ""
echo "${GREEN}📝 ALIASES ÚTILES ADICIONALES:${NC}"
echo "  ${BLUE}•${NC} ports, myip, localip, listening, openports"
echo "  ${BLUE}•${NC} hosts, resolv, fstab - Ver archivos de configuración"
echo "  ${BLUE}•${NC} update, autoclean, install, search - Gestión de paquetes"
echo "  ${BLUE}•${NC} winhome, windownloads - Acceso rápido a Windows"
echo ""
echo "════════════════════════════════════════════════════════════════════════════"
echo ""
print_warning "IMPORTANTE: Por favor, CIERRA Y VUELVE A ABRIR tu terminal"
print_warning "            para aplicar todos los cambios."
echo ""
print_info "Una vez reiniciada la terminal:"
echo "  ${BLUE}1.${NC} Ejecuta ${GREEN}p10k configure${NC} para personalizar el tema"
echo "  ${BLUE}2.${NC} Ejecuta ${GREEN}ff${NC} o ${GREEN}fastfetch${NC} para ver la información del sistema"
echo "  ${BLUE}3.${NC} Usa ${GREEN}tldr <comando>${NC} para ver ayuda rápida de comandos"
echo ""
print_success "Backup de tu .zshrc original guardado en ~/.zshrc.backup"
echo ""
echo "════════════════════════════════════════════════════════════════════════════"
echo ""
print_info "Repositorio: https://github.com/Eldpit/WSL-ELDPIT"
print_info "Si encuentras algún problema, revisa la documentación del repositorio"
echo ""
echo "════════════════════════════════════════════════════════════════════════════"

# Preguntar si desea reiniciar Zsh ahora
echo ""
read -p "¿Deseas iniciar Zsh ahora? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    print_success "Iniciando Zsh..."
    exec zsh
else
    print_info "Recuerda cerrar y abrir tu terminal para aplicar los cambios"
fi
