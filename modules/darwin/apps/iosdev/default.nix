{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      cocoapods
      # xcodes
      xcbeautify
      xcpretty
      # swiftbar
      swiftlint
      # swiftformat
    ];
  };
}
