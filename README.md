## Dockerized Armitage Teamserver

# docker-compose.yml
## Standalone
```yaml
version: '3'
services:
  postgres:
    image: postgres:latest
    restart: always
    environment:
      - "POSTGRES_HOST_AUTH_METHOD=trust"
      - "POSTGRES_DB=msf"
    volumes:
      - "postgres-data:/var/lib/postgresql/data:Z"

  armitage:
    image: ghcr.io/felbinger/armitage
    restart: always
    depends_on:
      - postgres
    ports:
      - "4000-4100:4000-4100"         # exploitation ports
      - "55553:55553"                 # teamserver ports
    environment:
      - "LHOST=123.123.123.123"       # your external ip, required for teamserver start, default is container ip
      - "ARMITAGE_PASSWORD=secret"    # password for the teamserver

volumes:
  postgres-data:
```

## with OpenVPN
```yaml
version: '3'
services:
  postgres:
    image: postgres:latest
    restart: always
    environment:
      - "POSTGRES_HOST_AUTH_METHOD=trust"
      - "POSTGRES_DB=msf"
    volumes:
      - "postgres-data:/var/lib/postgresql/data:Z"

  armitage:
    image: ghcr.io/felbinger/armitage
    restart: always
    depends_on:
      - postgres
    network_mode: service:openvpn
    environment:
      - "LHOST=123.123.123.123"       # your external ip, required for teamserver start, default is container ip
      - "ARMITAGE_PASSWORD=secret"    # password for the teamserver

  openvpn:
    image: dperson/openvpn-client
    restart: always
    ports:
      - "55553:55553"                 # teamserver port
    volumes:
      - "./hackthebox.ovpn:/vpn/htb.conf:ro"
    cap_add:
      - "NET_ADMIN"
    devices:
      - "/dev/net/tun:/dev/net/tun"
    sysctls:
      - "net.ipv6.conf.all.disable_ipv6=0"    # I couldn't get it working with ipv6 support yet...


volumes:
  postgres-data:
```

# Environment Variables
|        Name       |                                  Description                                 |    Default Value   |
|:------------------|:-----------------------------------------------------------------------------|:-------------------|
| PG_HOST           | PostgreSQL hostname (another container)                                      | postgres           |
| PG_PORT           | PostgreSQL port                                                              | 5432               |
| PG_USER           | PostgreSQL username                                                          | postgres           |
| PG_PASSWORD       | PostgreSQL password (can't be empty even if authentication method is trust!) | msf                |
| PG_DATABASE       | PostgreSQL database name                                                     | msf                |
| ARMITAGE_CN       | X.509 Common Name                                                            | Armitage Hacker    |
| ARMITAGE_OU       | X.509 Organizational Unit                                                    | FastAndEasyHacking |
| ARMITAGE_O        | X.509 Organization Name                                                      | Armitage           |
| ARMITAGE_L        | X.509 Locality                                                               | Somewhere          |
| ARMITAGE_S        | X.509 State                                                                  | Cyberspace         |
| ARMITAGE_C        | X.509 Country                                                                | Earth              |
| ARMITAGE_PASSWORD | Teamserver Password                                                          |                    |

# TODO
* postgres password authentication (without trust) does not work.
* ipv6 vpn support
