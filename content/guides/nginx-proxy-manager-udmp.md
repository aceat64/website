---
description: Use your UDM-Pro as an HTTP proxy for multiple sites/services.
---

# Nginx Proxy Manager on UDM-Pro

<https://nginxproxymanager.com/>

## Credits

<https://github.com/unifi-utilities/unifios-utilities/issues/149>

## Requirements

1. Setup [on-boot-script](https://github.com/unifi-utilities/unifios-utilities/blob/main/on-boot-script/README.md) from [unifi-utilities/unifios-utilities](https://github.com/boostchicken/udm-utilities).
2. Install the [container-common](https://github.com/unifi-utilities/unifios-utilities/tree/main/container-common) scripts. This will keep the container logs from growing too large.

## Setup

- In your UniFi Network controller, create `proxymanager` network (vlan 6, 10.0.6.1/24, no DHCP).
- Create directories:

    ``` shell
    mkdir -p /mnt/data/proxymanager/data /mnt/data/proxymanager/letsencrypt
    ```

- Create `/mnt/data/podman/cni/30-proxymanager.conflist` with the following:

    ??? example "30-proxymanager.conflist"

        ```json
        {
            "cniVersion": "0.4.0",
            "name": "proxymanager",
            "plugins": [
                {
                "type": "macvlan",
                "mode": "bridge",
                "master": "br6",
                "ipam": {
                    "type": "static",
                    "addresses": [
                    {
                        "address": "10.0.6.4/24",
                        "gateway": "10.0.6.1"
                    }
                    ],
                    "routes": [
                    {"dst": "0.0.0.0/0"}
                    ]
                }
                }
            ]
        }
        ```

- Create `/mnt/data/on_boot.d/20-proxymanager.sh` with the following:

    ??? example "20-proxymanager.sh"

        ``` shell
        #!/bin/sh

        ## configuration variables
        VLAN=6
        IPV4_IP="10.0.6.4"

        # This is the IP address of the container. You may want to set it to match
        # your own network structure such as 192.168.5.3 or similar
        IPV4_GW="10.0.6.1/24"

        # As above, this should match the gateway of the VLAN for the container
        # network as above which is usually the .1/24 range of the IPV4_IP
        # container name; e.g. nextdns, pihole, adguardhome, etc
        CONTAINER=proxymanager

        if ! test -f /opt/cni/bin/macvlan; then
            echo "Error: CNI plugins not found." >&2
            exit 1
        fi

        # set VLAN bridge promiscuous
        ip link set br${VLAN} promisc on

        # create macvlan bridge and add IPv4 IP
        ip link add br${VLAN}.mac link br${VLAN} type macvlan mode bridge
        ip addr add ${IPV4_GW} dev br${VLAN}.mac noprefixroute

        # (optional) add IPv6 IP to VLAN bridge macvlan bridge
        if [ -n "${IPV6_GW}" ]; then
            ip -6 addr add ${IPV6_GW} dev br${VLAN}.mac noprefixroute
        fi

        # set macvlan bridge promiscuous and bring it up
        ip link set br${VLAN}.mac promisc on
        ip link set br${VLAN}.mac up

        # add IPv4 route to DNS container
        ip route add ${IPV4_IP}/32 dev br${VLAN}.mac

        # (optional) add IPv6 route to container
        if [ -n "${IPV6_IP}" ]; then
            ip -6 route add ${IPV6_IP}/128 dev br${VLAN}.mac
        fi

        if podman container exists ${CONTAINER}; then
            podman start ${CONTAINER}
        else
            logger -s -t podman-dns -p ERROR Container $CONTAINER not found, make sure you set the proper name, you can ignore this error if it is your first time setting it up
        fi
        ```

- Run the following commands:

    ``` shell
    chmod +x /mnt/data/on_boot.d/20-proxymanager.sh
    /mnt/data/on_boot.d/20-proxymanager.sh
    /mnt/data/on_boot.d/05-install-cni-plugins.sh
    ```

- Start NPM:

    ```shell
    podman run -d \
    --systemd=false \
    --network proxymanager \
    --name proxymanager \
    -e TZ=America/Chicago \
    -e DB_SQLITE_FILE="/data/database.sqlite" \
    -v "/mnt/data/proxymanager/data:/data" \
    -v "/mnt/data/proxymanager/letsencrypt:/etc/letsencrypt" \
    jc21/nginx-proxy-manager:latest
    ```

If everything worked the Nginx Proxy Manager interface should be available at <http://10.0.6.4:81>

Default Admin User:

```text
admin@example.com
```

Default Admin Password:

```text
changeme
```
