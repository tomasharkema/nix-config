{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "mackerel-plugin-nfs";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "y-kuno";
    repo = "mackerel-plugin-nfs";
    rev = "v${version}";
    hash = "sha256-gesjXIbDC8UTx9H+NnktS7ID1AYIHn3CFWGHBlfhE6Q=";
  };

  patches = [./mod.patch];

  vendorHash = "sha256-Vrku4H/A+7xzc/+K0VjM+aqGx3Geta5d9AHZ3fiQpr0=";

  meta = with lib; {
    description = "NFS client plugin for mackerel.io agent";
    homepage = "https://github.com/y-kuno/mackerel-plugin-nfs";
    changelog = "https://github.com/y-kuno/mackerel-plugin-nfs/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "mackerel-plugin-nfs";
    platforms = platforms.all;
  };
}
