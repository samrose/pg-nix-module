{ pkgs ? import <nixpkgs> {} }:

let
  postgresModule = import ./postgresql-module.nix { inherit (pkgs) lib pkgs; };
  inherit (pkgs.lib) concatStringsSep mapAttrsToList;
  
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
    ${concatStringsSep "\n" (mapAttrsToList (name: path: 
      "cp ${path} $out/${name}"
    ) evaluatedConfig.configFiles)}
  ''