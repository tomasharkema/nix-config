{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
  libsForQt5,
}: let
  pypdf2 = python3.pkgs.buildPythonPackage rec {
    pname = "PyPDF2";
    version = "1.28.3";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-p92Z+TMgfD3Bs8/bmQX9zRwR6KtouWAMUHNLtUOcL+0=";
    };
  };
in
  python3.pkgs.buildPythonApplication rec {
    pname = "remy";
    version = "unstable-2023-02-15";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "bordaigorl";
      repo = "remy";
      rev = "d07b7360a2ef5914c72194395850731462b7b520";
      hash = "sha256-peQczLL9q8ladeqY2o+8BIlbkaCLi9KW/gOXVJCRX6g=";
    };

    qtWrapperArgs = [
      "--set QT_QPA_PLATFORM_PLUGIN_PATH ${libsForQt5.qt5.qtbase.bin}/lib/qt-${libsForQt5.qt5.qtbase.version}/plugins/platforms"
    ];

    nativeBuildInputs = [
      python3.pkgs.pyqt5
      python3.pkgs.setuptools
      python3.pkgs.wheel
      libsForQt5.qt5.wrapQtAppsHook
      libsForQt5.qt5.qtbase
      libsForQt5.qt5.qtwayland
    ];

    propagatedBuildInputs = with python3.pkgs; [
      requests
      sip
      arrow
      paramiko
      pypdf2
      pyqt5
    ];

    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';

    pythonImportsCheck = ["remy"];

    meta = with lib; {
      description = "Remy, an online&offline manager for the reMarkable tablet";
      homepage = "https://github.com/bordaigorl/remy";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [];
      mainProgram = "remy";
    };
  }
