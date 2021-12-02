#!/bin/bash

# require environment variables
if [[ -z ${PG_HOST} ]] || [[ -z ${PG_PORT} ]] || \
   [[ -z ${PG_USER} ]] || [[ -z ${PG_PASSWORD} ]] || [[ -z ${PG_DATABASE} ]]; then
    echo "Missing postgres environment variables. Exiting..."
    exit 1
fi

if [[ -z ${ARMITAGE_PASSWORD} ]]; then
    echo "Missing teamserver environment variables. Exiting..."
    exit 1
fi

# metasploit database configuration
cat << _EOF > /usr/share/metasploit-framework/db/database.yml
production:
  host: ${PG_HOST}
  port: ${PG_PORT}
  adapter: postgresql
  username: ${PG_USER}
  password: ${PG_PASSWORD}
  database: ${PG_DATABASE}
_EOF

# armitage certificate configuration
sed -i "s/CN=Armitage Hacker/CN=${ARMITAGE_CN:-Armitage Hacker}/g" /usr/share/armitage/teamserver
sed -i "s/OU=FastAndEasyHacking/OU=${ARMITAGE_OU:-FastAndEasyHacking}/g" /usr/share/armitage/teamserver
sed -i "s/O=Armitage/O=${ARMITAGE_O:-Armitage}/g" /usr/share/armitage/teamserver
sed -i "s/L=Somewhere/L=${ARMITAGE_L:-Somewhere}/g" /usr/share/armitage/teamserver
sed -i "s/S=Cyberspace/S=${ARMITAGE_S:-Cyberspace}/g" /usr/share/armitage/teamserver
sed -i "s/C=Earth/C=${ARMITAGE_C:-Earth}/g" /usr/share/armitage/teamserver

export MSF_DATABASE_CONFIG=/usr/share/metasploit-framework/db/database.yml
teamserver ${LHOST:-$(hostname -I)} ${ARMITAGE_PASSWORD}
