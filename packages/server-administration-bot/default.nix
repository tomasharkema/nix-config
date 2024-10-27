{
  lib,
  python3,
  fetchFromGitHub,
  fetchPypi,
}: let
  # py = python3.override {
  #   packageOverrides = self: super: {
  #     python-telegram-bot = super.python-telegram-bot.overridePythonAttrs (old: {
  #       version = "13.8";
  #       src = fetchPypi {
  #         pname = "python-telegram-bot";
  #         version = "13.8";
  #         hash = "sha256-IdBrGSqJPS+pbBYEWOEdy8VTrfYwzNGhzMbuuSkmJbA=";
  #       };
  #     });
  #   };
  # };
  pyPkgs = python3.pkgs;

  t = pyPkgs."python-telegram-bot".overrideAttrs (old: rec {
    pname = "python-telegram-bot";
    version = "13.8";

    # format = "setuptools";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-IdBrGSqJPS+pbBYEWOEdy8VTrfYwzNGhzMbuuSkmJbA=";
    };
  });
in
  pyPkgs.buildPythonApplication rec {
    pname = "server-administration-bot";
    version = "unstable-2022-01-06";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "gregdan3";
      repo = "server-administration-bot";
      rev = "5a60b448d3d9864ebfef7de22e6903fa77aee0fb";
      hash = "sha256-H8yhEMppfkt0l9bn3w9BkwniQiK9FFNKhbXMaYczTzw=";
    };

    nativeBuildInputs = [
      pyPkgs.pdm-pep517
    ];

    propagatedBuildInputs = with pyPkgs; [
      python-dotenv
      # python-telegram-bot
      t
      pyyaml
    ];

    # pythonImportsCheck = [ "sysadmin_telebot" ];

    meta = with lib; {
      description = "A telegram bot for sending commands to and receiving notifications from a Linux server";
      homepage = "https://github.com/gregdan3/server-administration-bot";
      license = licenses.unfree; # FIXME: nix-init did not found a license
      maintainers = with maintainers; [];
      mainProgram = "server-administration-bot";
    };
  }
