{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation rec {
  # https://github.com/tim77/awesome-icewm/tree/master/themes/IceAdwaita-Dark-Medium-alpha

  pname = "awesome-icewm";
  version = "0.0.1-da8173b";

  src = fetchFromGitHub {
    owner = "tim77";
    repo = "${pname}";
    rev = "da8173bb6bc5a01ca4b512a5d1b7850035f710e5";
    hash = "sha256-hIcv9VKBa831iFuC2HT4F6palqNE2oU8IQoEnp1pntE=";
  };

  phases = ["unpackPhase" "installPhase"];
  postInstall = ''
    mkdir $out
    cp -rv . $out
  '';
}
