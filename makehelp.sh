#!/bin/bash
set -e


# settings
LATEST="0.10"
SLEEP=2


# named arguments
TASK="${1}"
VER="${2}"
SHVER="${2%.*}"
TASKARG="${3}"


# run requested task
case "${TASK}" in
  "all-supported" )
    ./makehelp.sh "all" "0.10.41"
    ./makehelp.sh "all" "0.12.9"
    ./makehelp.sh "all" "4.2.4"
    ./makehelp.sh "all" "5.3.0"
    ;;

  "push-all-supported" )
    ./makehelp.sh "push-all" "0.10.41"
    ./makehelp.sh "push-all" "0.12.9"
    ./makehelp.sh "push-all" "4.2.4"
    ./makehelp.sh "push-all" "5.3.0"
    ;;

  "all" )
    ./makehelp.sh "stoprm-all" "${VER}"
    ./makehelp.sh "clean-all" "${VER}"
    # ./makehelp.sh "build" "${VER}"
    ./makehelp.sh "test" "${VER}"
    ./makehelp.sh "tag" "${VER}"
    ;;

  "build" )
    docker build -f "${SHVER}/Dockerfile" -t "vixlet/node:${VER}" .
    ;;

  "clean" )
    echo -e $(docker rmi -f "vixlet/node:${VER}"; exit 0)
    ;;

  "push" )
    docker push "vixlet/node:${VER}"
    ;;

  "start" )
    docker run -d -v $(pwd)/example-server:/var/app --name "vixlet-node-test-${VER}" "vixlet/node:${VER}"
    ;;

  "stoprm" )
    echo -e $(docker stop "vixlet-node-test-${VER}"; exit 0)
    echo -e $(docker rm "vixlet-node-test-${VER}"; exit 0)
    ;;

  "tag" )
    docker tag "vixlet/node:${VER}" "vixlet/node:${SHVER}"
    if [ "${SHVER}" == "${LATEST}" ]; then
      docker tag "vixlet/node:${SHVER}" "vixlet/node:latest"
    fi
    ;;

  "test" )
    ./makehelp.sh "stoprm" "${VER}" >/dev/null 2>&1
    ./makehelp.sh "clean" "${VER}" >/dev/null 2>&1
    ./makehelp.sh "build" "${VER}"
    ./makehelp.sh "start" "${VER}"
    echo "waiting for ${SLEEP} seconds..."
    sleep ${SLEEP}
    STATUS="$(docker ps --filter "name=vixlet-node-test-${VER}" --format "{{.Status}}")"
    STATUS="${STATUS%% *}"
    if [ "${STATUS}" != "Up" ]; then
      echo "test failed!"
      exit 1
    fi
    ./makehelp.sh "stoprm" "${VER}"
    # ./makehelp.sh "clean" "${VER}"
    ;;

  "clean-all" )
    ./makehelp.sh "task-all" "${VER}" "clean"
    ;;

  "push-all" )
    ./makehelp.sh "task-all" "${VER}" "push"
    ;;

  "stoprm-all" )
    ./makehelp.sh "task-all" "${VER}" "stoprm"
    ;;

  "task-all" )
    ./makehelp.sh "${TASKARG}" "${VER}"
    ./makehelp.sh "${TASKARG}" "${SHVER}"
    if [ "${SHVER}" == "${LATEST}" ]; then
      ./makehelp.sh "${TASKARG}" "latest"
    fi
    ;;

  * )
    echo "makehelp.sh error: unrecognized task!"
    exit 1
    ;;
esac
