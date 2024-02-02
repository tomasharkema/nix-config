{
  lib,
  pdm,
  python39Packages,
}:
with python39Packages;
  buildPythonPackage rec {
    pname = "mkdocs-autorefs";
    version = "0.4.1";
    format = "pyproject";

    src = fetchGithub {
      inherit pname version;
      sha256 = "sha256-cHSKe9Al+ezW1v7rqLpj+OiRoa9V9I42bW1ueEk6uoQ=";
    };

    nativeBuildInputs = [pdm];
    propagatedBuildInputs = [
      markdown
      mkdocs
    ];

    doCheck = false;

    meta = with lib; {
      homepage = "https://github.com/mkdocstrings/autorefs";
      description = "Automatically link across pages in MkDocs.";
      license = licenses.isc;
    };
  }
