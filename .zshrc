# Set a custom prompt
export PROMPT="%F{white}%n %B%F{brightwhite}%~
%F{%(?.blue.red)}%Bλ%b%f "

# Initialize advanced auto-completion
autoload -Uz compinit
compinit

# Aliases
alias c="clear"
alias g="git"
alias hg="history | grep"
alias sf="swift format --recursive --in-place"
alias mkdir="mkdir -p"

# Kill Ports
kp() {
  for port in $@; do
    local pids=$(lsof -ti tcp:$port)
    if [[ -n $pids ]]; then
      kill -9 $pids && echo "Killed process(es) on port $port"
    else
      echo "No process found on port $port"
    fi
  done
}

# Make Directory and Navigate Into
mkcd() { mkdir $1 && cd $1; }

# Open or Create Vim Session
vs() {
  [[ -f ./Session.vim ]] &&
    vim -S Session.vim ||
    vim +Obsession
}

# pnpm
export PNPM_HOME="/Users/maclong/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(zoxide init zsh)"
