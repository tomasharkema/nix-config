{
  lib,
  buildGoModule,
  fetchFromGitHub,
  openssl,
  pkg-config,
  linuxPackages,
  kernel ? linuxPackages.kernel,
}:
buildGoModule rec {
  pname = "ssh-tpm-agent";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "ssh-tpm-agent";
    rev = "v${version}";
    hash = "sha256-CSxZctiQ/d4gzCUtfx9Oetb8s0XpHf3MPH/H0XaaVgg=";
  };

  # proxyVendor = true;
  doCheck = false;
  env.CGO_ENABLED = 0;

  vendorHash = "sha256-e5gnlQX/tfuWhEYKVCcl96EwhvfoaldLLta0Fo2Y2gs=";

  nativeBuildInputs = [kernel pkg-config];

  buildInputs = [
    openssl
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
