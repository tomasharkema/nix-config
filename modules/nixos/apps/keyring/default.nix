{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [python3Packages.keyring custom.onepassword_keyring];

    home-manager.users.tomas.xdg.configFile = {
      "python_keyring/keyringrc.cfg".source = pkgs.writeText "keyringrc.cfg" ''
        [backend]
        default-keyring=onepassword_keyring.OnePasswordBackend
        keyring-path=${pkgs.custom.onepassword_keyring}
      '';
    };
  };
}
