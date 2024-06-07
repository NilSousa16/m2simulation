# Usar uma imagem base do OpenJDK
FROM openjdk:11-jre-slim

# Definir variáveis de ambiente
ENV KARAF_VERSION=4.4.4
ENV KARAF_HOME=/opt/karaf

# Instalar dependências necessárias
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean

# Baixar e instalar Apache Karaf
RUN echo "Executando comandos de instalação e configuração do karaf..." && \
    wget https://archive.apache.org/dist/karaf/${KARAF_VERSION}/apache-karaf-${KARAF_VERSION}.tar.gz -O /tmp/karaf.tar.gz && \
    mkdir -p ${KARAF_HOME} && \
    tar -xzf /tmp/karaf.tar.gz -C ${KARAF_HOME} --strip-components=1 && \
    rm /tmp/karaf.tar.gz

# Executar comandos adicionais uma vez durante a construção
RUN echo "Executando comandos para configuração do usuário padrão..." && \
    sed -i 's/^#karaf = karaf,_g_:admingroup/karaf = karaf,_g_:admingroup/' /opt/karaf/etc/users.properties && \
    sed -i 's/^#_g_\\:admingroup = group,admin,manager,viewer,systembundles,ssh/_g_\\:admingroup = group,admin,manager,viewer,systembundles,ssh/' ${KARAF_HOME}/etc/users.properties

# Executa a instalação do http e webconsole (manter a formatação das configurações)
RUN echo "Executando comandos para instalação das features http e webconsole..." && \
    sed -i 's/kar\/4.4.4/&\, \\\n    http, \\\n    webconsole/' ${KARAF_HOME}/etc/org.apache.karaf.features.cfg

# Copiar o script de inicialização para dentro do contêiner
COPY docker-entrypoint.sh /usr/local/bin/

# Definir permissão de execução para o script de entrada
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Definir o diretório de trabalho
WORKDIR ${KARAF_HOME}

# Expor as portas necessárias
EXPOSE 8101 8181 44444

# Definir o ponto de entrada
ENTRYPOINT ["docker-entrypoint.sh"]
