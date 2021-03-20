#!/bin/bash

realpath() {
  OURPWD=$PWD
  cd "$(dirname "$1")"
  LINK=$(readlink "$(basename "$1")")
  while [ "$LINK" ]; do
    cd "$(dirname "$LINK")"
    LINK=$(readlink "$(basename "$1")")
  done
  REALPATH="$PWD/$(basename "$1")"
  cd "$OURPWD"
  echo "$REALPATH"
}

commandExists () {
    type "$1" &> /dev/null ;
}

build() {
  basePath=$(realpath ./images)
  for packageDir in ./images/*/ ; do
    packagePath="$(realpath $packageDir)"
    package=${packagePath#"$basePath/"}
    for versionDir in ./images/$package/*/ ; do
      local versionPath=$(realpath $versionDir);
      local realImageVersion=${versionPath#"$basePath/$package/"};
      local gitImageVersion=$(git rev-parse --short HEAD);
      local combinedVersion=$(echo "$realImageVersion-$gitImageVersion");
      local image=$(echo "containers.harderthanitneedstobe.com/$package:$combinedVersion")
      local imageFineVersion=$(echo "containers.harderthanitneedstobe.com/$package:$realImageVersion")
      buildImage $versionPath $image;
    done
  done
}

function buildImage() {
  local versionPath=$1;
  local image=$2;

  echo "Building $image using Kaniko from $versionPath";
  kaniko --context "$versionPath" --dockerfile "$versionPath/Dockerfile" --no-push
#  if commandExists kaniko; then
#    echo "Building $image using Kaniko from $versionPath";
#    kaniko --context "$versionPath" --dockerfile "$versionPath/Dockerfile" --no-push
#  else
#    echo "Building $image using Docker from $versionPath";
#    docker build -t $image -f "$versionPath/Dockerfile" $versionPath
#    docker image tag $image $image
#  fi
}

$1