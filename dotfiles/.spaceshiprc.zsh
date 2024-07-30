SPACESHIP_EXEC_TIME_ELAPSED=5
SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_EXIT_CODE_PREFIX="ERR:"
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_KUBECTL_VERSION_SHOW=false

SPACESHIP_PROMPT_ORDER=(
    time           # Time stamps section
    user           # Username section
    dir            # Current directory section
    host           # Hostname section
    git            # Git section (git_branch + git_status + [git_commit](default off))
    package        # Package version
    node           # Node.js section
    ruby           # Ruby section
    python         # Python section
    golang         # Go section
    rust           # Rust section
    scala          # Scala section
    java           # Java section
    docker         # Docker section
    docker_compose # Docker section
    aws            # Amazon Web Services section
    venv           # virtualenv section
    kubectl        # Kubectl context section
    ansible        # Ansible section
    terraform      # Terraform workspace section
    nix_shell      # Nix shell
    gnu_screen     # GNU Screen section
    exec_time      # Execution time
    async          # Async jobs indicator
    line_sep       # Line break
    battery        # Battery level and status
    jobs           # Background jobs indicator
    exit_code      # Exit code section
    sudo           # Sudo indicator
    char           # Prompt character
  )
# Precmd function to check if current directory matches the specified directory
function raymond_chpwd() {
  rand=$(shuf -i 1-5 -n 1)
  if [ -d ".git" -a $rand = 1 ]; then
    git fetch -q --prune
    echo "git fetched 🎉"
  fi
  ss_kube_context
}

function raymond_precmd() {
  ss_kube_context
}

function ss_kube_context() {
  # Only show kctx in hds-cmcf-deploy
  KUBECTL_DIRECTORY="$HOME/code/hds-cmcf-deploy"
  if [[ "$PWD" == "$KUBECTL_DIRECTORY"* ]]; then
    SPACESHIP_KUBECTL_SHOW=true
    SPACESHIP_KUBECTL_CONTEXT_SHOW=true
  else
    SPACESHIP_KUBECTL_SHOW=false
    SPACESHIP_KUBECTL_CONTEXT_SHOW=false
  fi
}
