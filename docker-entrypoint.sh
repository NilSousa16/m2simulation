#!/bin/bash

# Iniciar o Apache Karaf
${KARAF_HOME}/bin/start

# Aguardar a inicialização
sleep 30

# Instalar as features
${KARAF_HOME}/bin/client feature:install http
${KARAF_HOME}/bin/client feature:install webconsole

# Executar o Karaf
exec "${KARAF_HOME}/bin/karaf" "$@"
