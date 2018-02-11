# general shell aliases
alias ll='ls -lha'
alias grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias curl='curl -Ls'

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
    i=$((i+1))
    [ "$?" = 1 ] && return
    if [ -z "$2" ]; then
      tmux send-keys "$1" 'C-m'
    else
      var=`echo $2 | cut -d" " -f$i`
      tmux send-keys "$1 $var" 'C-m'
    fi
  done
  tmux select-pane -t $currentIdx
}

# docker & kubernetes
alias d-rmdi='docker images -f dangling=true -q | xargs docker rmi'
alias d-stopall='docker ps -q | xargs docker stop'
alias d-rmall='docker ps -qa | xargs docker rm'
alias d-names='docker ps --format "{{.Names}}"'
alias d-images='docker images --format "{{.Repository}}"'
function d-bash() { docker ps -a | grep $1 | awk '{print "docker exec -it " $1 " bash";exit;}'  ; }
function k-proxurl() { curl http://localhost:8001/api/v1/namespaces/$1 ; }
function k-url() { curl http://localhost:8080/api/v1/namespaces/$1 ; }
function k-bash() { kubectl get pods | grep $1 | awk '{print "kubectl exec -it " $1 " bash";exit;}'  ; }
alias k-rmall='kubectl delete svc,deployments,daemonsets,ingress,cm,secrets,pv,pvc --all -n '
alias k-rsk8s='cd /etc/systemd/system/multi-user.target.wants; for i in `ls kube*`; do systemctl stop $i; systemctl start $i; done; cd -'
alias k-sc='kubectl config use-context'

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


# misc
alias wttr='curl wttr.in'

if [ ! -z $TMUX ] ; then echo "✈️✈️ Joined tmux session 🍺🍺"; fi
