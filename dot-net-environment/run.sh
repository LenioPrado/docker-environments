#!/bin/bash
COMPOSE_FILES_DIR=~/Documents/dot-net-environment/compose-files
COMPOSE_FILES_SERVICES_DIR=$COMPOSE_FILES_DIR/services
COMPOSE_FILES_DAEMONS_DIR=$COMPOSE_FILES_DIR/daemons

composefiles=""

echo "---------- Services ----------"
for composefile in $COMPOSE_FILES_SERVICES_DIR/*-compose.yaml; do
  composefiles="$composefiles -f $composefile"
done

docker compose $composefiles up -d --build

for composefile in $COMPOSE_FILES_SERVICES_DIR/*-compose.yaml; do
  projectname=$(basename "$composefile" "-compose.yaml")
  echo "Efetuando compose do arquivo: $composefile (projeto: $projectname)"

  docker compose -p "$projectname" -f "$composefile" up -d --build
done
