FROM nixos/nix

WORKDIR /root

RUN nix profile install github:zhaofengli/attic --verbose \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes

COPY server.toml .

CMD [ "atticd", "-f", "server.toml" ]