{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "vgpu-unlock-patcher";
  version = "550.90";

  src = fetchFromGitHub {
    owner = "VGPU-Community-Drivers";
    repo = "vGPU-Unlock-patcher";
    rev = "8f19e550540dcdeccaded6cb61a71483ea00d509"; # "${version}";
    hash = "sha256-TyZkZcv7RI40U8czvcE/kIagpUFS/EJhVN0SYPzdNJM=";
    fetchSubmodules = true;
  };

  patches = [./750ti.patch];

  postInstall = ''
    mkdir -p $out/bin
    cp -r . $out/bin

    chmod +x $out/bin/patch.sh
  '';
}
