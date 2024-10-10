{ lib, pkgs }:

let
  postgresModule = import ./postgresql-module.nix { inherit lib pkgs; };
  
  # Read the JSON configuration file
  jsonConfig = builtins.fromJSON (builtins.readFile ./postgres-config.json);
  
  evaluatedConfig = (postgresModule {
    config = {
      postgresql = jsonConfig;
    };
  }).config.postgresql;
in
  pkgs.runCommand "postgresql-config" {} ''
    mkdir -p $out
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: path: 
      "cp ${path} $out/${name}"
    ) evaluatedConfig.configFiles)}
  ''
