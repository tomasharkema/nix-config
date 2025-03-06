{
  stdenv,
  fetchurl,
  tree,
  dpkg,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  pname = "racadm";
  version = "10.3.0.0-4945";

  src = fetchurl {
    url = "https://dl.dell.com/FOLDER08637461M/1/DellEMC-iDRACTools-Web-LX-${version}_A00.tar.gz";
    sha256 = "sha256-TbrMpVdBQ6lE+K23v6m4EkL55V9PzHXPcx7+vh1MaMY=";
    curlOptsList = ["-A" "Mozilla"];
  };
  nativeBuildInputs = [dpkg autoPatchelfHook];

  postUnpack = ''
    ${tree}/bin/tree .
    dpkg-deb --fsys-tarfile racadm/UBUNTU20/x86_64/srvadmin-hapi_11.0.1.0_amd64.deb | \
      tar -x --no-same-owner

    dpkg-deb --fsys-tarfile racadm/UBUNTU20/x86_64/srvadmin-idracadm8_11.0.1.0_amd64.deb | \
      tar -x --no-same-owner

    dpkg-deb --fsys-tarfile racadm/UBUNTU20/x86_64/srvadmin-idracadm7_11.0.1.0_amd64.deb | \
      tar -x --no-same-owner
  '';
  installPhase = ''
    ${tree}/bin/tree .

    # racadm/UBUNTU20/x86_64/srvadmin-hapi_11.0.1.0_amd64.deb
    # racadm/UBUNTU20/x86_64/srvadmin-idracadm7_11.0.1.0_all.deb
    # racadm/UBUNTU20/x86_64/srvadmin-idracadm8_11.0.1.0_amd64.deb


    # install -D racadm $out/bin/racadm
  '';
}
