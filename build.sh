#!/bin/bash -e

export CURR_JOB="build_microbase"
export DOCKERHUB_ORG=drydock
export IMAGE_NAME=microbase

export RES_REPO="microbase_repo"
export RES_IMAGE="microbase_img"
export RES_BASE_IMG="u14_img"

# set the drydock tag path
export RES_BASE_IMG_UP=$(echo $RES_BASE_IMG | awk '{print toupper($0)}')
export RES_BASE_IMG_VER_NAME=$(eval echo "$"$RES_BASE_IMG_UP"_VERSIONNAME")
export IMAGE_TAG=$RES_BASE_IMG_VER_NAME

# set the repo path
export RES_REPO_UP=$(echo $RES_REPO | awk '{print toupper($0)}')
export RES_REPO_STATE=$(eval echo "$"$RES_REPO_UP"_STATE")
export RES_REPO_COMMIT=$(eval echo "$"$RES_REPO_UP"_COMMIT")

set_context() {
  echo "CURR_JOB=$CURR_JOB"
  echo "DOCKERHUB_ORG=$DOCKERHUB_ORG"
  echo "IMAGE_NAME=$IMAGE_NAME"
  echo "RES_DH=$RES_DH"
  echo "RES_REPO=$RES_REPO"
  echo "RES_IMAGE=$RES_IMAGE"
  echo "RES_BASE_IMG=$RES_BASE_IMG"

  echo "RES_DH_UP=$RES_DH_UP"
  echo "RES_DH_INT_STR=$RES_DH_INT_STR"
  echo "RES_BASE_IMG_UP=$RES_BASE_IMG_UP"
  echo "RES_BASE_IMG_VER_NAME=$RES_BASE_IMG_VER_NAME"
  echo "IMAGE_TAG=$IMAGE_TAG"
  echo "RES_REPO_UP=$RES_REPO_UP"
  echo "RES_REPO_STATE=$RES_REPO_STATE"
  echo "RES_REPO_COMMIT=$RES_REPO_COMMIT"
}

build_tag_push_image() {
  pushd $RES_REPO_STATE
  echo "Starting Docker build & push for $DOCKERHUB_ORG/$IMAGE_NAME:$IMAGE_TAG"
  sed -i "s/{{%TAG%}}/$RES_BASE_IMG_VER_NAME/g" Dockerfile
  sudo docker build -t="$DOCKERHUB_ORG/$IMAGE_NAME:$IMAGE_TAG" --pull .
  sudo docker push "$DOCKERHUB_ORG/$IMAGE_NAME:$IMAGE_TAG"
  echo "Completed Docker build & push for $DOCKERHUB_ORG/$IMAGE_NAME:$IMAGE_TAG"
  popd
}

create_image_version() {
  echo "Creating a state file for" $RES_IMAGE
  echo versionName=$IMAGE_TAG > "$JOB_STATE/$RES_IMAGE.env"
  echo REPO_COMMIT_SHA=$RES_REPO_COMMIT >> "$JOB_STATE/$RES_IMAGE.env"
  cat "$JOB_STATE/$RES_IMAGE.env"
  echo "Completed creating a state file for" $RES_IMAGE
}

main() {
  set_context
  build_tag_push_image
  create_image_version
}

main
