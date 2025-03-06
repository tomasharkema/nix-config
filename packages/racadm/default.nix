{
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
}: let
  argtable = stdenv.mkDerivation rec {
    pname = "argtable";
    version = "2.13";

    src = fetchFromGitHub {
      owner = "jonathanmarvens";
      repo = "argtable2";
      rev = "v2.13";
      sha256 = "sha256-K6++QVvpcPR+BYxbDRZ24sY0+PgIaQ3t1ktt3zZGh6Q=";
    };

    nativeBuildInputs = [
      # cmake
      pkg-config
      # ninja
    ];

    buildInputs = [];

    patches = [./ctype.patch];
  };
in
  stdenv.mkDerivation rec {
    pname = "racadm";
    version = "10.3.0.0-4945";

    src = fetchurl {
      url = "https://dl.dell.com/FOLDER08637461M/1/DellEMC-iDRACTools-Web-LX-${version}_A00.tar.gz";
      sha256 = "sha256-TbrMpVdBQ6lE+K23v6m4EkL55V9PzHXPcx7+vh1MaMY=";
      curlOptsList = ["-A" "Mozilla"];
    };

    nativeBuildInputs = [dpkg autoPatchelfHook];

    buildInputs = [argtable];

    postUnpack = ''
      dpkg-deb --fsys-tarfile iDRACTools/racadm/UBUNTU20/x86_64/srvadmin-hapi_11.0.1.0_amd64.deb | \
        tar -vx --no-same-owner -C iDRACTools

      dpkg-deb --fsys-tarfile iDRACTools/racadm/UBUNTU20/x86_64/srvadmin-idracadm8_11.0.1.0_amd64.deb | \
        tar -vx --no-same-owner -C iDRACTools

      dpkg-deb --fsys-tarfile iDRACTools/racadm/UBUNTU20/x86_64/srvadmin-idracadm7_11.0.1.0_all.deb | \
        tar -vx --no-same-owner -C iDRACTools
    '';

    installPhase = ''
      mkdir -p $out/{bin,lib}
      cp -r usr/libexec $out
      cp -r opt/dell/srvadmin/* $out
      cp -r etc $out
      cp -r etc/systemd $out/lib
      rm -rf $out/var

      substituteInPlace $out/lib/systemd/system/instsvcdrv.service --replace-fail "/usr" "$out"
      substituteInPlace $out/libexec/instsvcdrv-helper \
        --replace-fail "/opt/dell/srvadmin\"" "$out\"" \
        --replace-fail "/opt/dell/srvadmin/" "/" \
        --replace-fail "OS_MODULES_DIR=\"/lib/modules\"" "OS_MODULES_DIR="/run/booted-system/sw/lib/modules""
    '';
  }
