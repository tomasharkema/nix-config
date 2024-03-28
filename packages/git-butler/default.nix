{
  appimageTools,
  fetchzip,
  fetchurl,
  lib,
  stdenv,
}: let
  shortVersion = "0.10.28";
  build = "764";
  fullVersion = "${shortVersion}-${build}";
  fullArch =
    if stdenv.isx86_64
    then "x86_64"
    else "aarch64";
  arch =
    if stdenv.isx86_64
    then "amd64"
    else "aarch64";
in
  appimageTools.wrapType2 rec {
    pname = "git-butler";
    version = fullVersion;
    src = fetchurl {
      url = "https://releases.gitbutler.com/releases/release/${fullVersion}/linux/${fullArch}/git-butler_${shortVersion}_${arch}.AppImage";
      hash = "sha256-kE98uVTObtYQvlFvStVBgvwVsX05qLSkgt+sk1oaNY0=";
    };
    extraPkgs = pkgs: with pkgs; [libthai];
    extraInstallCommands = let
      contents = appimageTools.extractType2 {inherit pname version src;};
    in ''
      mkdir -p "$out/share/applications"
      cp -r ${contents}/usr/share/* "$out/share"
      ln -fns "$out/bin/${pname}-${version}" "$out/bin/${pname}"
    '';
  }
