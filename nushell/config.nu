# Environment Variables
$env.EDITOR = "/opt/homebrew/bin/hx"
$env.PNPM_HOME = "/Users/maclong/Library/pnpm"

# Update PATH for pnpm
if (not ($env.PATH | str contains $env.PNPM_HOME)) {
    $env.PATH = ([$env.PNPM_HOME, ($env.PATH | default '')] | path join)
}

# Aliases
alias c = clear
alias g = git
alias mkdir = mkdir -p

def hg [pattern: string] {
    history | where command =~ $pattern
}

# Kill processes on specified ports
def kp [...ports: int] {
    for port in $ports {
        let pid = (ps | where command =~ $".*:($port).*" | get pid | first?)
        if $pid != null {
            kill -9 $pid
            print $"Killed process on port ($port)"
        } else {
            print $"No process found on port ($port)"
        }
    }
}

# Make directory and navigate into it
def mkcd [dir: path] {
    mkdir $dir
    cd $dir
}

# Initialize starship prompt if installed
if (which starship | is-empty | not) {
    mkdir ~/.cache/starship
    starship init nu | save -f ~/.cache/starship/init.nu
}

# Initialize zoxide if installed
if (which zoxide | is-empty | not) {
    zoxide init nushell | save -f ~/.zoxide.nu
}
