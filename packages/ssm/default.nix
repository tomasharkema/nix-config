# https://github.com/elliot40404/ssm
{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "ssm";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "elliot40404";
    repo = "ssm";
    rev = "v${version}";
    hash = "sha256-bx1I8IW6YvUDTjj5O9WwbXMb7s+HUt1BOsPBzgN8gjw=";
  };

  vendorHash = null;
}
