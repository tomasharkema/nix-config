{
  dpkg,
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  tree,
  libz,
  libxml2,
  ncurses,
  linux-pam,
  openssl_1_1,
  openwsman,
  libxslt,
  glibc,
  wsmancli,
}:
stdenv.mkDerivation {
  pname = "srvadmin";
  version = "9.5.0";

  # Depends: srvadmin-base (>= 9.5.0), srvadmin-storageservices (>= 9.5.0), srvadmin-webserver (>= 9.5.0), srvadmin-standardagent (>= 9.5.0), srvadmin-server-snmp (>= 9.5.0), srvadmin-server-cli (>= 9.5.0), srvadmin-oslog (>= 9.5.0), srvadmin-idracadm8 (>= 9.5.0)

  srcs =
    (import ./srv.nix {inherit fetchurl;})
    ++ [
      # (fetchurl {
      #   url = "http://http.us.debian.org/debian/pool/main/a/argtable2/libargtable2-dev_13-3_amd64.deb";
      #   sha256 = "sha256-WE9VHMOueb5DT99q5TtjXXzjf7SnITIrwApptUft6dw=";
      # })
      (fetchurl {
        url = "http://archive.ubuntu.com/ubuntu/pool/universe/s/sblim-cmpi-devel/libcmpicppimpl0_2.0.3-0ubuntu3_amd64.deb";
        sha256 = "sha256-5ec6i4Gh2KPgQpHg+X9FHieF6IS1dVCThsQuutIAEvg=";
      })
      (fetchurl {
        url = "http://archive.ubuntu.com/ubuntu/pool/universe/o/openwsman/libwsman-client4t64_2.6.5-0ubuntu15_amd64.deb";
        sha256 = "sha256-FKq7ByAzNqV0Sv58w0WHFZCFiGUs93kyA618Qit2fgQ=";
      })
    ];

  nativeBuildInputs = [
    dpkg

    autoPatchelfHook
  ];

  buildInputs = [
    tree
    libz
    libxml2
    ncurses
    linux-pam
    openssl_1_1
    openwsman
    libxslt
    # stdenv.cc.cc
    wsmancli
    glibc
  ];

  installPhase = ''
        mkdir -p $out

        cp -r opt $out
        cp -r usr/ $out
        ls -ls $out/opt/dell $out/opt/dell/srvadmin

        mv $out/opt/dell/srvadmin/bin $out
        mv $out/opt/dell/srvadmin/lib64 $out

        # cp -vr ./usr/. $out
    #
        # sleep 1000

  '';
}
