{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    environment.systemPackages = with pkgs; [
      # cocoapods
      # xcodes
      # xcbeautify
      # xcpretty
      # swiftbar
      # swiftlint
      # swiftformat
    ];
  };
}
