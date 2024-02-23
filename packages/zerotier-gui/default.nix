{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
with python3Packages;
  buildPythonApplication rec {
    pname = "zerotier-gui";
    version = "1.3.0";

    format = "other";

    src = fetchFromGitHub {
      owner = "tralph3";
      repo = "ZeroTier-GUI";
      rev = "v${version}";
      hash = "sha256-ffplTpW1ezrMwMsBFEj3b0LtIHh4Gc8rw+2QYSVEB/A=";
    };

    dontBuild = true;
    propagatedBuildInputs = [tkinter];

    installPhase = ''
      mkdir -p $out/bin
      cp -r src/. $out/bin
    '';

    # nativeBuildInputs = [alen];
  }
