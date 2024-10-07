{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  kernel ? pkgs.linuxPackages_latest.kernel,
}:
stdenv.mkDerivation rec {
  pname = "amifldrv";
  version = "unstable-2022-03-31-${kernel.version}";

  src = fetchFromGitHub {
    owner = "flohoff";
    repo = "amifldrv";
    rev = "fcaeb6adf38fd96cc3a59c8377456cf043307935";
    hash = "sha256-2hM8sdY1LjVjogFAxYLbndVvdGMuVdRokQPD4dkSWks=";
  };

  patches = [./kernel.patch];

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = ["KERNEL=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin/
    install -D amifldrv_mod.ko $out/lib/modules/${kernel.modDirVersion}/misc/amifldrv_mod.ko

    ln -s $out/lib/modules/${kernel.modDirVersion}/misc/amifldrv_mod.ko $out/lib/modules/${kernel.modDirVersion}/misc/amifldrv_mod
    ln -s $out/lib/modules/${kernel.modDirVersion}/misc/amifldrv_mod.ko $out/lib/modules/${kernel.modDirVersion}/misc/amifldrv_mod.o

    runHook postInstall
  '';

  meta = with lib; {
    description = "AMI BIOS Aptio kernel flash driver";
    homepage = "https://github.com/flohoff/amifldrv";
    # license = licenses.unfree; # FIXME: nix-init did not found a license
    # maintainers = with maintainers; [ ];
    mainProgram = "amifldrv";
    platforms = platforms.all;
  };
}
