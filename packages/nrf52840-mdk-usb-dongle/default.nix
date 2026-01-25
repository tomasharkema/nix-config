{
  fetchFromGitHub,
  stdenv,
  python3,
}: let
  py = python3.withPackages (ps:
    with ps; [
      psutil
      pyserial
    ]);
in
  stdenv.mkDerivation rec {
    pname = "nrf52840-mdk-usb-dongle";
    version = "2.0.0";

    src = fetchFromGitHub {
      owner = "makerdiary";
      repo = "nrf52840-mdk-usb-dongle";
      rev = "v${version}";
      hash = "sha256-y7QFKSrGnjj3ycyY02MYxyD3aPDODMx4y7Q6kVL9sGY=";
    };

    postInstall = ''
      mkdir -p $out/lib/wireshark/extcap
      cp -rv ./tools/ble_sniffer/extcap/. $out/lib/wireshark/extcap

      rm -rf $out/lib/wireshark/extcap/nrf_sniffer_ble.bat

      substituteInPlace $out/lib/wireshark/extcap/nrf_sniffer_ble.py --replace-fail "/usr/bin/env python3" "${py}/bin/python3"
    '';
  }
