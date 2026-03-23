{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "readmbn";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "openpst";
    repo = "readmbn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3/6+ZiBawnv8ti0nYl9N8RRRKPUzoiwCG6JktZuBios=";
    fetchSubmodules = true;
  };

  installPhase = ''
    install -D build/readmbn $out/bin/readmbn
  '';

  meta = {
    description = "CLI tool for reading and display information about files in Qualcomm mbn format";
    homepage = "https://github.com/openpst/readmbn";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "readmbn";
    platforms = lib.platforms.all;
  };
})
