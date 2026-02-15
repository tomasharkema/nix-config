{
  lib,
  stdenv,
  fetchFromGitHub,
  systemd,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "uwsm-scripts";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "uwsm";
    rev = "master";
    hash = "sha256-20Q7MNJO1s6p1BzMKODGFYyOC5MHudA7y4m7lxB+Rkk=";
  };

  buildInputs = [
    systemd
    makeWrapper
  ];

  postInstall = ''
    install -D ./scripts/wait-tray.sh $out/bin/wait-tray
    chmod +x $out/bin/wait-tray

    wrapProgram $out/bin/wait-tray  \
      --prefix PATH : "${lib.makeBinPath [
      systemd
    ]}"
  '';

  meta = {
    description = "Universal Wayland Session Manager";
    homepage = "https://github.com/Vladimir-csp/uwsm/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    # mainProgram = "uwsm";
    platforms = lib.platforms.all;
  };
}
