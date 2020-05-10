FROM metasploitframework/metasploit-framework

# teamserver certificate information
ENV CN CommonName
ENV OU OrganisationUnit

# PostgreSQL configuration
ENV PGSQL_HOST postgres
ENV PGSQL_PORT 5432
ENV PGSQL_USER postgres
ENV PGSQL_PASSWORD msf
ENV PGSQL_DATABASE msf

# install armitage
ENV ARMITAGE_URL "http://www.fastandeasyhacking.com/download/armitage150813.tgz"
RUN wget -O- ${ARMITAGE_URL} | tar -xzf - -C /usr/src/ \
 && apk update \
 && apk add openjdk8=8.242.08-r0 \
 && ln -s /usr/src/metasploit-framework/msfrpcd /usr/local/bin/ \
 && ln -s /usr/src/armitage/teamserver /usr/local/bin/ \
 && sed -i "s|armitage.jar|/usr/src/armitage/armitage.jar|g" /usr/src/armitage/teamserver

# disconnect from database and quit from msfconsole to enable teamserver start
RUN sed -i '/db_connect.*/i run_single("db_disconnect")' /usr/src/metasploit-framework/docker/msfconsole.rc \
 && sed -i '/db_connect.*/a run_single("quit")' /usr/src/metasploit-framework/docker/msfconsole.rc

# configure armitage
RUN sed -i "s/CN=Armitage Hacker/CN=${CN}/g" /usr/src/armitage/teamserver \
 && sed -i "s/OU=FastAndEasyHacking/OU=${OU}/g" /usr/src/armitage/teamserver

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
