{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  pkg-config,
  cjson,
  soapysdr-with-plugins,
  libacars,
  sdrplay,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "acarsdec";
  version = "4.6";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "f00b4r0";
    repo = "acarsdec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ehjT+ZBe5Jtpri7cNALXmWtfKhhtX0G2Hbbucm/C8jE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cjson
    soapysdr-with-plugins

    libacars
    sdrplay
  ];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "ACARS SDR decoder";
    homepage = "https://github.com/f00b4r0/acarsdec";
    changelog = "https://github.com/f00b4r0/acarsdec/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "acarsdec";
    platforms = lib.platforms.all;
  };
})
