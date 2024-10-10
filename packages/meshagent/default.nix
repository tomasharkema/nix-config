{
  lib,
  stdenv,
  fetchFromGitHub,
  libjpeg,
  pkg-config,
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

  nativeBuildInputs = [
    libjpeg
    pkg-config
  ];

  MESH_AGENTID = "6";
  ARCHID = "6";

  buildPhase = ''
    make linux ARCHID=6
  '';

  # buildPhase = ''
  #   # runHook preBuild
  #   sleep 1000
  #   make linux ARCHID=6						# Linux x86 64 bit

  #   # runHook postBuild
  # '';

  meta = with lib; {
    description = "MeshAgent used along with MeshCentral to remotely manage computers. Many variations of the background management agent are included as binaries in the MeshCentral project";
    homepage = "https://github.com/Ylianst/MeshAgent";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "mesh-agent";
    platforms = platforms.all;
  };
}
