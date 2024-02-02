FROM nixos/nix

WORKDIR /root

COPY flake.* .

RUN nix build --extra-experimental-features 'nix-command flakes' '.#nixConfigurations.hydra-docker.config.system.build.toplevel'