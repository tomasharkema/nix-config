{
  lib,
  buildGoModule,
  fetchFromGitHub,
  openssl,
  # linuxPackages,
  # kernel ? linuxPackages.kernel,
}:
buildGoModule rec {
  pname = "ssh-tpm-agent";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "ssh-tpm-agent";
    rev = "v${version}";
    hash = "sha256-J9qX6DQH8hOzO+MKiehUmnmJ58/yvpvQdfNGJTXa8TI=";
  };

  # proxyVendor = true;
  doCheck = false;
  vendorHash = "sha256-Krpj0bMD+zYRutnyWYOsa30UdS6aeqHtQHiJ0UwpgE0=";

  buildInputs = [
    openssl
    # kernel
  ];

  meta = {
    description = "SSH agent with support for TPM sealed keys for public key authentication";
    homepage = "https://github.com/Foxboron/ssh-tpm-agent";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [sgo];
    mainProgram = "ssh-tpm-agent";
  };
}
