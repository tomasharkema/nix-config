{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "dell-rbu-module";
  version = "8.2.0";

  src = fetchFromGitHub {
    owner = "xcp-ng-rpms";
    repo = "dell-rbu-module";
    rev = version;
    hash = "sha256-9W6U2WDDg++QkynhE4AKUvg6y9EiLHxUxP9rjei7qB0=";
  };

  sourceRoot = "${src.name}/SOURCES";

  meta = with lib; {
    description = "RPM sources for dell-rbu-module";
    homepage = "https://github.com/xcp-ng-rpms/dell-rbu-module";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "dell-rbu-module";
    platforms = platforms.all;
  };
}
