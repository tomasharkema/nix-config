{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  makeDesktopItem,
  copyDesktopItems,
  libsecret,
  glib,
  gnutls,
  SDL2,
}:
buildDotnetModule rec {
  pname = "sourcegit";
  version = "8.32";

  src = fetchFromGitHub {
    owner = "sourcegit-scm";
    repo = "sourcegit";
    rev = "v${version}";
    hash = "sha256-sHSNGF1FmieXFDNqyw3GkEQsrG3wliXoswlacA4qqIY=";
  };

  projectFile = "src/SourceGit.csproj";
  # projectFile = "SourceGit.sln";

  nativeBuildInputs = [
    copyDesktopItems
  ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  dotnetBuildFlags = [
    "--no-self-contained"
  ];

  nugetDeps = ./deps.nix;
  nugetHash = "";
  executables = ["SourceGit"];

  runtimeDeps = [
    SDL2
    libsecret
    glib
    gnutls

    dotnetCorePackages.sdk_8_0
    dotnetCorePackages.runtime_8_0
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "SourceGit";
      exec = "SourceGit";
      icon = "xivlauncher";
      desktopName = "SourceGit";
      comment = meta.description;
      categories = ["Game"];
    })
  ];

  meta = with lib; {
    description = "Windows/macOS/Linux GUI client for GIT users";
    homepage = "https://github.com/sourcegit-scm/sourcegit";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "SourceGit";
    platforms = platforms.all;
  };
}
