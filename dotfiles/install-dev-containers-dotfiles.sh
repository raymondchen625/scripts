#!/bin/bash
# Set these in vscode's settings.json
###
# "dotfiles.installCommand": "~/scripts/dotfiles/install-dev-containers-dotfiles.sh",
# "dotfiles.repository": "https://github.com/raymondchen625/scripts.git",
# "dotfiles.targetPath": "~/scripts",
###
rsync -av --exclude '.' --exclude '..' ~/scripts/dotfiles/.* ~
