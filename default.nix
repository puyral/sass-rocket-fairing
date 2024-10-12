{ rustPlatform, pkgs, src }:
let
  manifest = (pkgs.lib.importTOML "${src}/Cargo.toml").package;
  frameworks = pkgs.darwin.apple_sdk.frameworks;
in (rustPlatform.buildRustPackage {
  name = manifest.name;
  version = manifest.version;
  cargoLock.lockFile = "${src}/Cargo.lock";
  src = pkgs.lib.cleanSource src;
  patches = [ "${src}/nix.patch" ];
}).overrideAttrs
(oldAttrs: rec { # from https://stackoverflow.com/a/51161923/10875409
  buildInputs = oldAttrs.buildInputs
    ++ (if pkgs.stdenv.isDarwin then [ frameworks.CoreServices ] else [ ]);
})
