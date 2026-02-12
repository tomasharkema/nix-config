{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "contact";
  version = "1.4.14";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdxlocations";
    repo = "contact";
    rev = "${version}";
    sha256 = "sha256-FvU1LNPzUOnZXrJ/FqmqykoTy6ecS+EdTL4RqY5lcT8=";
  };

  build-system = [
    python3.pkgs.poetry-core
  ];

  dependencies = with python3.pkgs; [
    meshtastic
  ];

  meta = {
    description = "";
    homepage = "https://github.com/pdxlocations/contact";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "contact";
    platforms = lib.platforms.all;
  };
}
