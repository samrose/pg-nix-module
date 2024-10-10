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

  # Create the configuration files
  configFiles = pkgs.runCommand "postgresql-config-files" {} ''
    mkdir -p $out
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: path: 
      "cp ${path} $out/${name}"
    ) evaluatedConfig.configFiles)}
  '';

in
  pkgs.writeShellScriptBin "postgresql-config" ''
    mkdir -p ./postgres-config
    cp -r ${configFiles}/* ./postgres-config/
    echo "PostgreSQL configuration files have been generated in ./postgres-config/"
  ''