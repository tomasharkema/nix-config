{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation rec {
  # https://github.com/tim77/awesome-icewm/tree/master/themes/IceAdwaita-Dark-Medium-alpha

  pname = "awesome-icewm";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "tim77";
    repo = "${pname}";
    rev = "master";
    hash = "sha256-hIcv9VKBa831iFuC2HT4F6palqNE2oU8IQoEnp1pntE=";
  };

  phases = ["unpackPhase" "installPhase"];
  postInstall = ''
    mkdir $out
    cp -rv . $out
  '';
}
