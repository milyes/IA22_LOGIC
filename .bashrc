
# --- MILYES-IA V9 NANSCORE START ---
_nans_monitor() {
    # Lecture CPU (Charge 1 min) via /proc/loadavg
    local load="0.00"
    if [ -f /proc/loadavg ]; then
        load=$(read -r l1 l2 l3 rest < /proc/loadavg && echo $l1)
    fi

    # Lecture RAM via /proc/meminfo (Plus fiable que 'free')
    local mem_pct="0"
    if [ -f /proc/meminfo ]; then
        local total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        local avail=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
        if [ -n "$total" ] && [ -n "$avail" ]; then
            mem_pct=$(( (total - avail) * 100 / total ))
        fi
    fi

    # Couleurs dynamiques
    local c_cpu="\033[0;32m"
    local c_mem="\033[0;32m"
    
    # Seuils (Comparaison simple via awk pour les décimales)
    if [ $(echo "$load" | awk '{if ($1 > 1.5) print 1; else print 0}') -eq 1 ]; then c_cpu="\033[0;31m"; fi
    if [ "$mem_pct" -gt 80 ]; then c_mem="\033[0;31m"; fi

    echo -e " \033[0;37m[CPU:${c_cpu}${load}\033[0;37m | RAM:${c_mem}${mem_pct}%\033[0;37m]\033[0m"
}

_nans_prompt() {
    local EXIT="$?"
    local PRE="\033[0;36m[NANS-V9]\033[0m"
    local USR="\033[0;34m\u@\h\033[0m"
    local DIR="\033[0;33m\w\033[0m"
    local MON=$(_nans_monitor)
    local SYMB="\033[1;37m❯\033[0m"
    [ $EXIT -ne 0 ] && SYMB="\033[0;31m❯\033[0m"

    PS1="\n${PRE}${MON} ${USR} : ${DIR}\n${SYMB} "
}

if [ -n "$BASH_VERSION" ]; then
    PROMPT_COMMAND=_nans_prompt
elif [ -n "$ZSH_VERSION" ]; then
    setopt prompt_subst
    PROMPT='$(_nans_prompt)'
fi
# --- MILYES-IA V9 NANSCORE END ---

# --- MILYES-IA V9 SYSTEM STATUS ---
function status() {
    echo -e "\n${CYAN}--- MILYES-IA V9 NANS : SYSTEM DASHBOARD ---${NC}"
    
    # 1. Vérification des Modules
    echo -e "${GOLD}[MODULES]${NC}"
    for dir in 01_CORE 02_AGENTS_IA 03_SECURITY_MSRC 04_INFRA_ZCORE; do
        if [ -d "$HOME/$dir" ]; then
            echo -e "  - $dir : ${CYAN}OPÉRATIONNEL${NC}"
        else
            echo -e "  - $dir : ${RED}ABSENT${NC}"
        fi
    done

    # 2. État de la Passerelle (Gateway)
    echo -e "\n${GOLD}[GATEWAY]${NC}"
    if [ -f "$HOME/MILYES_GATEWAY.py" ]; then
        echo -e "  - MILYES_GATEWAY.py : ${CYAN}PRÊT${NC}"
    else
        echo -e "  - MILYES_GATEWAY.py : ${RED}NON DÉTECTÉ${NC}"
    fi

    # 3. Sécurité & Logs
    echo -e "\n${GOLD}[SECURITY]${NC}"
    local log_count=$(ls $HOME/*.log 2>/dev/null | wc -l)
    echo -e "  - Journaux système : ${CYAN}$log_count fichier(s) détecté(s)${NC}"
    
    # 4. Métriques Système
    echo -e "\n${GOLD}[METRICS]${NC}"
    uptime | awk '{print "  - Uptime :" $0}'
    echo -e "${CYAN}------------------------------------------${NC}\n"
}

# --- MILYES-IA V9 BRIDGE : GEMINI 2.6 PRO ---
alias nans-26-ui="termux-open $HOME/02_AGENTS_IA/GEMINI_PRO_V2.6/z-core.html"

function nans-bridge() {
    echo -e "\033[0;36m[NANS-V9 BRIDGE] Initialisation du lien avec GEMINI_CORE 2.6 PRO...\033[0m"
    local MODE=$1
    
    case $MODE in
        "auto")
            python3 $HOME/02_AGENTS_IA/GEMINI_PRO_V2.6/AI_AUTO.py
            ;;
        "cmd")
            bash $HOME/02_AGENTS_IA/GEMINI_PRO_V2.6/IA22cmd.sh
            ;;
        "status")
            echo -e "\033[0;33m[ETAT DU PONT]\033[0m"
            [ -d "$HOME/02_AGENTS_IA/GEMINI_PRO_V2.6" ] && echo " - Noyau 2.6 : CONNECTÉ" || echo " - Noyau 2.6 : DÉCONNECTÉ"
            ;;
        *)
            echo "Usage: nans-bridge {auto|cmd|status}"
            ;;
    esac
}

# Mise à jour de la fonction status existante
function status_v9() {
    status # Appelle l'ancienne fonction
    echo -e "\033[0;33m[BRIDGE 2.6 PRO]\033[0m"
    nans-bridge status
}
# --- END BRIDGE ---
./zcore-g7.sh --all
export PATH=$HOME/bin:$PATH
source ~/.milyes_core/config.env
source ~/.milyes_core/config.env
alias milyes='bash ~/milyes_init.sh && echo "[MILYES] Core Engine Online"'
pgrep crond > /dev/null || crond
pgrep crond > /dev/null || crond
pgrep crond > /dev/null || crond
export ANDROID_HOME=$PREFIX/opt/android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
export ANDROID_HOME=$PREFIX/opt/android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
export ANDROID_HOME=$PREFIX/opt/android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
export PATH="${HOME}/.local/bin:${PATH}"

# Lancement automatique Z-CORE
# cd /data/data/com.termux/files/home/z_core && ./master_orchestrator.sh
export ANTHROPIC_API_KEY="sk-ant-..."
cd ~/zcore-agent7 && nohup python zcore_orchestrator.py > zcore.log 2>&1 &
export Z_KEY=$(cat ~/.z_key.secure 2>/dev/null || openssl rand -hex 32 | tee ~/.z_key.secure)
export Z_KEY=$(cat ~/.z_key.secure 2>/dev/null)
alias ia22='python ~/ia22.py'
alias z-core='curl -s http://localhost:8001/api/status | python -m json.tool'
# Auto-heal port 8001 si crash
[ -z "$(pgrep -f 'http.server 8001')" ] && nohup python -m http.server 8001 --directory ~/ > /dev/null 2>&1 &
# MILYES-IA V9 NANS - IMMORTAL
pgrep -f MILYES_GATEWAY.py >/dev/null || (cd ~/MILYES-IA-V9-NANS-v1_9-89b6df2e-v24 && nohup python MILYES_GATEWAY.py > gateway.log 2>&1 &)
rclone rc vfs/refresh recursive=true
nohup ~/gatekeeper.sh >/dev/null 2>&1 &
