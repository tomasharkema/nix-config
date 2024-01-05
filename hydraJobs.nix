{
  channels,
  inputs,
  ...
}:
with channels.nixpkgs.lib; let
  pkgs = channels.nixpkgs;
  #   packages =
  #     filterAttrs (system: v: (system == "x86_64-linux")) # || system == "aarch64-linux"))
  #     inputs.self.packages;
  #   devShells =
  #     filterAttrs (system: v: (system == "x86_64-linux")) # || system == "aarch64-linux"))
  #     inputs.self.devShells;
  #   hosts =
  #     builtins.mapAttrs (n: v: v.config.system.build.toplevel)
  #     inputs.self.nixosConfigurations;
  tr = builtins.trace "hallo ${channels}";
in
  with tr;
    {
      # inherit packages;
      #inherit (inputs.self) images;
      #inherit (inputs.self) checks;
      # inherit devShells;
      # inherit hosts;
    }
    // {
      devShells = inputs.self.devShells.${pkgs.system};
      checks = {
        lint = pkgs.custom.run-checks;
      };
      # packages = {
      #   nixos-hosts = channels.nixpkgs.nixos-hosts.override {
      #     hosts = inputs.self.nixosConfigurations;
      #   };
      # };
    }
