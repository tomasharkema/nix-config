{
  lib,
  stdenv,
  fetchFromGitHub,
  dotnetCorePackages,
}:
dotnetCorePackages.buildDotnetModule (finalAttrs: {
  pname = "ratbuddyssey";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ratbuddy";
    repo = "ratbuddyssey";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zAce7rKMz/OKV+ZEvqWxY4s6VXHquXkU1qSEFxSlmfA=";
  };

  meta = {
    description = "Audyssey .ady file editor";
    homepage = "https://github.com/ratbuddy/ratbuddyssey";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "ratbuddyssey";
    platforms = lib.platforms.all;
  };
})
