
```shell
                                                                     
% nix-build pg-config.nix
these 2 derivations will be built:
  /nix/store/a4a6wp6mfq9fkipy7b8vg0j0mlvmxkcq-pg_ident.conf.drv
  /nix/store/a6g32kp5cjxn4x9sys2bg367xbbnp0xc-postgresql-config.drv
building '/nix/store/a4a6wp6mfq9fkipy7b8vg0j0mlvmxkcq-pg_ident.conf.drv'...
building '/nix/store/a6g32kp5cjxn4x9sys2bg367xbbnp0xc-postgresql-config.drv'...
/nix/store/85hplsy0aqkavw7m1y1gss0mcjlywjqr-postgresql-config
samrose@Sams-MBP-2 pg-nix-module % tree result
result
├── pg_hba.conf
├── pg_ident.conf
└── postgresql.conf

1 directory, 3 files

pg-nix-module % cat result/p*

# TYPE  DATABASE        USER            ADDRESS                 METHOD
local all all trust
host all all 127.0.0.1/32 md5
# MAPNAME       SYSTEM-USERNAME         PG-USERNAME
map-name system-username postgres-username
# PostgreSQL configuration file
hot_standby = on
max_connections = 100
max_wal_senders = 10
shared_buffers = '128MB'
wal_level = 'replica'
```