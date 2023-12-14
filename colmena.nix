{
  self,
  nixpkgs,
  ...
} @ attrs: {
  meta = {
    # machinesFile = /etc/nix/machines;
    nixpkgs = import nixpkgs {
      system = "x86_64-linux";
      # overlays = [ ];
    };
  };
  enceladus = {
    imports = [self.nixosConfigurations.enceladus.config];
    # modules = [ self.nixosConfigurations.enceladus.config ];
    specialArgs = attrs;
    deployment = {
      tags = ["bare"];
      targetHost = "100.67.118.80";
      # targetHost = "192.168.178.46";
      targetUser = "root";
    };
  };
  unraidferdorie = {
    imports = [self.nixosConfigurations.unraidferdorie.config];
    # modules = [ self.nixosConfigurations.enceladus.config ];
    specialArgs = attrs;
    deployment = {
      # targetHost = "100.85.77.114";
      targetHost = "192.168.0.18";
      targetUser = "root";
      tags = ["vm"];
    };
  };

  # defaults = import ./apps/defaults.nix;

  # enceladus = import ./machines/enceladus/default.nix;

  # utm-nixos = import ./machines/utm-nixos/default.nix;

  # unraidferdorie = import ./machines/unraidferdorie/default.nix;
}
# {
#         meta = {
#           machinesFile = /etc/nix/machines;
#           nixpkgs = import nixpkgs {
#             system = "x86_64-linux";
#             overlays = [ ];
#           };
#         };
#         enceladus = {
#           imports = [ self.nixosConfigurations.enceladus.config ];
#           # deployment.tags = [ "bare" ];
#           deployment = {
#             tags = [ "bare" ];
#             targetHost = "100.67.118.80";
#             # targetHost = "192.168.178.46";
#             targetUser = "root";
#           };
#         };
#         # defaults = import ./apps/defaults.nix;
#         # enceladus = import ./machines/enceladus/default.nix;
#         # utm-nixos = import ./machines/utm-nixos/default.nix;
#         # unraidferdorie = import ./machines/unraidferdorie/default.nix;
#       };

