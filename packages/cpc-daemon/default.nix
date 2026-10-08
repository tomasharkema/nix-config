{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  pkg-config,
  mbedtls,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cpc-daemon";
  version = "4.9.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "SiliconLabs";
    repo = "cpc-daemon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-azaof5O7fMP3e1rfGvKYQDdBcmTC0687vtcRW/URgqc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DENABLE_ENCRYPTION=FALSE"
  ];

  # buildInputs = [
  #   mbedtls
  # ];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Co-Processor Communication - Daemon for Linux";
    homepage = "https://github.com/SiliconLabs/cpc-daemon";
    changelog = "https://github.com/SiliconLabs/cpc-daemon/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [];
    mainProgram = "cpc-daemon";
    platforms = lib.platforms.all;
  };
})
