{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:
stdenv.mkDerivation rec {
  pname = "bootchart";
  version = "0.14.9";

  src = fetchFromGitHub {
    owner = "xrmx";
    repo = "bootchart";
    rev = version;
    hash = "sha256-sRJheliAF4UHHWhYlNV3K8VqezcssSnPRShp1+rE5kI=";
  };

  makeFlags = [
    "EARLY_PREFIX=$out"

    "PYTHON=${python3}/bin/python3"
  ];

  nativeBuildInputs = [python3];

  meta = {
    description = "Merge of bootchart-collector and pybootchartgui";
    homepage = "https://github.com/xrmx/bootchart";
    changelog = "https://github.com/xrmx/bootchart/blob/${src.rev}/NEWS";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "bootchart";
    platforms = lib.platforms.all;
  };
}
