{
  channels,
  # pkgs,
  # requireFile,
  # fetchFromGitHub,
  ...
}: final: prev: {
  # atuin = prev.atuin.overrideAttrs (old: rec {
  #   name = "atuin";
  #   version = "17.10.0";

  #   # pkgs = channels.nixpkgs {
  #   #   inherit (prev) system;
  #   # };
  #   pkgs = prev;

  #   src = pkgs.fetchFromGitHub {
  #     owner = "atuinsh";
  #     repo = "atuin";
  #     rev = "v${version}";
  #     hash = "sha256-+qXKBHtEgMIh1kTb2z9M60GWMrPS8so79+7s+6ZEgyU=";
  #   };
  # });
}
