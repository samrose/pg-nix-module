{ lib, pkgs }:

{ config, ... }:

with lib;

let
  cfg = config.postgresql;

  postgresqlConf = pkgs.writeText "postgresql.conf" ''
    # PostgreSQL configuration file
    ${concatStringsSep "\n" (mapAttrsToList (name: value:
      "${name} = ${if isBool value then (if value then "on" else "off")
                   else if isString value then "'${value}'"
                   else toString value}"
    ) cfg.settings)}
  '';

  pgHbaConf = pkgs.writeText "pg_hba.conf" ''
    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    ${concatStringsSep "\n" cfg.authentication}
  '';

  pgIdentConf = pkgs.writeText "pg_ident.conf" ''
    # MAPNAME       SYSTEM-USERNAME         PG-USERNAME
    ${concatStringsSep "\n" (cfg.identMap or [])}
  '';

in {
  options.postgresql = {
    settings = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      description = "PostgreSQL configuration settings";
    };

    authentication = mkOption {
      type = types.listOf types.str;
      default = [
        "local all all trust"
        "host all all 127.0.0.1/32 trust"
        "host all all ::1/128 trust"
      ];
      description = "PostgreSQL client authentication configuration";
    };

    identMap = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = "PostgreSQL user name maps";
    };
  };

  config = {
    postgresql.settings = mkMerge [
      {
        # Default settings
        hba_file = "${pgHbaConf}";
        ident_file = "${pgIdentConf}";
        log_destination = "stderr";
        logging_collector = true;
      }
      cfg.settings
    ];

    # Output the generated configuration files
    postgresql.configFiles = {
      "postgresql.conf" = postgresqlConf;
      "pg_hba.conf" = pgHbaConf;
      "pg_ident.conf" = pgIdentConf;
    };
  };
}
