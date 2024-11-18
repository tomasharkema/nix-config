{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "virt-lightning";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "virt-lightning";
    repo = "virt-lightning";
    rev = version;
    hash = "sha256-5HXHm0jFcfmsioECfd1ILVaS3qZG4XuZjRz9y/26M4o=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    libvirt-python
    pyyaml
    urwid
  ];

  pythonImportsCheck = ["virt_lightning"];

  meta = with lib; {
    description = "Starts your VM on libvirt in a couple of seconds";
    homepage = "https://github.com/virt-lightning/virt-lightning";
    changelog = "https://github.com/virt-lightning/virt-lightning/blob/${src.rev}/changelog.md";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "virt-lightning";
  };
}
