{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "mesh-agent";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Ylianst";
    repo = "MeshAgent";
    rev = "MeshCentral_v${version}";
    hash = "sha256-mppTMYUT+aSj2j4NNAiyimO8hEozHEIrmqNKaucnn6U=";
  };

  meta = with lib; {
    description = "MeshAgent used along with MeshCentral to remotely manage computers. Many variations of the background management agent are included as binaries in the MeshCentral project";
    homepage = "https://github.com/Ylianst/MeshAgent";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "mesh-agent";
    platforms = platforms.all;
  };
}
