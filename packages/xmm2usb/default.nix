{
  lib,
  stdenv,
  fetchFromGitHub,
  pciutils,
  makeWrapper,
  glib,
  pkg-config,
  libmbim,
}:
stdenv.mkDerivation rec {
  pname = "xmm2usb";
  version = "unstable-2022-02-10";

  src = fetchFromGitHub {
    owner = "xmm7360";
    repo = "xmm7360-usb-modeswitch";
    rev = "224e60c6c2147b32f4fdb09cc98259ca39dab3bd";
    hash = "sha256-HE9HX6RY5lXVmHMIHsTqVJvnfnunUENYimeTJnOaIdk=";
  };

  nativeBuildInputs = [makeWrapper pkg-config];

  buildInputs = [glib libmbim];

  # buildPhase = ''
  #   make -C fcc_unlock
  # '';

  installPhase = let
    binPath = lib.makeBinPath [
      pciutils
    ];
  in ''
    mkdir -p $out/bin
    cp xmm2usb $out/bin/xmm2usb

    chmod +x $out/bin/xmm2usb

    wrapProgram $out/bin/xmm2usb \
      --prefix PATH : "${binPath}"
  '';

  meta = with lib; {
    description = "Tools for the Fibocom L850-GL / Intel XMM7360 LTE modem";
    homepage = "https://github.com/xmm7360/xmm7360-usb-modeswitch";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "xmm2usb";
    platforms = platforms.all;
  };
}
