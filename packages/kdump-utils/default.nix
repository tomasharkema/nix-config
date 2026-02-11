{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
}:
stdenv.mkDerivation rec {
  pname = "kdump-utils";
  version = "1.0.59";

  src = fetchFromGitHub {
    owner = "rhkdump";
    repo = "kdump-utils";
    rev = "v${version}";
    hash = "sha256-d5yDhoRoDCWQ7C/D0DzsBLaxrG6yYUFZs+z6icvNrAI=";
  };

  makeFlags = [
    #"prefix=${placeholder "out"}"

    "DESTDIR=${placeholder "out"}"
    "prefix="
  ];

  preInstall = ''
    substituteInPlace ./gen-kdump-conf.sh \
      --replace-fail "/bin/bash" "${bash}/bin/bash"
    substituteInPlace ./gen-kdump-sysconfig.sh \
      --replace-fail "/bin/bash" "${bash}/bin/bash"
  '';

  postInstall = ''
    ls -la .
  '';

  meta = {
    description = "Kernel crash dump collection utilities";
    homepage = "https://github.com/rhkdump/kdump-utils";
    changelog = "https://github.com/rhkdump/kdump-utils/blob/${src.rev}/changelog";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "kdump-utils";
    platforms = lib.platforms.all;
  };
}
