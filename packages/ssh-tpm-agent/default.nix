{
  pkgs,
  lib,
  ...
}:
with pkgs;
  buildGoModule rec {
    pname = "ssh-tpm-agent";
    version = "0.5.0";

    src = fetchFromGitHub {
      owner = "Foxboron";
      repo = "ssh-tpm-agent";
      rev = "v${version}";
      hash = "sha256-J9qX6DQH8hOzO+MKiehUmnmJ58/yvpvQdfNGJTXa8TI=";
    };

    vendorHash = "sha256-Krpj0bMD+zYRutnyWYOsa30UdS6aeqHtQHiJ0UwpgE0=";

    # nativeBuildInputs = [musl];

    CGO_ENABLED = 0;

    doCheck = false;

    meta = with lib; {
      description = "ssh-tpm-agent";
      # license = licenses.lgpl21;
      # homepage = "https://github.com/cockpit-project/cockpit-machines";
      platforms = platforms.linux;
      maintainers = with maintainers; [];
    };
  }
