{
  stdenv,
  lib,
  autoPatchelfHook,
  glibc,
  libgcc,
  webkitgtk,
  glib,
  gobject-introspection,
  fetchzip,
  gtk3,
}:
# nix-prefetch-url "https://github.com/mattermost-community/focalboard/releases/download/v7.10.6/focalboard-linux.tar.gz" --unpack
stdenv.mkDerivation rec {
  pname = "focalboard";
  version = "7.10.6";

  src = fetchzip {
    url = "https://github.com/mattermost-community/focalboard/releases/download/v${version}/focalboard-linux.tar.gz";
    sha256 = "1ld3apdh6dg7v7xhkvd6944lf29lmzfak1d7h33mq5yd8z9dgka4";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    glibc
    libgcc
    webkitgtk
    glib
    gobject-introspection
    gtk3
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 755 focalboard-app $out/bin/focalboard

    runHook postInstall
  '';
}
