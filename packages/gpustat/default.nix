# https://github.com/wookayin/gpustat
{python3Packages}:
with python3Packages;
  buildPythonPackage rec {
    pname = "gpustat";
    version = "1.1.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-wY0+1VGPwWMAxC1pTevHCuuzvlXK6R8dtk1jtfqK+dg="; # TODO
    };

    doCheck = false;

    propagatedBuildInputs = [
      # ...
      setuptools
      setuptools_scm
      pytest
      psutil
      blessed
      pynvml
    ];

    meta.platforms = [
      "x86_64-linux"
    ];
  }
