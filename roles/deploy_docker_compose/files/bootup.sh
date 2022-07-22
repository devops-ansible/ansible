#!/usr/bin/env bash

while [ "${1:-}" != "" ]; do
    case "$1" in
        "-f" | "--force")
            stopCnt="true"
            ;;
        "--rm")
            rmCnt="true"
            ;;
    esac
    shift
done

# feel free to configure

export $(egrep -v '^#' .env | xargs)

set -e
cd "$(dirname "$0")"
startupscript="startup.sh"

export BASEPATH=$( pwd )
export DOCKER_DATAPATH="$( eval "cd ..; pwd" )/"

set +e

docker network create "${DOCKER_PROXYNET}"
docker network create "${DOCKER_DBNET}"
docker network create "${DOCKER_WORLDNET}"

#set -e

for cdir in `find . -maxdepth 1 -type d -not -path '\.' -not -path '\.\.' -not -path '*/\.*'`; do
    echo
    cdir="$( echo "$cdir" | sed -E 's/\.\///' )"
    cd "$cdir"
    # remove currently running containers
    if [ "${rmCnt}" = "true" ]; then
        /usr/local/bin/docker-compose down
    # do stop if --force is pushed to script
    elif [ "${stopCnt}" = "true" ]; then
        /usr/local/bin/docker-compose stop
    fi
    # do startup
    if [ -f "./${startupscript}" ]; then
        echo "starting ${cdir} by start script ..."
        source "./${startupscript}"
    elif [ -f "./docker-compose.yml" ] || [ -f "./docker-compose.yaml" ]; then
        echo "starting ${cdir} by docker compose ..."
        /usr/local/bin/docker-compose pull
        /usr/local/bin/docker-compose up -d
    fi
    echo "change to base: ${BASEPATH}"
    cd "$BASEPATH"
done
