# general shell aliases
alias ll='ls -lhaG'
alias grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias curl='curl -Ls'
alias vi='vim'
alias rm='rm -i'
bindkey \^U backward-kill-line

# Useful setopts
# Enable interactive comments
setopt interactive_comments
setopt AUTO_CD
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST
# do not store duplications
setopt HIST_IGNORE_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
# remove command lines starting with a space from the history
setopt HIST_IGNORE_SPACE

# This is for macOS Big Sur
ulimit -S -n 2048

# cd aliases
alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias cd.....="cd ../../../.."
alias cd......="cd ../../../../.."
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."

# Google IAP Proxy
function iap() {
  first=$1 ; shift ; second=$1 ; shift ; third=$1; shift ; rest=$@
  echo "gcloud beta compute start-iap-tunnel $rest "$first" "$second" --local-host-port=localhost:${third:-$second} " | bash
}
# tmux
alias tm='tmux ls | grep -q default && tmux a -t default || tmux new -s default'
alias tm-a='tmux a -t '
alias tm-n='tmux new -s '
alias tm-k='tmux kill-session -t '
alias tm-l='tmux ls'
alias tm-rmall='tmux ls | awk '"'"'{print $1}'"'"' | cut -d: -f1 | awk '"'"'{print "tmux kill-session -t "$1}'"'"' | bash'
function tm-ssh() {
  ipPrefix=153.71.28.
  user=admin
  tmux new -d
  for host in `echo $1 | xargs echo`; do
    fullhost=$host
    echo $host | grep -q "\."
    [ "$?" = "1" ] && fullhost=$ipPrefix$host
		[ ! -z "$2" ] && cmd="ssh -l $2 $fullhost" || cmd="ssh $fullhost"
		tmux split-window -h
		tmux send-keys "printf '\033]2;%s\033\\' $fullhost" 'C-m'
		tmux send-keys "$cmd" 'C-m'
  done
  tmux a
  echo "Multi-SSH session finished"
}
# Usage: $1:command $2(optional): parameter list in each pane if they are different
function tm-run-in-panes() {
  [ -z "$TMUX_PANE" ] && (echo "Not in tmux session with panes"; return)
  panenum=`tmux list-pane | wc -l | xargs echo`
  currentIdx=`tmux list-pane | grep active | cut -d":" -f1`
  i=0
  while [ $i -lt $panenum ]; do
    tmux select-pane -t $i
    [ "$?" = 1 ] && return
    if [ -z "$2" ]; then
      tmux send-keys "$1" 'C-m'
    else
      var=`echo $2 | cut -d" " -f$((i+1))`
      tmux send-keys "$1 $var" 'C-m'
    fi
    i=$((i+1))
  done
  tmux select-pane -t $currentIdx
}

# docker & kubernetes
alias d-rmdi='docker images -f dangling=true -q | xargs docker rmi'
alias d-stopall='docker ps -q | xargs docker stop'
alias d-rmall='docker ps -qa | xargs docker rm'
alias d-names='docker ps --format "{{.Names}}"'
alias d-images='docker images --format "{{.Repository}}"'
alias dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm alpine/dfimage -sV=1.36"
function d-bash() { docker ps -a | grep $1 | awk '{print "docker exec -it " $1 " bash";exit;}'  ; }
function k-proxurl() { curl http://localhost:8001/api/v1/namespaces/$1 ; }
function k-url() { curl http://localhost:8080/api/v1/namespaces/$1 ; }
function k-bash() { kubectl get pods | grep $1 | awk '{print "kubectl exec -it " $1 " bash";exit;}'  ; }
function k-svc() { for i in kubelet kube-proxy kube-apiserver kube-controller-manager kube-scheduler etcd docker ; do systemctl $1 $i ; done }
alias k-rmall='kubectl delete svc,deployments,daemonsets,ingress,cm,secrets,pv,pvc --all -n '
alias k-restart-kube='cd /etc/systemd/system/multi-user.target.wants; for i in `ls kube*`; do systemctl stop $i; systemctl start $i; done; cd -'
alias k-stop-kube='cd /etc/systemd/system/multi-user.target.wants; for i in `ls kube*`; do systemctl stop $i; done; cd -'
function k-rd() { kubectl delete -f $1 | kubectl apply -f $1 ; }
alias k-sc='kubectl config use-context'
alias k-af='kubectl apply -f '
alias k-df='kubectl delete -f '
alias k-watch-pods='watch -n 3 kubectl get po --all-namespaces -o wide'
alias k-watch-nodes='watch -n 3 kubectl get nodes -o wide'
alias k-show-statuses='for i in flanneld docker kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy; do systemctl status $i | head -5 ; done | grep active -A3 -B3'
alias k-complete='source <(kubectl completion bash)'

# Networking

# Run this on server side to listen: for i in {start..end}; do nc -lv $i & ;done
# And run probe-ports to probe those ports one by one. 
function probe-ports() {
  if [ -z "$1" -o -z "$2" ]; then
    echo "usage: port-probe.sh HOST PORT-RANGE"
  else
    start=`echo $2 | cut -d"-" -f1`
    end=`echo $2 | cut -d"-" -f2`
    for i in {$start..$end}; do nc -zv $1 $i 2>&1 | grep -q succeeded; [ "$?" = "1" ] &&  echo "Port $i probe failed." ;done
  fi
}

# System services
function svc-start() { systemctl start $1 ; }
function svc-stop() { systemctl stop $1 ; }
function svc-restart() { systemctl restart $1 ; }
function svc-status() { systemctl status -l $1 ; }

# sshfs mount/umount
function ssh-mount() {
  loginUser=$USER
  if [ -z $2 ]; then
    loginUser=$2
  fi
  mkdir -p ~/sshfs/$1
  sudo mount -t sshfs -o allow_other,defer_permissions $2@$1:/ ~/sshfs/$1
  cd ~/sshfs/$1
}
function ssh-umount() {
  sudo umount ~/sshfs/$1
}

# Go
# Perform Go benchmark
alias go_bench='go test -v --bench . --benchmem'

# misc
alias wttr='curl wttr.in'

# SSH related
alias add-keys='~/bin/auto-add-keys.sh'
alias clear_known_hosts='echo > ~/.ssh/known_hosts'

