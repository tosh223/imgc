#!/bin/bash
set -e -o pipefail
is_del=false
commands=$(cat ./commands)
images=(`cat ./images`)

while getopts ":d" optKey; do
  case "$optKey" in
    d)
      is_del=true
      ;;
  esac
done

pushd `dirname $0` >/dev/null

for image in "${images[@]}"
do
    echo -------------------------------------
    echo ${image}
    echo -------------------------------------
    docker pull ${image} >/dev/null
    echo "${commands}" | docker run --rm -i ${image} /bin/bash - 
    echo

    if "${is_del}"; then
        docker rmi ${image} >/dev/null
    fi
done

popd >/dev/null
