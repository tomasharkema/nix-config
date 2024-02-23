{
  pkgs,
  config,
  lib,
  ...
}:
# let
# hishtory = pkgs.hishtory.override { version = "0.263"; };
# hishtory =
# pkgs.callPackage
# (
# {
#   buildGoModule,
#   fetchFromGitHub,
#   lib,
# }:
with lib;
with pkgs;
  buildGoModule
  rec {
    pname = "hishtory";
    version = "0.277";

    src = fetchFromGitHub {
      owner = "ddworken";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-Gb2E9IlXU+3WuEDIh/McwoHPEUqVAxMeaGVmers5Hvw=";
    };

    vendorHash = "sha256-qWKLYGDbL5LL3CjD2yz9CjwAM6lL9Pjnbk+ERCmW94c=";
    ldflags = [" -X github.com/ddworken/hishtory/client/lib.Version=${version}"];

    excludedPackages = ["backend/server" "client"];

    postInstall = ''
      mkdir -p $out/share/hishtory
      cp client/lib/config.* $out/share/hishtory
    '';

    doCheck = false;

    meta = {
      description = "Your shell history: synced, queryable, and in context";
      homepage = "https://github.com/ddworken/hishtory";
      license = licenses.mit;
      maintainers = ["tomasharkema" "tomas@harkema.io"];
    };
  }
