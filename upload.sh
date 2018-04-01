#!/bin/bash
#fswatch -o Elastic\ Cat\ Toaster.playgroundbook | xargs -n1 ./upload.sh
sshpass -p alpine sftp root@192.168.1.75:"/private/var/mobile/Library/Mobile Documents/iCloud~com~apple~Playgrounds/Documents" <<< $'put -r "/Users/Adrian/Projects/Elastic Cat Toaster/Elastic Cat Toaster.playgroundbook"'