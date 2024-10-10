
```shell
                                                                     
nix flake show       
warning: Git tree '/Users/samrose/pg-nix-module' is dirty
git+file:///Users/samrose/pg-nix-module
├───apps
│   ├───aarch64-darwin
│   │   └───pgConfGen: app
│   ├───aarch64-linux
│   │   └───pgConfGen: app
│   ├───x86_64-darwin
│   │   └───pgConfGen: app
│   └───x86_64-linux
│       └───pgConfGen: app
└───packages
    ├───aarch64-darwin
    │   └───pgConfGen: package 'postgresql-config-files'
    ├───aarch64-linux
    │   └───pgConfGen omitted (use '--all-systems' to show)
    ├───x86_64-darwin
    │   └───pgConfGen omitted (use '--all-systems' to show)
    └───x86_64-linux
        └───pgConfGen omitted (use '--all-systems' to show)

nix build .#pgConfGen
warning: Git tree '/Users/samrose/pg-nix-module' is dirty
samrose@Sams-MBP-2 pg-nix-module % tree result 
result
├── pg_hba.conf
├── pg_ident.conf
└── postgresql.conf


cat result/p*         
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


nix run .#pgConfGen   
warning: Git tree '/Users/samrose/pg-nix-module' is dirty
PostgreSQL configuration files have been generated in ./postgres-config/

tree postgres-config
postgres-config
├── pg_hba.conf
├── pg_ident.conf
└── postgresql.conf

1 directory, 3 files

cat postgres-config/p*
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