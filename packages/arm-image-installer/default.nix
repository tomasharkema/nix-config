{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "arm-image-installer";
  version = "5.3";

  src = fetchFromGitHub {
    owner = "fedora-arm";
    repo = "arm-image-installer";
    rev = "v${version}";
    hash = "sha256-paLuUJQ/zpKbKJ53Ri4+G8HBC9FcZHvwDniom90M59Y=";
  };

  buildPhase = ''
    substituteInPlace ./arm-image-installer \
      --replace-fail "/usr/share/arm-image-installer" "$out/share"
  '';

  installPhase = ''
    install -D arm-image-installer $out/bin/arm-image-installer
    mkdir -p $out/share
    cp -r socs.d $out/share/
    cp -r boards.d $out/share/
  '';

  meta = {
    description = "Install and manipulate ARM disk images";
    homepage = "https://github.com/fedora-arm/arm-image-installer/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "arm-image-installer";
    platforms = lib.platforms.all;
  };
}
