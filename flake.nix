{
  description = "website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        src = ./.;
        rustPlatform = pkgs.rustPlatform;
      in rec {
        packages.sass-rocket-fairing =
          pkgs.callPackage ./default.nix { inherit rustPlatform src; };
        formatter = nixpkgs.legacyPackages.${system}.nixfmt;

        devShells.default = pkgs.mkShell {
          RUST_SRC_PATH = "${rustPlatform.rustLibSrc}";

          buildInputs = packages.default.buildInputs
            ++ (with pkgs; [ rust-analyzer nixd rustfmt clippy ]);
        };

        packages.default = packages.sass-rocket-fairing;
      });

}
