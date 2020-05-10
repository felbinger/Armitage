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

### Environment Variables
| Name           | Description                                                                  | Default Value                                                 |
|----------------|------------------------------------------------------------------------------|---------------------------------------------------------------|
| CN             | Common Name for the certificate                                              | CommonName                                                    |
| OU             | Organizational Unit for the certificate                                      | OrganizationalUnit                                            |
| PGSQL_HOST     | PostgreSQL hostname (another container)                                      | postgres                                                      |
| PGSQL_PORT     | PostgreSQL port                                                              | 5432                                                          |
| PGSQL_USER     | PostgreSQL username                                                          | postgres                                                      |
| PGSQL_PASSWORD | PostgreSQL password (can't be empty even if authentication method is trust!) | msf                                                           |
| PGSQL_DATABASE | PostgreSQL database name                                                     | msf                                                           |
| ARMITAGE_URL   | Armitage Download URL                                                        | http://www.fastandeasyhacking.com/download/armitage150813.tgz |
|                |                                                                              |                                                               ||
