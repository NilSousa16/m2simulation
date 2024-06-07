#!/bin/bash

# Função para iniciar o Karaf
start_karaf() {
    echo "Iniciando Apache Karaf..."
    /opt/karaf/bin/karaf server &
    KARAF_PID=$!
}

# Função para instalar features
install_features() {
    echo "Instalando features http e webconsole..."
    # Espera o Karaf iniciar antes de instalar as features
    sleep 30
    /opt/karaf/bin/client feature:install http
    /opt/karaf/bin/client feature:install webconsole
}

# Função para parar o Karaf
stop_karaf() {
    echo "Parando Apache Karaf..."
    kill -SIGTERM $KARAF_PID
    wait $KARAF_PID
}

# Verificar se o comando foi passado para o contêiner
if [ "$#" -gt 0 ]; then
    # Se o comando for passado, executá-lo
    exec "$@"
else
    # Se nenhum comando foi passado, iniciar o Karaf e instalar as features
    trap stop_karaf SIGTERM SIGINT
    start_karaf
    # install_features
    wait
fi