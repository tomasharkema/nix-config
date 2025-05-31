{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "discovery-rs";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "JustPretender";
    repo = "discovery-rs";
    rev = "v${version}";
    hash = "sha256-8MoFWqUxOXiAVdu0wGcvmq6ghbQ2LX3XsiR5oIvOHTA=";
  };

  cargoHash = "sha256-D35J0iYQeF+uI+jYYWwvmRFwU3QiDG8m4J5RoXXBNhM=";

  meta = {
    description = "";
    homepage = "https://github.com/JustPretender/discovery-rs";
    changelog = "https://github.com/JustPretender/discovery-rs/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "discovery-rs";
  };
}
