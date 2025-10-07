#!/bin/sh

echo "=== Parando todos os containers em execução ==="
docker ps -q | grep . && docker stop $(docker ps -q)

echo "=== Removendo todos os containers ==="
docker ps -aq | grep . && docker rm -f $(docker ps -aq)

echo "=== Listando todas as imagens do Docker ==="
docker images -a

echo "=== Removendo todas as imagens do Docker ==="
docker images -aq | grep . && docker rmi -f $(docker images -aq)

echo "=== Limpeza completa concluída ==="