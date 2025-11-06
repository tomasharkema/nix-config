{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "mesh-sense";
  version = "1.0.18";

  src = fetchFromGitHub {
    owner = "Affirmatech";
    repo = "MeshSense";
    rev = "v${version}";
    hash = "sha256-f0wxBdP6cToKgxeBfaZz9/qvXHDek1w54TRSYUKaNTM=";
  };

  meta = {
    description = "MeshSense directly connects to your Meshtastic node via Bluetooth or WiFi and continuously provides information to assess the health of your mesh network";
    homepage = "https://github.com/Affirmatech/MeshSense";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "mesh-sense";
    platforms = lib.platforms.all;
  };
}
