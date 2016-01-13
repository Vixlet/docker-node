#!/bin/bash
set -e


###########################################
# Vixlet 'docker/node' image build script #
###########################################


# helper functions
function vdnbuild_helper_cleanup() {
  # cleanup script's runtime artifacts
  unset -v VDNBUILD_TASK
  unset -v VDNBUILD_VER
  unset -v VDNBUILD_SHVER
  unset -v VDNBUILD_TEST
  unset -v VDNBUILD_VER_LATEST
  unset -f vdnbuild_task_build
  unset -f vdnbuild_task_clean
  unset -f vdnbuild_task_stoprm
  unset -f vdnbuild_task_test
  unset -f vdnbuild_helper_cleanup
}


# trap EXIT signal and run cleanup function
trap vdnbuild_helper_cleanup EXIT


# settings
VDNBUILD_TESTS=( 1 2 )


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
# echo "VDNBUILD_TESTS=$VDNBUILD_TESTS"
# echo "VDNBUILD_TASK=$VDNBUILD_TASK"
# echo "VDNBUILD_VER=$VDNBUILD_VER"
# echo "VDNBUILD_SHVER=$VDNBUILD_SHVER"
# echo "VDNBUILD_VER_LATEST=$VDNBUILD_VER_LATEST"


# validate arguments
if [ -z "${VDNBUILD_TASK}" ]; then
  echo "build.sh error: no task specified!"
  exit 1
elif [ -z "${VDNBUILD_VER}" ]; then
  echo "build.sh error: no build version specified!"
  exit 1
fi


# task functions
function vdnbuild_task_build() {
  docker build -f "${2#*_node_}/Dockerfile" -t "vixlet/node:${1}" .
}

function vdnbuild_task_clean() {
  echo -e $(docker rmi -f "vixlet/node:${1}"; exit 0)
}

function vdnbuild_task_stoprm() {
  echo -e $(docker stop "docker-node-test"; docker rm "docker-node-test"; exit 0)
}

function vdnbuild_task_test() {
  if OUTPUT=$(cd "test/${2}" && rm -rf node_modules && VERSION="${1}" docker-compose run --rm test); then
    echo -e "$OUTPUT"
    echo "build.sh: test ${2} passed for version '${1}'!"
    return 0
  else
    echo -e "$OUTPUT"
    echo "build.sh error: test ${2} failed for version '${1}'"
    return 1
  fi
}


# run task
case "${VDNBUILD_TASK}" in
  # build, test, and tag a specific image version
  "all" )
    # cleanup
    vdnbuild_task_stoprm "${VDNBUILD_VER}" >/dev/null 2>&1
    vdnbuild_task_clean "${VDNBUILD_VER}" >/dev/null 2>&1

    # build
    vdnbuild_task_build "${VDNBUILD_VER}" "${VDNBUILD_SHVER}"

    # run tests for this version
    for i in "${VDNBUILD_TESTS[@]}"; do
      echo "build.sh: running test '${i}' for version '${VDNBUILD_VER}'"
      vdnbuild_task_test "${VDNBUILD_VER}" "${i}" || exit 2
    done
    echo -e "\nall tests passed for version '${VDNBUILD_VER}'"

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
