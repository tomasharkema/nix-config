{
  lib,
  buildGoModule,
  fetchFromGitHub,
  autoPatchelfHook,
}:
buildGoModule rec {
  pname = "vgpu-device-manager";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "vgpu-device-manager";
    rev = "v${version}";
    hash = "sha256-WqTLvK9FcRWFA3qGZoRRA5W/UOGvTEawA/eUdD7BS/M=";
  };

  nativeBuildInputs = [autoPatchelfHook];

  vendorHash = null;

  ldflags = ["-s" "-w"];

  doCheck = false;

  postInstall = ''
    rm -rf $out/bin/nvidia-k8s-vgpu-dm
  '';

  meta = with lib; {
    description = "NVIDIA vGPU Device Manager manages NVIDIA vGPU devices on top of Kubernetes";
    homepage = "https://github.com/NVIDIA/vgpu-device-manager";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "nvidia-vgpu-dm";
  };
}
