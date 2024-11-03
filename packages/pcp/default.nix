{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  which,
  bintools,
  autoreconfHook,
  libtool,
  gettext,
  python3,
  autoconf,
  automake,
}:
stdenv.mkDerivation rec {
  pname = "pcp";
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "performancecopilot";
    repo = "pcp";
    rev = version;
    hash = "sha256-2Gre8N8Z5CgQ2nsZOFxo+vLszGAUQIaI6bwFu8KoeRQ=";
  };

  nativeBuildInputs = [
    pkg-config
    bintools
    # autoreconfHook
    autoconf
    automake
  ];

  buildInputs = [
    which
    bintools
    libtool
    gettext
  ];

  meta = with lib; {
    description = "Performance Co-Pilot";
    homepage = "https://github.com/performancecopilot/pcp";
    changelog = "https://github.com/performancecopilot/pcp/blob/${src.rev}/CHANGELOG";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "pcp";
    platforms = platforms.all;
  };
}
