# Use uma imagem base que tenha o Java pré-instalado
FROM openjdk:11-jre-slim

# Defina variáveis de ambiente
ENV KARAF_VERSION=4.4.6
ENV KARAF_HOME=/opt/karaf
ENV PATH=$KARAF_HOME/bin:$PATH

# Baixe e instale o Apache Karaf
RUN apt-get update && apt-get install -y wget && \
    wget https://archive.apache.org/dist/karaf/${KARAF_VERSION}/apache-karaf-${KARAF_VERSION}.tar.gz && \
    tar -xzf apache-karaf-${KARAF_VERSION}.tar.gz && \
    mv apache-karaf-${KARAF_VERSION} $KARAF_HOME && \
    rm apache-karaf-${KARAF_VERSION}.tar.gz && \
    apt-get remove -y wget && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Exponha a porta padrão do Karaf
EXPOSE 8181

# Defina o ponto de entrada
ENTRYPOINT ["karaf"]