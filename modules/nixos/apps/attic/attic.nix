{
  pkgs ? import <nixpkgs> {},
  pkgsLinux ? import <nixpkgs> {system = "x86_64-linux";},
  attic,
}: let
  config = pkgsLinux.writeTextDir "/root/server.toml" ./server.toml;
in
  pkgs.dockerTools.buildImage {
    name = "tomasharkema7/attic";

    copyToRoot =
      pkgsLinux.buildEnv
      {
        name = "attic";
        paths = [
          attic
          config
        ];
        pathsToLink = ["/bin"];
      };
    config = {
      Cmd = ["atticd" "-f" config];
      ExposedPorts = {"8080/tcp" = {};};
      Volumes = {
        "/data" = {};
      };
    };
  }
