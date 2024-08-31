{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [python3Packages.keyring custom.onepassword_keyring];
  };
}
