#!/bin/bash

# Function to start Karaf
start_karaf() {
    echo "Starting Apache Karaf..."
    /opt/karaf/bin/karaf server &
    KARAF_PID=$!
}

# Function to install features
install_features() {
    echo "Installing http and webconsole features..."
    # Wait for Karaf to start before installing the features
    sleep 30
    /opt/karaf/bin/client feature:install http
    /opt/karaf/bin/client feature:install webconsole
}

# Function to install the bundle
install_bundle() {
    echo "Installing the local bundle..."
    /opt/karaf/bin/client bundle:install file:/opt/karaf/deploy/m2model-1.0.0.jar
    /opt/karaf/bin/client bundle:start file:/opt/karaf/deploy/m2model-1.0.0.jar

    # Bundle requested by m2mqtt
    /opt/karaf/bin/client bundle:install mvn:org.apache.aries.blueprint/org.apache.aries.blueprint.core/1.10.3
    /opt/karaf/bin/client bundle:start mvn:org.apache.aries.blueprint/org.apache.aries.blueprint.core/1.10.3

    # Bundle requested by mqtt communication
    /opt/karaf/bin/client bundle:install mvn:org.eclipse.paho/org.eclipse.paho.client.mqttv3/1.2.0
    /opt/karaf/bin/client bundle:start mvn:org.eclipse.paho/org.eclipse.paho.client.mqttv3/1.2.0

    # Bundle required for json conversion
    /opt/karaf/bin/client bundle:install mvn:com.google.code.gson/gson/2.11.0
    /opt/karaf/bin/client bundle:start mvn:com.google.code.gson/gson/2.11.0

    # Bundle for gateways simulation
    /opt/karaf/bin/client bundle:install file:/opt/karaf/deploy/m2client-1.0.0.jar
    /opt/karaf/bin/client bundle:start file:/opt/karaf/deploy/m2client-1.0.0.jar

    # Bundle required for m2client
    /opt/karaf/bin/client bundle:install mvn:org.apache.servicemix.bundles/org.apache.servicemix.bundles.commons-httpclient/3.1_7
    /opt/karaf/bin/client bundle:start mvn:org.apache.servicemix.bundles/org.apache.servicemix.bundles.commons-httpclient/3.1_7
}

# Function to stop Karaf
stop_karaf() {
    echo "Stopping Apache Karaf..."
    kill -SIGTERM $KARAF_PID
    wait $KARAF_PID
}

# Check if the command was passed to the container
if [ "$#" -gt 0 ]; then
    # If the command is passed, execute it
    exec "$@"
else
    # If no command was passed, start Karaf and install the features
    trap stop_karaf SIGTERM SIGINT
    start_karaf
    # install_features
    install_bundle
    wait
fi