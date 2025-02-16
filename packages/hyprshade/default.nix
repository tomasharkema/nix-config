{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "hyprshade";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "loqusion";
    repo = "hyprshade";
    rev = version;
    hash = "sha256-MlbNE9n//Qb6OJc3DMkOpnPtoodfV8JlG/I5rOfWMtQ=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    click
    more-itertools
  ];

  pythonImportsCheck = [
    "hyprshade"
  ];

  meta = {
    description = "Hyprland shader configuration tool";
    homepage = "https://github.com/loqusion/hyprshade";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "hyprshade";
  };
}
