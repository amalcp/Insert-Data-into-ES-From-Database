#!/bin/bash -eux

set -e

# Updating and Upgrading dependencies
apt update -y > /dev/null
sudo apt install -y vim \
                    curl \
                    wget \
                    unzip \
                    apt-transport-https \
                    software-properties-common

sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update

# Install Java 
echo "Installing Java..."
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
sudo apt-get install -y oracle-java8-installer

# Set default java
sudo apt install oracle-java8-set-default

echo "Installing the Logstash..."
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt update -y && sudo apt install -y logstash

if [ $? -ne 0 ]; then
   echo "Please Confirm the Logstash installation && retry"
else
    cd /usr/share/logstash
    bin/plugin install logstash-input-jdbc
    cat > /etc/logstash/rds-es-out.conf << EOL
    input {
    jdbc {
        jdbc_connection_string => "jdbc:mysql://$RDS_End_POINT:3306/$DBName"
        jdbc_user => "$DBUSER"
        jdbc_password => "$DBPASS"
        jdbc_driver_library => "/usr/share/java/mysql-connector-java-5.1.41-bin.jar"
        jdbc_driver_class => "Java::com.mysql.jdbc.Driver"
        schedule => "*/1 * * * *"
        statement => "SELECT * FROM $TABLE"
    }
    }
    output {
        # Take this off for debugging
        # stdout { codec => "json"}
        elasticsearch {
            index => "$TABLE"
            document_type => "$TABLE"
            document_id => "%{uid}"
            hosts => "https://$ES_END_POINT:443"
        }
    }
EOL
fi        

Echo "Logstash Configuration Copleted...!!!"