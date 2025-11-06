{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "batenergy";
  version = "unstable-2025-08-20";

  src = fetchFromGitHub {
    owner = "equaeghe";
    repo = "batenergy";
    rev = "07b44f6a009739d42cbfab37b81978a940471543";
    hash = "sha256-A7GTZVrj+ZTgjzhIuJ3+OTDYIZzMyIsObOieY1PGA/M=";
  };

  installPhase = ''
    install -D batenergy.sh $out/lib/batenergy
    mkdir -p $out/etc/systemd/system-sleep
    ln -s $out/lib/batenergy $out/etc/systemd/system-sleep/batenergy
  '';

  meta = {
    description = "Script to track laptop battery energy change during sleep states using systemd's system-sleep directory";
    homepage = "https://github.com/equaeghe/batenergy";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "batenergy";
    platforms = lib.platforms.all;
  };
}
