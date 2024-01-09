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
  enzian = {
    imports = [self.nixosConfigurations.enzian.config];
    # modules = [ self.nixosConfigurations.enzian.config ];
    specialArgs = attrs;
    deployment = {
      tags = ["bare"];
      targetHost = "100.67.118.80";
      # targetHost = "192.168.178.46";
      targetUser = "root";
    };
  };
  silver-star-ferdorie = {
    imports = [self.nixosConfigurations.silver-star-ferdorie.config];
    # modules = [ self.nixosConfigurations.enzian.config ];
    specialArgs = attrs;
    deployment = {
      # targetHost = "100.85.77.114";
      targetHost = "192.168.0.18";
      targetUser = "root";
      tags = ["vm"];
    };
  };

  # defaults = import ./apps/defaults.nix;

  # enzian = import ./machines/enzian/default.nix;

  # utm-nixos = import ./machines/utm-nixos/default.nix;

  # silver-star-ferdorie = import ./machines/silver-star-ferdorie/default.nix;
}
# {
#         meta = {
#           machinesFile = /etc/nix/machines;
#           nixpkgs = import nixpkgs {
#             system = "x86_64-linux";
#             overlays = [ ];
#           };
#         };
#         enzian = {
#           imports = [ self.nixosConfigurations.enzian.config ];
#           # deployment.tags = [ "bare" ];
#           deployment = {
#             tags = [ "bare" ];
#             targetHost = "100.67.118.80";
#             # targetHost = "192.168.178.46";
#             targetUser = "root";
#           };
#         };
#         # defaults = import ./apps/defaults.nix;
#         # enzian = import ./machines/enzian/default.nix;
#         # utm-nixos = import ./machines/utm-nixos/default.nix;
#         # silver-star-ferdorie = import ./machines/silver-star-ferdorie/default.nix;
#       };

