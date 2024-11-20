{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "vgpu-device-manager";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "vgpu-device-manager";
    rev = "v${version}";
    hash = "sha256-/6KF1YP7/HakTmG4960hhq2MhBQiw+hnOWo/cw/BDT8=";
  };

  vendorHash = null;

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "NVIDIA vGPU Device Manager manages NVIDIA vGPU devices on top of Kubernetes";
    homepage = "https://github.com/NVIDIA/vgpu-device-manager";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "vgpu-device-manager";
  };
}
