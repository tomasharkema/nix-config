{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libvirt,
  pkg-config,
}:
buildGoModule rec {
  pname = "virt-tui";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "nyanco01";
    repo = "virt-tui";
    rev = "v${version}";
    hash = "sha256-T/YT4ev9DJe3B2LdDsxMFci22r1k0fYZtB/PrTgPrD0=";
  };

  vendorHash = "sha256-69cQuTEb+MdPvOcByewWbgTYWT/3ABxUb1sPVszB8lk=";

  ldflags = ["-s" "-w"];

  nativeBuildInputs = [pkg-config];
  buildInputs = [libvirt];
  meta = with lib; {
    description = "";
    homepage = "https://github.com/nyanco01/virt-tui";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "virt-tui";
  };
}
