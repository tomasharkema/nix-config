{
  config,
  pkgs,
  requireFile,
  fetchFromGitHub,
  ...
}: self: super: {
  atuin = super.atuin.overrideAttrs (old: rec {
    name = "atuin";
    version = "17.10";

    src = fetchFromGitHub {
      owner = "atuinsh";
      repo = "atuin";
      rev = "v${version}";
      hash = "sha256-+qXKBHtEgMIh1kTb2z9M60GWMrPS8so79+7s+6ZEgyU=";
    };
  });
}
