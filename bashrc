# general shell aliases
alias ll='ls -lha'
alias grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'


# docker & kubernetes
alias d-rmdi='docker images -f dangling=true -q | xargs docker rmi'
alias d-stopall='docker ps -q | xargs docker stop'
alias d-rmall='docker ps -qa | xargs docker rm'
alias d-names='docker ps --format "{{.Names}}"'
alias d-images='docker images --format "{{.Repository}}"'
function d-bash() { docker ps -a | grep $1 | awk '{print "docker exec -it " $1 " bash";exit;}'  ; }
function kurl() { curl http://localhost:8001/api/v1/namespaces/$1 ; }


# misc
alias wttr='curl wttr.in'
echo "Aliases/Functions prepared for Raymond"
