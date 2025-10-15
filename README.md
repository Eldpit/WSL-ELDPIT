# Personalización de WSL Kali Linux para Pentesting y Desarrollo

Este repositorio contiene scripts y configuraciones que hemos utilizado en nuestro canal de Twitch, [ElDPit](https://www.twitch.tv/eldpit), para personalizar el entorno de Windows Subsystem for Linux (WSL) con Kali Linux. A continuación se detalla el script principal que usamos para configurar WSL Kali con Zsh, Oh My Zsh, el tema Powerlevel10k, y una colección de herramientas CLI modernas con interfaces visuales mejoradas, optimizado para pentesting y desarrollo seguro.

## Script de Configuración de WSL

El script `profileWSL.sh` automatiza la configuración de un entorno de desarrollo productivo y visualmente atractivo en WSL. Realiza las siguientes acciones:

### Configuración Base
1. Actualiza los paquetes del sistema
2. Instala Zsh y lo configura como el shell predeterminado
3. Instala Oh My Zsh, un marco de trabajo para gestionar la configuración de Zsh
4. Instala el tema Powerlevel10k para mejorar la estética y funcionalidad del terminal

### Plugins de Zsh
5. Instala plugins esenciales de la comunidad:
   - `zsh-autosuggestions` - Sugerencias automáticas basadas en el historial
   - `zsh-syntax-highlighting` - Resaltado de sintaxis en tiempo real
   - `zsh-completions` - Autocompletado avanzado
   - `zsh-history-substring-search` - Búsqueda mejorada en el historial
   - `you-should-use` - Te sugiere cuando tienes un alias para el comando que escribiste
   - `zsh-interactive-cd` - Navegación interactiva con fzf en carpetas
6. Activa plugins nativos de Oh-My-Zsh:
   - `git` - Aliases y funciones para Git
   - `sudo` - Presiona ESC dos veces para agregar sudo al comando
   - `command-not-found` - Sugiere paquetes cuando un comando no existe
   - `copypath` - Copia la ruta actual al portapapeles
   - `copybuffer` - Copia el buffer de la línea de comandos
   - `dirhistory` - Navega por el historial de directorios con Alt+flechas
   - `extract` - Extrae cualquier archivo comprimido con un solo comando
   - `web-search` - Busca en Google, Stack Overflow, etc desde la terminal
   - `colored-man-pages` - Páginas de manual con colores
7. Instala `fzf` - Buscador difuso de archivos y comandos con preview

### Configuraciones Avanzadas de Zsh
8. Configura historial mejorado:
   - Historial de 100,000 comandos
   - Sin duplicados
   - Compartido entre sesiones
   - Con timestamps
9. Habilita corrección ortográfica automática de comandos
10. Mejora el autocompletado con navegación inteligente
11. Permite navegación rápida (solo escribe el nombre del directorio sin cd)

### Homebrew y Herramientas Modernas
12. Instala Homebrew con verificación y manejo de errores
13. Instala herramientas CLI modernas con mejor UI:
   - `bat` - Reemplazo de cat con sintaxis coloreada y numeración de líneas
   - `eza` - Alternativa moderna a ls con iconos y colores
   - `btop` - Monitor del sistema interactivo y visualmente impresionante
   - `fastfetch` - Información del sistema con estilo y logo de Kali
   - `delta` - Visor de diffs de Git con sintaxis coloreada
   - `glow` - Renderizador de archivos Markdown en terminal
   - `lazygit` - Interfaz TUI (Text User Interface) para Git
   - `ncdu` - Analizador de espacio en disco con interfaz visual
   - `tldr` - Páginas de ayuda simplificadas y con ejemplos

### Herramientas Específicas para Kali/Pentesting (Opcional)
14. Herramientas de seguridad con interfaz mejorada:
   - `httpie` - Cliente HTTP intuitivo para testing de APIs
   - `jq` - Procesador JSON con sintaxis coloreada
   - `ripgrep` - Búsqueda ultrarrápida en archivos
   - `fd` - Alternativa moderna a find
   - `dog` - Alternativa moderna a dig (DNS queries)
   - `procs` - Alternativa moderna a ps (visualización de procesos)

### Aliases y Configuración
15. Configura aliases útiles para las herramientas modernas:
    - `cat` → `bat` (cat con colores)
    - `ls`, `ll`, `la`, `lt` → `eza` (listado mejorado)
    - `top` → `btop` (monitor del sistema)
    - `lg` → `lazygit` (interfaz Git)
    - `df` → `ncdu` (análisis de disco)
    - `help` → `tldr` (ayuda rápida)
    - `find` → `fd` (búsqueda de archivos)
    - `grep` → `rg` (ripgrep)
    - `ps` → `procs` (procesos)
    - `dig` → `dog` (DNS)
16. Configura FZF con preview usando bat para búsquedas más visuales
17. Crea configuración predeterminada para Powerlevel10k optimizada para Kali

## Plugins de Zsh Incluidos

### Plugins de la Comunidad
- **zsh-autosuggestions**: Sugerencias en tiempo real basadas en tu historial
- **zsh-syntax-highlighting**: Resalta la sintaxis de los comandos mientras escribes
- **zsh-completions**: Añade miles de completados adicionales
- **zsh-history-substring-search**: Busca en el historial con flechas arriba/abajo
- **you-should-use**: Te recuerda usar aliases que ya tienes configurados
- **zsh-interactive-cd**: Navegación interactiva con fzf

### Plugins Nativos de Oh-My-Zsh
- **git**: 100+ aliases y funciones para Git
- **sudo**: Presiona ESC dos veces para añadir sudo al comando actual
- **command-not-found**: Sugiere qué paquete instalar cuando un comando no existe
- **copypath**: Copia rutas al portapapeles fácilmente
- **copybuffer**: Copia el buffer de comandos actual
- **dirhistory**: Alt+← y Alt+→ para navegar por directorios visitados
- **extract**: Un solo comando para extraer cualquier archivo comprimido
- **web-search**: `google término`, `stackoverflow pregunta`, etc
- **colored-man-pages**: Páginas de manual más legibles con colores

## Funcionalidades de Zsh Mejoradas

### Historial Inteligente
- 100,000 comandos guardados
- Sin duplicados en el historial
- Historial compartido entre todas las sesiones de terminal
- Timestamps para cada comando
- No guarda comandos que empiezan con espacio (útil para comandos con contraseñas)

### Corrección Automática
- Corrige errores tipográficos en comandos
- Sugiere la corrección correcta antes de ejecutar

### Navegación Rápida
- Escribe solo el nombre de un directorio para entrar en él (sin necesidad de `cd`)
- Stack de directorios automático para navegar hacia atrás

### Autocompletado Inteligente
- Menú interactivo de completado
- Completa desde cualquier parte de la palabra
- Lista compacta de opciones

## Uso para Kali Linux en WSL

Este script está optimizado para funcionar en **Kali Linux** dentro de WSL. Las herramientas instaladas son compatibles con las tareas de pentesting y análisis de seguridad, proporcionando una interfaz visual mejorada sin comprometer la funcionalidad de las herramientas nativas de Kali.

### Requisitos
- Windows 10/11 con WSL2 habilitado
- Kali Linux instalado desde la Microsoft Store
- Conexión a internet

### Instalación Rápida
```bash
git clone https://github.com/Eldpit/WSL-ELDPIT.git
cd WSL-ELDPIT
chmod +x profileWSL.sh
./profileWSL.sh
```

### Comandos Útiles Después de la Instalación

#### Comandos Básicos Mejorados
```bash
# Ver información del sistema con estilo
sysinfo        # alias de fastfetch

# Monitor del sistema visual
btop           # o simplemente usa 'top' (aliased)

# Ver archivos con sintaxis coloreada
cat archivo.txt           # ahora usa bat automáticamente

# Listado de archivos con iconos
ls                        # ahora usa eza con iconos
ll                        # listado largo
la                        # incluye archivos ocultos
lt                        # vista de árbol
```

#### Git Mejorado
```bash
# Interfaz visual para Git
lg             # alias de lazygit

# Ver diffs mejorados
git diff       # automáticamente usa delta

# Log visual
glog           # git log con gráfico

# Algunos aliases de git incluidos:
gst            # git status
gco            # git checkout
gcm            # git commit -m
gp             # git push
gl             # git pull
```

#### Herramientas de Búsqueda
```bash
# Buscar archivos (más rápido que find)
fd nombre_archivo

# Buscar en contenido (más rápido que grep)
rg "texto a buscar"

# Búsqueda interactiva con preview
fzf            # Ctrl+T para buscar archivos
               # Ctrl+R para buscar en historial

# Navegación interactiva de carpetas
cd **<TAB>     # abre selector interactivo
```

#### Herramientas de Pentesting
```bash
# Cliente HTTP mejorado
http GET https://api.ejemplo.com

# Procesar JSON
echo '{"nombre":"test"}' | jq '.nombre'

# DNS lookup mejorado
dog google.com

# Ver procesos mejorado
procs          # o usa 'ps' (aliased)

# Ver archivos del sistema
viewhosts      # muestra /etc/hosts con colores
viewresolv     # muestra /etc/resolv.conf con colores
```

#### Utilidades
```bash
# Ayuda rápida de comandos
tldr comando   # o usa 'help' (aliased)

# Renderizar markdown en terminal
glow README.md

# Análisis de espacio en disco
ncdu           # o usa 'df' (aliased)

# Extraer cualquier archivo comprimido
extract archivo.zip    # funciona con .zip, .tar.gz, .rar, etc

# Buscar en la web desde terminal
google "búsqueda"
stackoverflow "error message"
github "proyecto"
```

#### Atajos de Teclado
```bash
ESC ESC        # Añade sudo al comando actual
Ctrl+R         # Búsqueda difusa en historial (fzf)
Ctrl+T         # Búsqueda de archivos (fzf)
Alt+C          # Cambiar directorio interactivamente (fzf)
Alt+←/→        # Navegar por directorios visitados
Ctrl+Z         # Suspender proceso (luego 'fg' para volver)
```

#### Personalización
```bash
# Reconfigurar el prompt
p10k configure

# Recargar configuración de Zsh
source ~/.zshrc

# Ver todos los aliases disponibles
alias

# Ver todos los plugins activos
omz plugin list
```


![image](https://github.com/Eldpit/WSL-ELDPIT/assets/157283398/2bb24199-f630-4acf-aa96-12092d1505e6)


## Síguenos en Twitch
Para ver más sobre cómo desarrollamos y personalizamos entornos de desarrollo, ¡síguenos en Twitch!

🔴 [ElDPit en Twitch](https://www.twitch.tv/eldpit)

Transmitimos regularmente sesiones de programación en vivo, donde trabajamos en proyectos como este y otros similares. ¡Únete a nuestra comunidad para aprender, contribuir y pasar un buen rato!

---
Estilos de letra https://www.nerdfonts.com/font-downloads

---

©Eldpit. Todos los derechos reservados.
