# general shell aliases
alias ll='ls -lha'
alias grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias curl='curl -Ls'

# docker & kubernetes
alias d-rmdi='docker images -f dangling=true -q | xargs docker rmi'
alias d-stopall='docker ps -q | xargs docker stop'
alias d-rmall='docker ps -qa | xargs docker rm'
alias d-names='docker ps --format "{{.Names}}"'
alias d-images='docker images --format "{{.Repository}}"'
function d-bash() { docker ps -a | grep $1 | awk '{print "docker exec -it " $1 " bash";exit;}'  ; }
function k-proxurl() { curl http://localhost:8001/api/v1/namespaces/$1 ; }
function k-url() { curl http://localhost:8080/api/v1/namespaces/$1 ; }
alias k-rmall='kubectl delete svc,deployments,daemonsets,ingress --all -n '
alias k-rsk8s='cd /etc/systemd/system/multi-user.target.wants; for i in `ls kube*`; do systemctl stop $i; systemctl start $i; done; cd -'
alias k-sc='kubectl config use-context'

# misc
alias wttr='curl wttr.in'
echo "✈️✈️ Aliases/Functions prepared 🍺🍺"
