{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gnutls,
  ninja,
  autoPatchelfHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rpifwcrypto-pkcs11";
  version = "0-unstable-2026-03-25";

  src = fetchFromGitHub {
    owner = "embetrix";
    repo = "rpifwcrypto-pkcs11";
    rev = "9a27fbaa8baa1d027bc3fe9d55afbb31d23356b2";
    hash = "sha256-grrDNKicM53V8FrE/S/xa6gsjcvww4u3q0qfBpf7PsU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
    autoPatchelfHook
  ];

  buildInputs = [
    gnutls
  ];
  passthru.updateScript = nix-update-script {};
  meta = {
    description = "PKCS#11 module that exposes Raspberry Pi firmware OTP ECDSA key through the PKCS#11 interface";
    homepage = "https://github.com/embetrix/rpifwcrypto-pkcs11";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "rpifwcrypto-pkcs11";
    platforms = lib.platforms.all;
  };
})
