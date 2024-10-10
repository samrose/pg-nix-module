{
  description = "PostgreSQL configuration generator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        postgresModule = import ./postgresql-module.nix { inherit (pkgs) lib pkgs; };
        
        pgConfigGenerator = pkgs.writeShellApplication {
          name = "pg-config-generator";
          runtimeInputs = [ pkgs.jq ];
          text = ''
            if [ ! -f "$1" ]; then
              echo "Usage: pg-config-generator <path-to-config.json>"
              exit 1
            fi
            
            config_file="$1"
            json_config=$(cat "$config_file")
            
            ${pkgs.lib.concatStringsSep "\n" (pkgs.lib.mapAttrsToList (name: path: 
              "cp ${path} ./${name}"
            ) (postgresModule {
              config.postgresql = builtins.fromJSON "''${json_config}";
            }).config.postgresql.configFiles)}
            
            echo "PostgreSQL configuration files generated."
          '';
        };

      in {
        packages.default = pgConfigGenerator;

        apps.default = flake-utils.lib.mkApp { drv = pgConfigGenerator; };
      }
    );
}