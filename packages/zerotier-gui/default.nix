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
      hash = "sha256-ReuGYm5q3xiyhfOP1vXhc+8tABIg8YxUXzT5A7k2cWk=";
    };

    dontBuild = true;
    propagatedBuildInputs = [tkinter];

    installPhase = ''
      mkdir -p $out/bin
      cp -r src/. $out/bin
    '';

    # nativeBuildInputs = [alen];
  }
