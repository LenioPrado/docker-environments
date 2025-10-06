#!/bin/bash

# Diretório onde estão os arquivos compose
COMPOSE_DIR="/home/lenio/Documents/dot-net-environment/compose-files/services"

compose_files_concat() {
    local selected_services=("$@")
    local compose_files=""

    for svc in "${selected_services[@]}"; do
        compose_files+="-f $COMPOSE_DIR/$svc-compose.yaml "
    done

    echo "$compose_files"
}

# Função que lista os nomes baseados no padrão *-compose.yaml
list_services() {
    find "$COMPOSE_DIR" -maxdepth 1 -type f -name "*-compose.yaml" \
        | sed -E 's#.*/([^/]+)-compose\.yaml#\1#' \
        | sort
}

start_all() {
    services=($(list_services))
    compose_files=$(compose_files_concat "${services[@]}")
    echo "🚀 Iniciando todos os serviços..."
    docker compose $compose_files up -d --remove-orphans
}

start_selecting() {
    services=($(list_services))
    echo "=== Serviços disponíveis ==="
    i=1
    for s in "${services[@]}"; do
        echo "$i) $s"
        ((i++))
    done
    echo "============================"
    read -p "Digite os números dos serviços a iniciar (ex: 1 3 5): " selections

    selected_services=()
    for num in $selections; do
        svc="${services[$((num-1))]}"
        [ -n "$svc" ] && selected_services+=("$svc")
    done

    if [ ${#selected_services[@]} -eq 0 ]; then
        echo "⚠️ Nenhum serviço selecionado."
        return
    fi

    compose_files=$(compose_files_concat "${selected_services[@]}")
    echo "🚀 Iniciando serviços selecionados: ${selected_services[*]}"
    docker compose $compose_files up -d --remove-orphans
}

build_all() {
    services=($(list_services))
    compose_files=$(compose_files_concat "${services[@]}")
    echo "🔨 Buildando todos os serviços..."
    docker compose $compose_files build
}

build_selecting() {
    services=($(list_services))
    echo "=== Serviços disponíveis ==="
    i=1
    for s in "${services[@]}"; do
        echo "$i) $s"
        ((i++))
    done
    echo "============================"
    read -p "Digite os números dos serviços para build (ex: 1 3 4): " selections

    selected_services=()
    for num in $selections; do
        svc="${services[$((num-1))]}"
        [ -n "$svc" ] && selected_services+=("$svc")
    done

    if [ ${#selected_services[@]} -eq 0 ]; then
        echo "⚠️ Nenhum serviço selecionado."
        return
    fi

    compose_files=$(compose_files_concat "${selected_services[@]}")
    echo "🔨 Buildando serviços selecionados: ${selected_services[*]}"
    docker compose $compose_files build
}

stop_all() {
    services=($(list_services))
    compose_files=$(compose_files_concat "${services[@]}")
    echo "🛑 Parando todos os serviços..."
    docker compose $compose_files down
}

stop_selecting() {
    services=($(list_services))
    echo "=== Serviços disponíveis ==="
    i=1
    for s in "${services[@]}"; do
        echo "$i) $s"
        ((i++))
    done
    echo "============================"
    read -p "Digite os números dos serviços para parar (ex: 2 4): " selections

    selected_services=()
    for num in $selections; do
        svc="${services[$((num-1))]}"
        [ -n "$svc" ] && selected_services+=("$svc")
    done

    if [ ${#selected_services[@]} -eq 0 ]; then
        echo "⚠️ Nenhum serviço selecionado."
        return
    fi

    compose_files=$(compose_files_concat "${selected_services[@]}")
    echo "🛑 Parando serviços selecionados: ${selected_services[*]}"
    docker compose $compose_files down
}

# Menu principal
while true; do
    echo "=============================="
    echo "  MENU DE OPERAÇÕES DOCKER"
    echo "=============================="
    echo "1) startAll"
    echo "2) startSelecting"
    echo "3) buildAll"
    echo "4) buildSelecting"
    echo "5) stopAll"
    echo "6) stopSelecting"
    echo "0) Sair"
    echo "=============================="
    read -p "Escolha uma opção: " opt

    case $opt in
        1) start_all ;;
        2) start_selecting ;;
        3) build_all ;;
        4) build_selecting ;;
        5) stop_all ;;
        6) stop_selecting ;;
        0) echo "Saindo..."; exit 0 ;;
        *) echo "Opção inválida!" ;;
    esac
done
