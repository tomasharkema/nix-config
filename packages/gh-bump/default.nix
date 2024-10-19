{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gh-bump";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "johnmanjiro13";
    repo = "gh-bump";
    rev = "v${version}";
    hash = "sha256-Dz8/pHKzanD2GQO4thIGtkf3MgnGBs+CcavRGswEvsE=";
  };

  vendorHash = "sha256-g+EO/DYeoZ2wQ+25StPOGoOUTbgJepGs4ugmkza0Tnk=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Gh extension for bumping version of a repository";
    homepage = "https://github.com/johnmanjiro13/gh-bump";
    changelog = "https://github.com/johnmanjiro13/gh-bump/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "gh-bump";
  };
}
