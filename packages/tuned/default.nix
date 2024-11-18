{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  pkg-config,
  systemd,
  desktop-file-utils,
}:
stdenv.mkDerivation rec {
  pname = "tuned";
  version = "2.24.0";

  src = fetchFromGitHub {
    owner = "redhat-performance";
    repo = "tuned";
    rev = "v${version}";
    hash = "sha256-6x5sRzHZEKS7keEBRqDNQsdAcqrpsZ4h2eTCi1o0hPM=";
  };

  nativeBuildInputs = [
    python3
    pkg-config
    desktop-file-utils
  ];

  buildInputs = [systemd];

  makeFlags = [
    "PYTHON=${python3}/bin/python3"
    # "UNITDIR=${placeholder "out"}/lib/systemd/system"
    "DESTDIR=${placeholder "out"}"
  ];

  preConfigure = ''
    #   ls -la
    substituteInPlace Makefile --replace-fail "/usr" ""
    #     --replace-fail "/var/lib" "$out/var/lib" \
    #     --replace-fail "/var/log" "$out/var/log" \
    #     --replace-fail "/run" "$out/run" \
    #     --replace-fail "/etc" "$out/etc"
  '';

  pythonImportsCheck = ["tuned" "tuned-adm"];

  meta = with lib; {
    description = "Tuning Profile Delivery Mechanism for Linux";
    homepage = "https://github.com/redhat-performance/tuned";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [];
    mainProgram = "tuned";
    platforms = platforms.all;
  };
}
