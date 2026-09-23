{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  openssl,
  soapyhackrf,
  soapysdr-with-plugins,
  rtl-sdr-librtlsdr,
  rtl-ais,
  hackrf,
  zlib,
  sqlite,
  libsamplerate,
  soxr,
  pkg-config,
  callPackage,
}: let
  nmea2000 = callPackage ./nmea.nix {};
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "ais-catcher";
    version = "0.70";
    __structuredAttrs = true;
    strictDeps = true;

    src = fetchFromGitHub {
      owner = "jvde-github";
      repo = "AIS-catcher";
      tag = "v${finalAttrs.version}";
      hash = "sha256-YDkqIoW3DDwUfAJftvfnmsIQYCq9ujYrB8RvZRiIexg=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    buildInputs = [
      openssl
      # nmea2000
      soapyhackrf
      soapysdr-with-plugins
      rtl-sdr-librtlsdr
      rtl-ais
      hackrf
      zlib
      sqlite
      libsamplerate
      soxr
    ];

    passthru.updateScript = nix-update-script {};

    meta = {
      description = "AIS receiver for RTL SDR dongles, Airspy R2, Airspy Mini, Airspy HF+, HackRF, SDRplay and SoapySDR";
      homepage = "https://github.com/jvde-github/AIS-catcher";
      changelog = "https://github.com/jvde-github/AIS-catcher/releases/tag/${finalAttrs.src.tag}";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [];
      mainProgram = "ais-catcher";
      platforms = lib.platforms.all;
    };
  })
