## Dockerized Armitage Teamserver
* persistent PostgreSQL database
* OpenVPN client

```yml
version: '3'
services:
  armitage:
    image: armitage
    container_name: root_armitage_1
    restart: always
    ports:
      - '2222:22'
      - '55553:55553'
    volumes:
      - "/srv/armitage/root:/root"
      - "/srv/armitage/postgres:/var/lib/postgresql/data"
      - "/srv/armitage/VPN.conf:/etc/openvpn/VPN.conf:ro"
      - "/srv/armitage/msf_config/:/usr/share/metasploit-framework/config/"
    environment:
      PASSWORD: YOUR_TEAMSERVER_PASSWORD
    cap_add:
      - NET_ADMIN
    devices:
      - "/dev/net/tun:/dev/net/tun"
    sysctls:
      net.ipv6.conf.all.disable_ipv6: 0
```
