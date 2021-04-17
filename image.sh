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

function buildImage() {
  local versionPath=$1;
  local image=$2;

  echo "Building $image using Kaniko from $versionPath";
  (cd "$versionPath" && docker build -f "$versionPath"/Dockerfile "$versionPath");
#  kaniko --context "$versionPath" --dockerfile "$versionPath/Dockerfile" --no-push || exit 1;
}

function pushImage() {
  local versionPath=$1;
  local image=$2;

  echo "Building and pushing $image using Kaniko from $versionPath";
  kaniko --context "$versionPath" --dockerfile "$versionPath/Dockerfile" --destination $image
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
      buildImage $versionPath $image;
    done
  done
}

push() {
  basePath=$(realpath ./images)
  for packageDir in ./images/*/ ; do
    packagePath="$(realpath $packageDir)"
    package=${packagePath#"$basePath/"}
    for versionDir in ./images/$package/*/ ; do
      local versionPath=$(realpath $versionDir);
      local realImageVersion=${versionPath#"$basePath/$package/"};
      local gitImageVersion=$(git rev-parse --short HEAD);
      local combinedVersion=$(echo "$realImageVersion-$gitImageVersion");
      local internalImage=$(echo "containers.harderthanitneedstobe.com/$package:$combinedVersion")
      local internalImageFineVersion=$(echo "containers.harderthanitneedstobe.com/$package:$realImageVersion")
      local internalImageLatestVersion=$(echo "containers.harderthanitneedstobe.com/$package:latest")
      local githubImage=$(echo "ghcr.io/harderthanitneedstobe/build-containers/$package:$combinedVersion")
      local githubImageFineVersion=$(echo "ghcr.io/harderthanitneedstobe/build-containers/$package:$realImageVersion")
      local githubImageLatestVersion=$(echo "ghcr.io/harderthanitneedstobe/build-containers/$package:latest")
      kaniko --context "$versionPath" --dockerfile "$versionPath/Dockerfile" \
        --label org.opencontainers.image.url=https://github.com/harderthanitneedstobe/build-containers \
        --label org.opencontainers.image.source=https://github.com/harderthanitneedstobe/build-containers \
        --destination $internalImage \
        --destination $internalImageFineVersion \
        --destination $internalImageLatestVersion \
        --destination $githubImage \
        --destination $githubImageFineVersion \
        --destination $githubImageLatestVersion
    done
  done
}

$1