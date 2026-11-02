{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = (import (inputs.nixpkgs) { inherit system; });
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            typst
            tinymist
            nodejs
          ];
        };
      }
    );
}
