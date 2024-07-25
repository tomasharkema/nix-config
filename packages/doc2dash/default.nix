{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
with python3Packages;
  buildPythonApplication rec {
    pname = "doc2dash";
    version = "3.1.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "hynek";
      repo = "doc2dash";
      rev = "v${version}";
      hash = "sha256-e6114UX5rYzcnTRmaT5bvC4rc2aj82+4nL97RL3IimY=";
    };

    nativeBuildInputs = [
      poetry-core
      setuptools-scm
    ];

    propagatedBuildInputs = [
      hatchling
      hatch-vcs
      hatch-fancy-pypi-readme
      attrs
      click
      rich
      beautifulsoup4
    ];
  }
