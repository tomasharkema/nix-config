{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  custom,
}:
stdenv.mkDerivation rec {
  pname = "glcd-proc-driver";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "lucianm";
    repo = "GLCDprocDriver";
    rev = version;
    hash = "sha256-+AsEWENtHdPKAH5DzvHT9asSU3ya2mUUyr7kn6O5JAo=";
  };

  # preBuild = ''
  #   set -x
  # '';

  installFlags = ["DESTDIR=${placeholder "out"}"];

  nativeBuildInputs = [pkg-config];

  buildInputs = [custom.graphlcd-base];

  meta = {
    description = "GraphLCD adapter layer for the LCDproc \"glcdlib\" driver";
    homepage = "https://github.com/lucianm/GLCDprocDriver";
    changelog = "https://github.com/lucianm/GLCDprocDriver/blob/${src.rev}/ChangeLog";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "glc-dproc-driver";
    platforms = lib.platforms.all;
  };
}
