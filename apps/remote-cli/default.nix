{ pkgs, ... }:
let
  remote = ps: with ps; [
    (
      buildPythonPackage rec {
        pname = "remote";
        version = "1.13.2";
        src = pkgs.fetchFromGitHub {
          owner = "remote-cli";
          repo = "remote";
          rev = "953b22b43adaadf8bbcd845f7a11e3cffae8ac6a";
          hash = "sha256-yPiLTwToU1L9Hp/Ny7nDWUghCaqJzkh6GLVDd0N8x6g=";
        };
        doCheck = false;
        propagatedBuildInputs = with pkgs.python3Packages;[
          click
          toml
          pydantic
          watchdog
          pathtools
        ];
      }
    )
  ];
in
pkgs.python3.withPackages remote
