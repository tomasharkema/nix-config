# { lib, pkgs, ... }: rec {
#   # https://github.com/ddworken/hishtory

#   hishtory = lib.stdenv.buildGoModule rec {

#     pname = "hishtory";
#     version = "0.263";

#     goPackagePath = "github.com/ddworken/hishtory";

#     allowGoReference = true;

#     src = pkgs.fetchFromGitHub {
#       owner = "ddworken";
#       repo = "hishtory";
#       rev = "v${version}";
#       hash = "sha256-aVmzrYzFws6MlUnzhz4DaCp4NWGkhKeVyeezdlaBGts=";
#     };

#     meta = with lib; {
#       description = "Simple command-line snippet manager, written in Go";
#       homepage = "https://github.com/ddworken/hishtory";
#       license = licenses.mit;
#       maintainers = with maintainers; [ tomasharkema ];
#     };

#     vendorHash = "AAAA";
#   };
# }

{ pkgs ? (
    let
      inherit (builtins) fetchTree fromJSON readFile;
      inherit ((fromJSON (readFile ./flake.lock)).nodes) nixpkgs gomod2nix;
    in
    import (fetchTree nixpkgs.locked) {
      overlays = [
        (import "${fetchTree gomod2nix.locked}/overlay.nix")
      ];
    }
  )
, buildGoApplication ? pkgs.buildGoApplication
}:

buildGoApplication rec {
  pname = "hishtory";
  version = "0.263";
  pwd = ./.;
  src = pkgs.fetchFromGitHub {
    owner = "ddworken";
    repo = "hishtory";
    rev = "v${version}";
    hash = "sha256-aVmzrYzFws6MlUnzhz4DaCp4NWGkhKeVyeezdlaBGts=";
  };
  modules = ./gomod2nix.toml;
}
