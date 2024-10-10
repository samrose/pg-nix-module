{ pkgs ? import <nixpkgs> {} }:

let
  postgresModule = import ./postgresql-module.nix { inherit (pkgs) lib pkgs; };
  inherit (pkgs.lib) concatStringsSep mapAttrsToList;
  evaluatedConfig = (postgresModule {
    config = {
      postgresql = {
        settings = {
          max_connections = 100;
          shared_buffers = "128MB";
          wal_level = "replica";
          max_wal_senders = 10;
          hot_standby = true;
        };
        authentication = [
          "local all all trust"
          "host all all 127.0.0.1/32 md5"
        ];
        # You can add identMap entries here if needed
        # identMap = [
        #   "map-name system-username postgres-username"
        # ];
      };
    };
  }).config.postgresql;
in
  pkgs.runCommand "postgresql-config" {} ''
    mkdir -p $out
    ${concatStringsSep "\n" (mapAttrsToList (name: path: 
      "cp ${path} $out/${name}"
    ) evaluatedConfig.configFiles)}
  ''
