let
  pkgs = import <nixpkgs> {
    localSystem = {
      gcc.arch = "skylake";
      gcc.tune = "skylake";
      system = "x86_64-linux";
    };
  };
in
  pkgs.openssl
