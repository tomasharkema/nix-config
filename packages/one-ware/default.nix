{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
}:
buildDotnetModule (finalAttrs: {
  pname = "one-ware";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "one-ware";
    repo = "OneWare";
    tag = finalAttrs.version;
    hash = "sha256-Y3tZfkB1U5/U4VyfbSudYX2dGOJhFOubMWFjF3jFJZ8=";
    fetchSubmodules = true;
  };
  dotnet-sdk = dotnetCorePackages.sdk_10_0;

  projectFile = "studio/OneWare.Studio.Desktop/OneWare.Studio.Desktop.csproj";
  nugetDeps = ./deps.json;
  meta = {
    description = "Next Generation IDE for Electronics Development";
    homepage = "https://github.com/one-ware/OneWare";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "one-ware";
    platforms = lib.platforms.all;
  };
})
