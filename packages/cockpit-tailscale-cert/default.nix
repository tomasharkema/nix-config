{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  tailscale,
  python3,
  systemd,
  makeWrapper,
  gnugrep,
  gawk,
  coreutils,
}:
stdenv.mkDerivation rec {
  pname = "cockpit-tailscale-cert";
  version = "unstable-2025-11-10";

  src = fetchFromGitHub {
    owner = "jiaaom";
    repo = "Cockpit-Tailscale-Cert";
    rev = "a89cd49b9b73cbb9f7a0c4dd6418ade3d34fe59f";
    hash = "sha256-8RfQ2ixPqyTwJLi0sM6cz+v2i6BPMXj/5HSBvDLOOZc=";
  };

  buildInputs = [
    makeWrapper
    python3
    tailscale
    openssl
    gnugrep
    gawk
    coreutils
  ];

  installPhase = ''
    runHook preInstall

    install -D ./renew-tailscale-cockpit-cert.sh $out/bin/renew-tailscale-cockpit-cert.sh
    chmod +x $out/bin/renew-tailscale-cockpit-cert.sh

    wrapProgram $out/bin/renew-tailscale-cockpit-cert.sh \
      --prefix PATH : "${lib.makeBinPath [
      openssl
      tailscale
      python3
      systemd
      gnugrep
      gawk
      coreutils
    ]}"

    substituteInPlace ./tailscale-cockpit-cert-renewal.service \
      --replace-fail "/usr/local/bin" "$out/bin"

    install -D ./tailscale-cockpit-cert-renewal.service $out/lib/systemd/system/tailscale-cockpit-cert-renewal.service
    install -D ./tailscale-cockpit-cert-renewal.timer $out/lib/systemd/system/tailscale-cockpit-cert-renewal.timer

    runHook postInstall
  '';

  meta = {
    description = "Automatically configure and renew Tailscale TLS certificates for Cockpit web interface on Linux systems";
    homepage = "https://github.com/jiaaom/Cockpit-Tailscale-Cert";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "cockpit-tailscale-cert";
    platforms = lib.platforms.all;
  };
}
