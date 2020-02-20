#!/bin/bash
# This installs all my favourite k8s CLI tools
# krew
(
  set -x; cd "$(mktemp -d)" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v0.3.4/krew.{tar.gz,yaml}" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" &&
  "$KREW" install --manifest=krew.yaml --archive=krew.tar.gz &&
  "$KREW" update
)

echo "export PATH=\"${PATH}:${HOME}/.krew/bin\" >> ~/.bashrc
source ~/.bashrc
# kubectx
kubectl krew install ctx
# kubens
kubectl krew install ns
# stern
curl -LS https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64 -o stern ; chmod +x stern ; sudo mv stern /usr/local/sbin/
# kube-prompt
curl -LS https://github.com/c-bata/kube-prompt/releases/download/v1.0.10/kube-prompt_v1.0.10_linux_amd64.zip | gunzip -c > kube-prompt ; chmod +x kube-prompt ; sudo mv kube-prompt /usr/local/sbin/
