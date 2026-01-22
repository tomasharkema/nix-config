{
  lib,
  stdenv,
  fetchurl,
  gettext,
}:
stdenv.mkDerivation rec {
  pname = "cockpit-dockermanager";
  version = "1.0.7.2";

  src = fetchurl {
    url = "https://github.com/chrisjbawden/cockpit-dockermanager/raw/refs/tags/v${version}/dockermanager.tar";
    sha256 = "sha256-UPYBdKe5uJZJLmjNl9mEPDZt9C4f8zH9Sh1vaJxVcN8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/cockpit/dockermanager"
    tar -xf "$src" -C "$out/share/cockpit/dockermanager"

    runHook postInstall
  '';

  dontUnpack = true;
  dontBuild = true;

  meta = {
    description = "Cockpit UI for tailscale containers";
    license = lib.licenses.lgpl21;
    homepage = "https://github.com/spotsnel/cockpit-tailscale";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [];
  };
}
