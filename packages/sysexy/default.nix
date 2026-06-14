{
  perlPackages,
  perl,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  db,
  makeWrapper,
  lib,
  alsa-lib-with-plugins,
}: let
  MIDIALSA = perlPackages.buildPerlPackage {
    pname = "MIDI-ALSA";
    version = "1.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PJ/PJB/MIDI-ALSA-1.22.tar.gz";
      hash = "sha256-Q8IwqqxQusdu20EHGRQ2gnShW8Ql9YDo0Zi/ctuFJ0Q=";
    };

    doCheck = false;

    buildInputs = [
      alsa-lib-with-plugins
    ];

    meta = {
      license = with lib.licenses; [artistic1 gpl1Plus];
    };
  };
in
  # perlPackages.buildPerlPackage
  stdenv.mkDerivation
  rec {
    pname = "sysexy";
    version = "0.8.6";

    src = fetchurl {
      url = "http://catmind.org/sysexy-${version}.tbz";
      hash = "sha256-ERHGIVUtwQXl9zCAvKgpUJSSiYnYaRTCCQxu7vKNFqg=";
    };

    nativeBuildInputs = [makeWrapper perl];

    buildInputs = with perlPackages; [
      Tk
      ListMoreUtils
    ];

    # prePatch = ''
    #   rm ./install
    #   touch ./Makefile.PL
    # '';

    # dontBuild = true;
    # doCheck = false;

    # prePatch = ''
    #   substituteInPlace $out/bin/sysexy \
    #     --replace-fail '#!/usr/bin/perl' '#!/usr/bin/env perl'
    # '';

    postInstall = ''
      install -D ./sysexy $out/bin/sysexy
    '';

    postFixup = ''
      wrapProgram $out/bin/sysexy \
        --prefix PERL5LIB : "${with perlPackages;
        makePerlPath [
          Tk
          ListMoreUtils
          ConfigSimple
          ExporterTiny
          MIDIALSA
        ]}"
    '';

    # preConfigure = ''
    #   echo "LIB = ${db.out}/lib" > config.in
    #   echo "INCLUDE = ${db.dev}/include" >> config.in
    # '';
  }
