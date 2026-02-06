{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  meson,
  pkg-config,
  gtk3,
  udev,
}:
stdenv.mkDerivation {
  pname = "usbip-service-discovery";
  version = "unstable-2020-07-06";
  src = fetchFromGitHub {
    owner = "alunux";
    repo = "usbip-service-discovery";
    rev = "25c7636f2c0dcbd0a7154570d7b7f5626ca1caa6";
    hash = "sha256-Snf00+5RWHl2jEqxTL/tAUpO385xcBmTgWWw70Q7V5g=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    gtk3
    udev
  ];
}
# python3.pkgs.buildPythonPackage rec {
#   pname = "usbip-manager";
#   version = "unstable-2020-07-06";
#   src = fetchFromGitHub {
#     owner = "m-antonov";
#     repo = "USBIPManager";
#     rev = "b03d8d9c0befcd70b7f67cfe61c0664f48d2939d";
#     hash = "sha256-2YM4Mn5cEZ8BRG3dPui47AxNYNPtRxlIhbQh6NnRC3o=";
#   };
#   pyproject = true;
#   build-system = [python3.pkgs.setuptools];
#   meta = {
#     description = "Advanced client for USBIP project";
#     homepage = "https://github.com/m-antonov/USBIPManager";
#     license = lib.licenses.mit;
#     maintainers = with lib.maintainers; [];
#     mainProgram = "usbip-manager";
#     platforms = lib.platforms.all;
#   };
# }

