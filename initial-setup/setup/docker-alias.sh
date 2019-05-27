#!/bin/bash 

#### # --- Docker Alias ----
alias docker="sudo /usr/bin/docker"
alias db='docker build'
alias dim='docker images'
alias dk='docker'
alias dkil='docker kill'
alias dps='docker ps -a'
alias drm='docker rm'
alias drmi='docker rmi'
alias drst='docker restart'
alias drun='docker run'
alias dst='docker start'
alias dtop='docker top'
alias dstp='docker stop'
alias dport='docker port'
alias dexe='docker exec'
alias dlog='docker logs'
dsh() {
   docker exec -it $1 bash
}
alias dstpall='docker stop $(docker ps -a -q)'
alias drmall='docker rm $(docker ps -a -q)'
alias drmiall='docker rmi $(docker images -q)'
alias dcleanall='dstpall;drmall'
alias ddelall='dstpall;drmall;drmiall'

dinspect() {
    echo "docker inspect -f \"{{ .Config.Env }}\" CONTAINER-ID"
    docker inspect -f "{{ .Config.Env }}" $1
}

dcmt() {
    echo "Example:"
    echo "docker commit -m inital -a openkbs 58c1ade5f549 openkbs/base:1.0.0"
    docker commit $*
}

#### ---- Docker Compose ----
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
