---
description: Various notes about my usage of ZFS/OpenZFS.
---

# ZFS Notes

In this document, replace `worldsgrave` with the name of your zpool.

## Recommended settings

### Compression

Use `lz4` compression, it's fast and efficient.

```shell
zfs set compression=lz4 worldsgrave
```

### Access Time

Turn off `atime`, it's useless.

```shell
zfs set atime=off worldsgrave
```

### De-Duplication

!!! warning "De-Duplication"
    **NEVER** use de-dupe, it's a massive performance hit.

## Scheduled Scrubing

Create the following files:

??? example "/etc/systemd/system/zfs-scrub@.service"

    ``` desktop
    [Unit]
    Description=zpool scrub on %i

    [Service]
    Nice=19
    IOSchedulingClass=idle
    KillSignal=SIGINT
    ExecStart=/usr/sbin/zpool scrub %i

    [Install]
    WantedBy=multi-user.target
    ```

??? example "/etc/systemd/system/zfs-scrub@.timer"

    ``` desktop
    [Unit]
    Description=Monthly zpool scrub on %i

    [Timer]
    OnCalendar=monthly
    AccuracySec=1h
    Persistent=true

    [Install]
    WantedBy=multi-user.target
    ```

Enable and start the new service:

```shell
systemctl daemon-reload
systemctl enable zfs-scrub@worldsgrave.timer
```

## Scheduled Snapshots

Install zrepl, see [zrepl.yaml](zfs-notes/zrepl.yaml) for reference.

## Useful Commands

### List datasets

```shell
zfs list -o type,name,available,used,logicalused,usedbysnapshots,compressratio,mountpoint
```

### List snapshots

```shell
zfs list -t snapshot
```

### Recordsize

```shell
 zfs get recordsize -t filesystem
```

### Aliases

``` shell
alias zls="zfs list -o type,name,available,used,logicalused,usedbysnapshots,compressratio,mountpoint"+
alias zsl="zfs list -t snapshot"
```
