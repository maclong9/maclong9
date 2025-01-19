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

# Run `npx` with Deno
nx() {
    deno run -A npm:$1 ${@:2};
}

# Make Directory and Navigate Into
mkcd() { mkdir $1 && cd $1; }

# Open or Create Vim Session
vs() {
    [[ -f ./Session.vim ]] &&
        vim -S Session.vim ||
        vim +Obsession
}

# Configure Deno
if [[ ":$FPATH:" != *":/Users/maclong/.zsh/completions:"* ]]; then export FPATH="/Users/maclong/.zsh/completions:$FPATH"; fi
. "/Users/maclong/.deno/env"
