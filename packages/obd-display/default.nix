{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glib,
  glibc,
  gtk2,
  gobject-introspection,
  wrapGAppsHook,
}:
stdenv.mkDerivation rec {
  pname = "obd-display";
  version = "unstable-2019-08-28";

  src = fetchFromGitHub {
    owner = "MHS-Elektronik";
    repo = "OBD-Display";
    rev = "c5bf7151633ed7396d7fafcfb25942bcb524f462";
    hash = "sha256-R+oP4IWXaFgmBjrbZ6AE8/1z6YuwAB3c9i0+SfyHxO0=";
  };
  makeFlags = ["-Clinux"];
  nativeBuidInputs = [
    pkg-config
    glib
    glibc
    gtk2
    gobject-introspection
    wrapGAppsHook
  ];
  meta = {
    description = "OBD-II Display for Rasperry PI/Linux and Tiny-CAN";
    homepage = "https://github.com/MHS-Elektronik/OBD-Display";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "obd-display";
    platforms = lib.platforms.all;
  };
}
