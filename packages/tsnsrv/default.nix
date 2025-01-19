{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "tsnsrv";
  version = "unstable-2025-01-15";

  src = fetchFromGitHub {
    owner = "boinkor-net";
    repo = "tsnsrv";
    rev = "363670cb45481b74922f87d9ce3a050179d62f34";
    hash = "sha256-LIIPfHtF8c2kgFWEXWvR02ZiRBNYnDXvv4BSmoV0guc=";
  };

  vendorHash = "sha256-JXTq8hnJ6/TdUvm9MnBiLif4K/fwyRq5VDNr3sKsm54=";

  ldflags = ["-s" "-w"];

  meta = {
    description = "A reverse proxy that exposes services on your tailnet (as their own tailscale participants";
    homepage = "https://github.com/boinkor-net/tsnsrv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "tsnsrv";
  };
}
