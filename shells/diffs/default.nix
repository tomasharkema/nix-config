{pkgs, ...}: {
  packages-json = pkgs.writeShellScriptBin "packages-json" ./packages-json.sh;
}
