ARG CN=common_name
ARG OU=organisation_unit

FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV PASSWORD teamserver_default_password

RUN apt-get update \
 && apt-get install -y postgresql metasploit-framework armitage openvpn supervisor apt-utils

RUN mkdir -p /var/log/supervisor \
 && mkdir -p /etc/supervisor/conf.d

RUN sed -i 's/CN=Armitage Hacker/CN=${CN}/g' /usr/share/armitage/teamserver
RUN sed -i 's/OU=FastAndEasyHacking/OU=${OU}/g' /usr/share/armitage/teamserver

# autoconnect to vpn (.conf files in /etc/openvpn)
RUN sed -i 's/#AUTOSTART="all"/AUTOSTART="all"/g' /etc/default/openvpn

# install additional software
RUN apt-get update \
 && apt-get install -y gdb gcc g++ python3.6 python2.7 php7.2 sqlmap gobuster dirbuster dirb nmap curl wget vim nano screen tmux openssh-server \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# allow ssh root login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# change password of root
RUN echo "root:YOUR_ROOT_PASSWORD" | chpasswd

# get wordlists
RUN mkdir -p /wordlists && \
    wget -O- http://downloads.skullsecurity.org/passwords/rockyou.txt.bz2 | bunzip2 > /wordlists/rockyou.txt&& \
    wget -O- http://downloads.skullsecurity.org/passwords/500-worst-passwords.txt.bz2 | bunzip2 > /wordlists/500-worst-passwords.txt && \
    wget -O- http://downloads.skullsecurity.org/passwords/twitter-banned.txt.bz2 | bunzip2 > /wordlists/twitter-banned.txt && \
    wget https://raw.githubusercontent.com/diasdavid/node-dirbuster/master/lists/directory-list-1.0.txt -O /wordlists/directory-list-1.0.txt && \
    wget https://raw.githubusercontent.com/diasdavid/node-dirbuster/master/lists/directory-list-lowercase-2.3-small.txt -O /wordlists/directory-list-lowercase-2.3-small.txt && \
    wget https://raw.githubusercontent.com/diasdavid/node-dirbuster/master/lists/directory-list-lowercase-2.3-medium.txt -O /wordlists/directory-list-lowercase-2.3-medium.txt && \
    wget https://raw.githubusercontent.com/diasdavid/node-dirbuster/master/lists/directory-list-lowercase-2.3-big.txt -O /wordlists/directory-list-lowercase-2.3-big.txt && \
    wget https://raw.githubusercontent.com/diasdavid/node-dirbuster/master/lists/directory-list-2.3-small.txt -O /wordlists/directory-list-2.3-small.txt && \
    wget https://raw.githubusercontent.com/diasdavid/node-dirbuster/master/lists/directory-list-2.3-medium.txt -O /wordlists/directory-list-2.3-medium.txt && \
    wget https://raw.githubusercontent.com/diasdavid/node-dirbuster/master/lists/directory-list-2.3-big.txt -O /wordlists/directory-list-2.3-big.txt && \
    wget https://raw.githubusercontent.com/diasdavid/node-dirbuster/master/lists/apache-user-enum-1.0.txt -O /wordlists/apache-user-enum-1.0.txt && \
    wget https://raw.githubusercontent.com/diasdavid/node-dirbuster/master/lists/apache-user-enum-2.0.txt -O /wordlists/apache-user-enum-2.0.txt


WORKDIR $HOME

ADD supervisor.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
