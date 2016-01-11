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
  "all" )
    ./build.sh "stoprm-all" "${VER}"
    ./build.sh "clean-all" "${VER}"
    # ./build.sh "build" "${VER}"
    ./build.sh "test" "${VER}"
    ./build.sh "tag" "${VER}"
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
    ./build.sh "stoprm" "${VER}" >/dev/null 2>&1
    ./build.sh "clean" "${VER}" >/dev/null 2>&1
    ./build.sh "build" "${VER}"
    ./build.sh "start" "${VER}"
    echo "waiting for ${SLEEP} seconds..."
    sleep ${SLEEP}
    STATUS="$(docker ps --filter "name=vixlet-node-test-${VER}" --format "{{.Status}}")"
    STATUS="${STATUS%% *}"
    if [ "${STATUS}" != "Up" ]; then
      echo "test failed!"
      exit 1
    fi
    ./build.sh "stoprm" "${VER}"
    # ./build.sh "clean" "${VER}"
    ;;

  "clean-all" )
    ./build.sh "task-all" "${VER}" "clean"
    ;;

  "push-all" )
    ./build.sh "task-all" "${VER}" "push"
    ;;

  "stoprm-all" )
    ./build.sh "task-all" "${VER}" "stoprm"
    ;;

  "task-all" )
    ./build.sh "${TASKARG}" "${VER}"
    ./build.sh "${TASKARG}" "${SHVER}"
    # if [ "${SHVER}" == "${LATEST}" ]; then
    #   ./build.sh "${TASKARG}" "latest"
    # fi
    ;;

  * )
    echo "build.sh error: unrecognized task!"
    exit 1
    ;;
esac
