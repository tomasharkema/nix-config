{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  pango,
  stdenv,
  darwin,
  nix-update-script,
  fetchurl,
  gtksourceview,
  python3,
}: let
  fetch_librusty_v8 = args:
    stdenv.mkDerivation {
      pname = "librusty_v8_mirror";
      version = args.version;

      src = fetchurl {
        name = "librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a";
        url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a";
        sha256 = args.shas.${stdenv.hostPlatform.system};

        meta = {
          inherit (args) version;
          sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
        };
      };

      dontUnpack = true;

      installPhase = ''
        install -Dm 444 $src $out/v${args.version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a
      '';
    };
in
  rustPlatform.buildRustPackage rec {
    pname = "boop-gtk";
    version = "1.7.1";

    src = fetchFromGitHub {
      owner = "zoeyfyi";
      repo = "Boop-GTK";
      rev = "v${version}";
      hash = "sha256-QwoIgdDXlyVbR/eUiKOY40ZZh+DLy50TqkpV0tHB1Uc=";
      fetchSubmodules = true;
    };

    cargoHash = "sha256-KkGBIq1FDvKgpW5u+nv4KUcoSje96dINQ7rbHxKL4No=";
    # cargoHash = "sha256-KkGBIq1FDvKgpW5u+nv4KUcoSje96dINQ7rbHxKL4No=";

    RUSTY_V8_ARCHIVE = fetch_librusty_v8 {
      version = "0.22.1";
      shas = {
        x86_64-linux = "sha256-rHI5qzwmDvlIdjUCZwvl6/s2Oe6d3/V7TJwfP1AFjik=";
        aarch64-linux = "";
        x86_64-darwin = "";
        aarch64-darwin = "";
      };
    };

    RUSTY_V8_MIRROR = fetch_librusty_v8 {
      version = "0.22.1";
      shas = {
        x86_64-linux = "sha256-rHI5qzwmDvlIdjUCZwvl6/s2Oe6d3/V7TJwfP1AFjik=";
        aarch64-linux = "";
        x86_64-darwin = "";
        aarch64-darwin = "";
      };
    };

    dontCheck = true;

    nativeBuildInputs = [
      pkg-config
      wrapGAppsHook
      python3
      rustPlatform.bindgenHook
    ];

    buildInputs =
      [
        atk
        cairo
        gdk-pixbuf
        glib
        gtk3
        pango
        gtksourceview
      ]
      ++ lib.optionals stdenv.isDarwin [
        darwin.apple_sdk.frameworks.CoreFoundation
        darwin.apple_sdk.frameworks.CoreServices
      ];

    patches = [./windows.patch];

    # preBuild = ''
    #   echo $RUSTY_V8_ARCHIVE
    #   sleep 1000
    # '';

    passthru.updateScript = nix-update-script {};

    meta = with lib; {
      description = "Port of @IvanMathy's Boop to GTK, a scriptable scratchpad for developers";
      homepage = "https://github.com/zoeyfyi/Boop-GTK";
      license = licenses.mit;
      maintainers = with maintainers; [];
      mainProgram = "boop-gtk";
    };
  }
