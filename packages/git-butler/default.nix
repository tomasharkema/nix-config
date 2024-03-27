{
  appimageTools,
  fetchzip,
  fetchurl,
  lib,
  stdenv,
}: let
  shortVersion = "0.10.27";
  build = "746";
  fullVersion = "${shortVersion}-${build}";
  arch =
    if stdenv.isx86_64
    then "amd64"
    else "aarch64";
in
  appimageTools.wrapType2 rec {
    pname = "git-butler";
    version = fullVersion;

    src = fetchurl {
      url = "https://releases.gitbutler.com/releases/release/${fullVersion}/linux/x86_64/git-butler_${shortVersion}_${arch}.AppImage";
      hash = "sha256-J7y/KfT5EfxWks2OXYGJIkPex8yh4jdFBhyGKXTXKFA=";
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
