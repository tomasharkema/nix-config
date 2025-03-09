{
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  fetchFromGitHub,
  tree,
  rpm,
  lib,
  cmake,
  ninja,
  pkg-config,
  linuxPackages,
  kernel ? linuxPackages.kernel,
  kmod,
  cpio,
  openssl_1_1,
  makeWrapper,
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
    version = "9.4.0.0-3732";

    src = fetchurl {
      url = "https://dl.dell.com/FOLDER05920767M/1/DellEMC-iDRACTools-Web-LX-9.4.0-3732_A00.tar.gz";
      sha256 = "sha256-vXzsth+/RoGDVcXBQuI7OzVGbKzFu1buJNyabaco1ZU=";
      curlOptsList = ["-A" "Mozilla"];
    };

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
      tree
      rpm
      cpio
      makeWrapper
    ];

    buildInputs = [argtable];

    postUnpack = ''
      tree .
      # dpkg-deb --fsys-tarfile iDRACTools/racadm/UBUNTU20/x86_64/srvadmin-hapi_11.0.1.0_amd64.deb | \
      #   tar -vx --no-same-owner -C iDRACTools

      # dpkg-deb --fsys-tarfile iDRACTools/racadm/UBUNTU20/x86_64/srvadmin-idracadm8_11.0.1.0_amd64.deb | \
      #   tar -vx --no-same-owner -C iDRACTools
      rpm2cpio iDRACTools/racadm/RHEL8/x86_64/srvadmin-hapi-9.4.0-3732.15734.el8.x86_64.rpm | cpio -idmv -D iDRACTools
      rpm2cpio iDRACTools/racadm/RHEL8/x86_64/srvadmin-idracadm7-9.4.0-3732.15734.el8.x86_64.rpm | cpio -idmv -D iDRACTools
      # dpkg-deb --fsys-tarfile iDRACTools/racadm/UBUNTU20/x86_64/srvadmin-idracadm7_11.0.1.0_all.deb | \
      #   tar -vx --no-same-owner -C iDRACTools
    '';

    # --replace-fail "/opt/dell/srvadmin\"" "$out\"" \--replace-fail "/opt/dell/srvadmin/" "/" \

    installPhase = ''
      tree .
      mkdir -p $out/{bin,lib}
      cp -r usr/libexec $out
      cp -r opt/dell/srvadmin/* $out
      cp -r etc $out
      cp -r etc/systemd $out/lib
      rm -rf $out/var

      substituteInPlace $out/lib/systemd/system/instsvcdrv.service --replace-fail "/usr" "$out"
      substituteInPlace $out/libexec/instsvcdrv-helper --replace-fail 'ISVCDD_PROD_NAME=' 'set -x; ISVCDD_PROD_NAME=' \
        --replace-fail "OS_MODULES_DIR=\"/lib/modules\"" "OS_MODULES_DIR="/run/booted-system/sw/lib/modules""  --replace-fail ":/sbin:/usr/sbin:/bin:/usr/bin" ":$out/bin" --replace-fail "VERBOSE_LOGGING=false" "VERBOSE_LOGGING=true"

      wrapProgram $out/bin/idracadm7 --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [openssl_1_1]}"
    '';
  }
