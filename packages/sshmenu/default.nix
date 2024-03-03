#https://github.com/antonjah/ssh-menu
{
  python3Packages,
  fetchPypi,
  fetchFromGitHub,
  pdm,
}:
with python3Packages;
  python3Packages.buildPythonPackage rec {
    pname = "sshmenu";
    version = "1.5.1";

    src = fetchFromGitHub {
      owner = "antonjah";
      repo = "ssh-menu";
      rev = "${version}";
      hash = "sha256-1Gwool7yXBiF+7+LVbtPr8AM+/2UWbL5Qu+j/Zd0DQo=";
    };

    # doCheck = false;

    nativeBuildInputs = [
      pip
      pdm
      pdm-pep517
      bullet
    ];
  }
