{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  makeWrapper,
  openssl,
  pciutils,
  libmbim,
  libz,
  libgcc,
  bash,
}:
stdenv.mkDerivation rec {
  pname = "lenovo-wwan-unlock";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "lenovo";
    repo = "lenovo-wwan-unlock";
    rev = "v${version}";
    hash = "sha256-oRATWG3trHEhhlCVGklJMwdLFSxwhrBRrtZtoQUQfBM=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    # autoreconfHook
  ];

  buildInputs = [
    openssl
    pciutils
    libmbim
    libz
    libgcc
    stdenv.cc.cc.lib
    bash
  ];

  installPhase = ''
    mkdir -p $out/{bin,lib}
    install -Dm755 *.so $out/lib/

    install -Dm755 DPR_Fcc_unlock_service $out/bin/DPR_Fcc_unlock_service
    install -Dm755 configservice_lenovo $out/bin/configservice_lenovo

    mkdir -p $out/share/ModemManager/fcc-unlock.d
    tar -zxf fcc-unlock.d.tar.gz -C $out/share/ModemManager/
    chmod ugo+x $out/share/ModemManager/fcc-unlock.d/*

    tar -zxf sar_config_files.tar.gz -C $out/lib/

    install -Dm755 lenovo-cfgservice.service $out/lib/systemd/system/lenovo-cfgservice.service

    substituteInPlace $out/lib/systemd/system/lenovo-cfgservice.service \
      --replace-fail "/opt/fcc_lenovo" "$out/bin"
  '';

  meta = with lib; {
    description = "FCC and DPR unlock for Lenovo PCs";
    homepage = "https://github.com/lenovo/lenovo-wwan-unlock";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "lenovo-wwan-unlock";
    platforms = platforms.all;
  };
}
