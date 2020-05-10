## Dockerized Armitage Teamserver
* persistent PostgreSQL database
* [OpenVPN client] - will be implemented soon
  ```yml
  openvpn:
    image: dperson/openvpn-client
    restart: always
    volumes:
      - "/srv/armitage/htb.conf:/vpn/htb.conf:ro"
    cap_add:
      - NET_ADMIN
    devices:
      - "/dev/net/tun:/dev/net/tun"
  ```
