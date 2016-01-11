#!/bin/bash
set -e


###########################################
# Vixlet 'docker/node' image build script #
###########################################


# validate arguments
if [ -z "${1}" ]; then
  echo "build.sh error: no task specified!"
  exit 1
elif [ -z "${2}" ]; then
  echo "build.sh error: no build version specified!"
  exit 1
fi


# helper functions
function vdnbuild_helper_cleanup() {
  # cleanup script's runtime artifacts
  unset -v VDNBUILD_WAIT
  unset -v VDNBUILD_TASK
  unset -v VDNBUILD_VER
  unset -v VDNBUILD_SHVER
  unset -v VDNBUILD_VER_LATEST
  unset -f vdnbuild_task_build
  unset -f vdnbuild_task_clean
  unset -f vdnbuild_task_stoprm
  unset -f vdnbuild_helper_cleanup
}


# trap EXIT signal and run cleanup function
trap vdnbuild_helper_cleanup EXIT


# settings
VDNBUILD_WAIT=2


# arguments
for arg in "$@"; do
  case "${arg}" in
    -l=*|--latest=*)
      VDNBUILD_VER_LATEST="${arg#*=}"
      shift # past argument=value
      ;;
    *)
      # first argument
      if [ -z "${VDNBUILD_TASK}" ]; then
        VDNBUILD_TASK="${arg}"
      # second argument
      elif [ -z "${VDNBUILD_VER}" ]; then
        VDNBUILD_VER="${arg}"
        VDNBUILD_SHVER="${VDNBUILD_VER%.*}"
      fi
      shift # unknown option
      ;;
  esac
done
# echo "VDNBUILD_WAIT=$VDNBUILD_WAIT"
# echo "VDNBUILD_TASK=$VDNBUILD_TASK"
# echo "VDNBUILD_VER=$VDNBUILD_VER"
# echo "VDNBUILD_SHVER=$VDNBUILD_SHVER"
# echo "VDNBUILD_VER_LATEST=$VDNBUILD_VER_LATEST"


# task functions
function vdnbuild_task_build() {
  docker build -f "${2}/Dockerfile" -t "vixlet/node:${1}" .
}

function vdnbuild_task_clean() {
  echo -e $(docker rmi -f "vixlet/node:${1}"; exit 0)
}

function vdnbuild_task_stoprm() {
  echo -e $(docker stop "vixlet-node-test-${1}"; exit 0)
  echo -e $(docker rm "vixlet-node-test-${1}"; exit 0)
}

function vdnbuild_task_start() {
  docker run -d -v $(pwd)/example-server:/var/app --name "vixlet-node-test-${1}" "vixlet/node:${1}"
}


# run task
case "${VDNBUILD_TASK}" in
  # build, test, and tag a specific image version
  "all" )
    # cleanup
    vdnbuild_task_stoprm "${VDNBUILD_VER}" >/dev/null 2>&1
    vdnbuild_task_clean "${VDNBUILD_VER}" >/dev/null 2>&1
    # build & run
    vdnbuild_task_build "${VDNBUILD_VER}" "${VDNBUILD_SHVER}"
    vdnbuild_task_start "${VDNBUILD_VER}"
    echo "waiting for '${VDNBUILD_WAIT}' seconds..."
    sleep ${VDNBUILD_WAIT}
    # check status
    STATUS="$(docker ps --filter "name=vixlet-node-test-${VDNBUILD_VER}" --format "{{.Status}}")"
    STATUS="${STATUS%% *}"
    if [ "${STATUS}" != "Up" ]; then
      echo "build.sh error: test failed for version '${VDNBUILD_VER}'!"
      exit 2
    fi
    # stop
    vdnbuild_task_stoprm "${VDNBUILD_VER}"
    # tag version as short version
    docker tag -f "vixlet/node:${VDNBUILD_VER}" "vixlet/node:${VDNBUILD_SHVER}"
    echo "'vixlet/node:${VDNBUILD_VER}' tagged as 'vixlet/node:${VDNBUILD_SHVER}'!"
    # tag version as latest version
    if [ "${VDNBUILD_VER}" == "${VDNBUILD_VER_LATEST}" ]; then
      docker tag -f "vixlet/node:${VDNBUILD_VER}" "vixlet/node:latest"
      echo "'vixlet/node:${VDNBUILD_VER}' tagged as 'vixlet/node:latest'!"
    fi
    ;;

  # push a specific image version
  "push" )
    docker push "vixlet/node:${VDNBUILD_VER}"
    docker push "vixlet/node:${VDNBUILD_SHVER}"
    if [ "${VDNBUILD_VER}" == "${VDNBUILD_VER_LATEST}" ]; then
      docker push "vixlet/node:latest"
    fi
    ;;

  # fallback for unsupported task
  * )
    echo "build.sh error: unrecognized task!"
    exit 1
    ;;
esac
