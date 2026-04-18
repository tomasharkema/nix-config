{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "purple";
  version = "2.41.1";

  src = fetchFromGitHub {
    owner = "erickochen";
    repo = "purple";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GvpP42sldWix0HWF02cK+MuAUYgY77q2qL7MkfB+7ks=";
  };

  cargoHash = "sha256-FiKny+dFepJ8zWv6uZ4gTVNYFy834PHX5FW51mx/jTo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];
  doCheck = false;
  meta = {
    description = "Open-source terminal SSH manager and SSH config editor in Rust. Fuzzy search hundreds of hosts, sync from 16 clouds, transfer files, manage Docker and Podman over SSH, sign short-lived Vault SSH certs and expose an MCP server for AI agents";
    homepage = "https://github.com/erickochen/purple";
    changelog = "https://github.com/erickochen/purple/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "purple";
  };
})
