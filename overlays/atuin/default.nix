{
  channels,
  # pkgs,
  # requireFile,
  # fetchFromGitHub,
  ...
}: final: prev: {
  # atuin = prev.atuin.overrideAttrs (old: rec {
  #   name = "atuin";
  #   version = "17.1.0";
  #   cargoHash = "";
  #   src = prev.fetchFromGitHub {
  #     owner = "atuinsh";
  #     repo = "atuin";
  #     rev = "5bef19ba4cca71f90094f9d7c3c7d25a6d8af8a3";
  #     hash = "sha256-COJ4UIH3iXpe8p0mNWM4KXeyejca5pzXyQAAKGQO54Q=";
  #   };
  # });
}
