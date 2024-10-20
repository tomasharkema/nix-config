{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  fetchNpmDeps,
}:
buildNpmPackage rec {
  pname = "portainer-telegram-bot";
  version = "unstable-2023-10-25";

  src = fetchFromGitHub {
    owner = "ruben-rodriguez";
    repo = "portainer-telegram-bot";
    rev = "5f3d4d7af056c5bf22e80dd9c31bff6cca735f0d";
    hash = "sha256-LkC5AVGPlSfO8ofhXKMTuxO4FWvvUEc8jF7a/11nRjI=";
  };

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-cSxnTDDEx18/UgIs9Vy6dYb3EKoC9cxt6k2/dY0iSW0=";

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -a . $out/lib

    ls -la $out/lib

    mkdir $out/bin



    runHook postInstall
  '';

  meta = with lib; {
    description = "Telegram Bot to manage Docker through Portainer API";
    homepage = "https://github.com/ruben-rodriguez/portainer-telegram-bot";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "portainer-telegram-bot";
    platforms = platforms.all;
  };
}
