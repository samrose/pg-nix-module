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
        pgConfGen = pkgs.callPackage ./pg-conf-gen.nix {};
      in {
        packages = {
          pgConfGen = pgConfGen;
        };
      }
    );
}