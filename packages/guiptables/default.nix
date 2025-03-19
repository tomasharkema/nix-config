{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "guiptables";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "RamonGiovane";
    repo = "guiptables";
    rev = version;
    hash = "sha256-lQBtZcdHKLWZVWfeDVJe1PYKUq6yohoC6mblsGw+u8g=";
  };
  installPhase = ''
    ls -la .
    mkdir -p $out/share/cockpit/guiptables
    cp -a .  $out/share/cockpit/guiptables
  '';
  meta = {
    description = "A Graphic User Interface for Linux's Iptables Firewall. Made with Cockpit for CentOS";
    homepage = "https://github.com/RamonGiovane/guiptables";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "guiptables";
    platforms = lib.platforms.all;
  };
}
