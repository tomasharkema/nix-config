{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
}:
dotnetCorePackages.buildDotnetModule rec {
  pname = "remarkable-remember";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "ds160";
    repo = "remarkable-remember";
    rev = version;
    hash = "sha256-8TWSrUJblt7CA5Qas38soBoWdwqae6KMubPTDD8KMpU=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  # dotnet-runtime = dotnetCorePackages.runtime_8_0;

  projectFile = "src/ReMarkableRemember/ReMarkableRemember.csproj";
  nugetDeps = ./deps.json;

  meta = {
    description = "A cross-platform management application for your reMarkable tablet";
    homepage = "https://github.com/ds160/remarkable-remember";
    changelog = "https://github.com/ds160/remarkable-remember/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "ReMarkableRemember";
    platforms = lib.platforms.all;
  };
}
