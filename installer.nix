{pkgs, ...}: let
  keys = pkgs.callPackage ./packages/authorized-keys {};
in {
  config = {
    users.users.tomas = {
      shell = pkgs.zsh;
      isNormalUser = true;
      description = "tomas";
      group = "tomas";
      extraGroups = ["networkmanager" "wheel" "rslsync" "users" "fuse" "disk" "plugdev" "dailout"];
      hashedPassword = "$6$7mn5ofgC1ji.lkeT$MxTnWp/t0OOblkutiT0xbkTwxDRU8KneANYsvgvvIVi1V3CC3kRuaF6QPJv1qxDqvAnJmOvS.jfkhtT1pBlHF.";

      openssh.authorizedKeys.keyFiles = ["${keys}"];
    };
    users.groups.tomas = {};
    programs.zsh.enable = true;

    environment.systemPackages = with pkgs; [git curl wget];
  };
}
