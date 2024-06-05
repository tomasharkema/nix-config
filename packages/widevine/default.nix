{ lib, stdenv, fetchzip, fetchurl, dpkg, tree, }:

if stdenv.isx86_64 then
  stdenv.mkDerivation rec {
    pname = "widevine";
    version = "4.10.2710.0";

    src = fetchzip {
      url = "https://dl.google.com/widevine-cdm/${version}-linux-x64.zip";

      hash = "sha256-lGTrSzUk5FluH1o4E/9atLIabEpco3C3gZw+y6H6LJo=";

      stripRoot = false;
    };

    installPhase = ''
      runHook preInstall

      install -vD manifest.json $out/share/google/chrome/WidevineCdm/manifest.json
      install -vD LICENSE.txt $out/share/google/chrome/WidevineCdm/LICENSE.txt
      install -vD libwidevinecdm.so $out/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so
      install -vD libwidevinecdm.so $out/lib/libwidevinecdm.so

      runHook postInstall
    '';
  }
else

  stdenv.mkDerivation rec {
    pname = "widevine";
    version = "4.10.2662.3+1";

    src = fetchurl {
      url =
        "http://archive.raspberrypi.org/debian/pool/main/w/widevine/libwidevinecdm0_${version}_arm64.deb";
      hash = "sha256-DoeCOiKCRvTxx8kKxIxfiI0GB9AorA/9F/5hDVSPW7M=";
    };

    nativeBuildInputs = [ tree dpkg ];

    installPhase = ''
      runHook preInstall

      install -vD ./opt/WidevineCdm/gmp-widevinecdm/latest/manifest.json $out/share/google/chrome/WidevineCdm/manifest.json
      install -vD ./opt/WidevineCdm/gmp-widevinecdm/latest/libwidevinecdm.so $out/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so
      install -vD ./opt/WidevineCdm/gmp-widevinecdm/latest/libwidevinecdm.so $out/lib/libwidevinecdm.so

      runHook postInstall
    '';
  }
