{
  lib,
  stdenv,
  ccacheStdenv,
  fetchFromGitHub,
  libjpeg,
  pkg-config,
  xorg,
}:
# ccacheStdenv
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

  buildInputs = [
    xorg.libX11.dev
    xorg.xorgproto
    xorg.libXtst
    xorg.xinput
    xorg.libXi
  ];

  # MESH_AGENTID = "6";
  ARCHID = "6";

  buildPhase = ''
    # set -x

    runHook preBuild

    make linux #ARCHID=6						# Linux x86 64 bit

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp meshagent_x86-64 $out/bin/mesh-agent
  '';

  meta = with lib; {
    description = "MeshAgent used along with MeshCentral to remotely manage computers. Many variations of the background management agent are included as binaries in the MeshCentral project";
    homepage = "https://github.com/Ylianst/MeshAgent";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "mesh-agent";
    platforms = platforms.all;
  };
}
# (wget "https://meshcentral.harkema.io/meshagents?script=1" -O ./meshinstall.sh || wget "https://meshcentral.harkema.io/meshagents?script=1" --no-proxy -O ./meshinstall.sh) && chmod 755 ./meshinstall.sh && sudo -E ./meshinstall.sh https://meshcentral.harkema.io '13OZYE2g4Zm1qm3bkwUR43GX2Vghz2ylcfy3WVglwnrv3fwgwhXfVc@eCGNljHLL' || ./meshinstall.sh https://meshcentral.harkema.io '13OZYE2g4Zm1qm3bkwUR43GX2Vghz2ylcfy3WVglwnrv3fwgwhXfVc@eCGNljHLL'

