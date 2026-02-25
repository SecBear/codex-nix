{
  description = "Nix flake for codex — OpenAI Codex CLI, an AI coding agent for your terminal";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = { pkgs, ... }:
        let
          codex = pkgs.callPackage ./package.nix { };
        in
        {
          packages = {
            default = codex;
            inherit codex;
          };

          apps.default = {
            type = "app";
            program = "${codex}/bin/codex";
          };

          devShells.default = pkgs.mkShell {
            buildInputs = [ codex ];
          };
        };

      flake = {
        overlays.default = final: _prev: {
          codex = final.callPackage ./package.nix { };
        };
      };
    };
}
