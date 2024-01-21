{inputs, ...}: let
  lib = inputs.nixpkgs.lib;
  packages =
    lib.filterAttrs (system: v: (system == "x86_64-linux" || system == "aarch64-linux"))
    inputs.self.packages;
  # devShells =
  #   lib.filterAttrs (system: v: (system == "x86_64-linux" || system == "aarch64-linux"))
  #   inputs.self.devShells;
  # defaultPackage =
  #   lib.filterAttrs (system: v: (system == "x86_64-linux" || system == "aarch64-linux"))
  #   inputs.self.defaultPackage;
  # hosts =
  #   builtins.mapAttrs (n: v: v.config.system.build.installTest)
  #   inputs.self.nixosConfigurations;
  #hosts =
  #builtins.mapAttrs (n: v: v.config.system.build.toplevel)
  #inputs.self.nixosConfigurations;
in {
  inherit packages;
  # images = {
  #   installer = inputs.self.images.installer;
  # };
  #inherit (inputs.self) checks;
  # inherit devShells;
  #inherit hosts;
  # inherit defaultPackage;
}
# // {
# defaultPackage = inputs.self.defaultPackage.x86_64-linux;
# devShells = inputs.self.devShells.${pkgs.system};
# packages = {
#   nixos-hosts = channels.nixpkgs.nixos-hosts.override {
#     hosts = inputs.self.nixosConfigurations;
#   };
# };
# }

