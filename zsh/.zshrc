export PATH="$HOME/.local/bin:$PATH"

# Load Oh My Zsh when it is installed; keep a usable shell without it.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="afowler"
ENABLE_CORRECTION="true"
plugins=(git)

if [[ -s "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
else
    autoload -Uz compinit && compinit
    setopt correct
fi

function dir_icon {
    if [[ "$PWD" == "$HOME" ]]; then
        echo "%B%F{black}%f%b"
    else
        echo "%B%F{cyan}%f%b"
    fi
}

function parse_git_branch {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
    [[ -n "$branch" ]] && echo " [$branch]"
}

PROMPT='%F{cyan}󰣇 %f %F{magenta}%n%f $(dir_icon) %F{red}%~%f %F{yellow}$(parse_git_branch)%f %(?.%B%F{green}.%F{red})%f%b '

alias update='sudo pacman -Syu'
alias clean_orphans='orphans=$(pacman -Qtdq); if [[ -n "$orphans" ]]; then sudo pacman -Rns $orphans; else echo "No hay paquetes huérfanos"; fi'
alias clean_aur='command -v yay >/dev/null && yay -Sc || echo "yay no está instalado"'

command -v fastfetch >/dev/null 2>&1 && fastfetch
[[ -f "$HOME/.cache/wal/sequences" ]] && (cat "$HOME/.cache/wal/sequences" &)

# Load Arch-packaged plugins when present. Syntax highlighting must be last.
[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]] && source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
