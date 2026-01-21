{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "discovery-rs";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "JustPretender";
    repo = "discovery-rs";
    rev = "v${version}";
    hash = "sha256-XXDX0oyagLh411EZk2ZtF968DzYEthnFtZY4NvXjF98=";
  };

  cargoHash = "sha256-E6e7cE7qmwV+/sjC0ChsckJkp+VstJ8sI0RRmcCNu1o=";

  meta = {
    description = "";
    homepage = "https://github.com/JustPretender/discovery-rs";
    changelog = "https://github.com/JustPretender/discovery-rs/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "discovery-rs";
  };
}
