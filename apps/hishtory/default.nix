{ pkgs, config, ... }:
let
  hishtory-config = pkgs.writeShellScript "hishtory-config.zsh" ./src/config.zsh;
in
{

  age.secrets.hishtory = {
    file = ../../secrets/hishtory.age;
  };

  # environment.systemPackages = with pkgs; [ hishtory ];
  home.packages = with pkgs; [ hishtory-config hishtory ];

  programs.zsh = {
    initExtra = ''
      . "${pkgs.lib.getExe hishtory-config}"

      # if [ ! -f ~/.hishinited ]
      # then
      #   ${pkgs.lib.getExe pkgs.hishtory} init "$(cat ${config.age.secrets.hishtory.path})"
      #   touch ~/.hishinited
      # fi
    '';
  };

}
