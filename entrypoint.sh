#!/bin/bash

MSF_USER=msf
MSF_GROUP=msf
TMP=${MSF_UID:=1000}
TMP=${MSF_GID:=1000}

function create_db_conf {
    db="/usr/src/metasploit-framework/config/database.yml"
    echo "production:" > $db
    echo "  host: ${PGSQL_HOST}" >> $db
    echo "  port: ${PGSQL_PORT}" >> $db
    echo "  adapter: postgresql" >> $db
    echo "  username: ${PGSQL_USER}" >> $db
    echo "  password: ${PGSQL_PASSWORD}" >> $db
    echo "  database: ${PGSQL_DATABASE}" >> $db
}

function run {
    msf="/usr/src/metasploit-framework"
    armitage="/usr/src/armitage"
    create_db_conf
    $msf/msfconsole -r $msf/docker/msfconsole.rc -y $msf/config/database.yml
    $armitage/teamserver ${LHOST} ${TEAMSERVER_PASSWORD}
}

# if the user starts the container as root or another system user,
# don't use a low privileged user as we mount the home directory
if [ "$MSF_UID" -eq "0" ]; then
  run
else
  # if the users group already exists, create a random GID, otherwise
  # reuse it
  if ! grep ":$MSF_GID:" /etc/group > /dev/null; then
    addgroup -g $MSF_GID $MSF_GROUP
  else
    addgroup $MSF_GROUP
  fi

  # check if user id already exists
  if ! grep ":$MSF_UID:" /etc/passwd > /dev/null; then
    adduser -u $MSF_UID -D $MSF_USER -g $MSF_USER -G $MSF_GROUP $MSF_USER
    # add user to metasploit group so it can read the source
    addgroup $MSF_USER $METASPLOIT_GROUP
    su-exec $MSF_USER run
  # fall back to root exec if the user id already exists
  else
    run
  fi
fi
