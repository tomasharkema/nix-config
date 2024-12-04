{
  dpkg,
  lib,
  stdenv,
  fetchurl,
  tree,
}:
stdenv.mkDerivation {
  pname = "srvadmin";
  version = "950";

  # Depends: srvadmin-base (>= 9.5.0), srvadmin-storageservices (>= 9.5.0), srvadmin-webserver (>= 9.5.0), srvadmin-standardagent (>= 9.5.0), srvadmin-server-snmp (>= 9.5.0), srvadmin-server-cli (>= 9.5.0), srvadmin-oslog (>= 9.5.0), srvadmin-idracadm8 (>= 9.5.0)

  srcs = [
    (fetchurl {
      url = "https://linux.dell.com/repo/community/openmanage/950/focal/pool/main/s/srvadmin-cm/srvadmin-cm_9.5.0-20.09.00_amd64.deb";
      sha256 = "02nz3skhvfnqbra3i4pnkx967w61pqnxfs19kw5b42071c943s4f";
    })
  ];

  nativeBuildInputs = [dpkg];

  buildInputs = [tree];

  installPhase = ''
    tree .

    mkdir -p $out

    cp -r opt $out

    tree $out
  '';
}
