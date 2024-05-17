# m2simulation

# Utilizar versão apache/karaf:4.4.4 do docker hub

Ete documento descreve os passos necessário para baixar a imagem docker do apache Karaf 4.4.4, criar um conteiner baseado na imagem e realizar a configuração básica para acesso ao console do karaf via terminal e ao webconsole via browser. Para isso é necessário executar os comandos a seguir na ordem apresentada.

## Baixando imagem

Comando responsável por realizar o download da imagem docker do dockerhub.

    docker pull apache/karaf:4.4.4

## Criando container

Comando responsável por criar o container baseado na imagem do karaf e mapear a porta 8181 do container com a porta 8181 da máquina física.

    docker run -d --name karaf-container -p 8181:8181 apache/karaf:4.4.4

## Acessando o container

Responsável por abrir uma sessão de terminal interativa dentro de um contêiner Docker em execução, o que permite realizar modificações e configurações. 

    docker exec -it karaf-container /bin/sh

## Acessando árvore de arquivos

O comando abaixo permite acessar os arquivos do usuário root do container

    su

## Configurando o arquivo de senhas 

Está configuração é responsável por definir o usuário e senha padrão do karaf, caso seja omitida, não será possível realizar o acesso ao console do karaf.
    
    sed -i 's/^#karaf = karaf,_g_:admingroup/karaf = karaf,_g_:admingroup/' $KARAF_HOME/etc/users.properties
    sed -i 's/^#_g_\\:admingroup = group,admin,manager,viewer,systembundles,ssh/_g_\\:admingroup = group,admin,manager,viewer,systembundles,ssh/' $KARAF_HOME/etc/users.properties

## Acessando o console do karaf

Após as configurações é recomendável reiniciar o container antes de tentar acessar o console do karaf. A sequência de comandos abaixo é usada para reiniciar/acessar o container e abrir o console do karaf

    Ctrl + D // Sair do modo de acesso a árvore de arquivos
    Ctrl + D // Sair do modo exec
    docker container restart <nome do container> // reinicia o container
    docker exec -it karaf-container /bin/sh // acessa o container via terminal
    client || karaf || run // possíveis comando para abrir o console do karaf, utilize o usuário karaf e senha karaf caso seja solicitado

## Configurando o web console

Para instalar o webconsole será necessário executar os comandos abaixo dentro do console do karaf.

    feature:install http
    feature:install webconsole

Logo em seguida utilize o endereço abaixo no browser para acessar o webconsole. Caso seja solicitado, utilize "karaf" como usuário e senha.

    http://localhost:8181/system/console/bundles





