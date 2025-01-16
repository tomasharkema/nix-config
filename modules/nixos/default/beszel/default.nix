{
  pkgs,
  config,
  lib,
  ...
}: {
  config = {
    virtualisation.oci-containers.containers = {
      beszel-agent = {
        image = "henrygd/beszel-agent";

        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock:ro"
        ];

        extraOptions = [
          "--privileged"
          "--net=host"
        ];

        environment = {
          PORT = "45876";
          KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH1dOnPIMt4jFOCSoawrp8FbGS6qs4+ujBk//6IRhdwT";
        };

        autoStart = true;
      };
    };

    # services:
    #   beszel-agent:
    #     image: "henrygd/beszel-agent"
    #     container_name: "beszel-agent"
    #     restart: unless-stopped
    #     network_mode: host
    #     volumes:
    #       - /var/run/docker.sock:/var/run/docker.sock:ro
    #       # monitor other disks / partitions by mounting a folder in /extra-filesystems
    #       # - /mnt/disk/.beszel:/extra-filesystems/sda1:ro
    #     environment:
    #       PORT: 45876
    #       KEY: "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH1dOnPIMt4jFOCSoawrp8FbGS6qs4+ujBk//6IRhdwT"
  };
}
