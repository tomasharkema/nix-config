{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixConfigurations.hydra-docker = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};
      modules = [
        ({...}: {
          config = {
            system.stateVersion = "23.11";
            services.hydra = {
              enable = true;
              hydraURL = "http://localhost:3000";
              notificationSender = "hydra@localhost";
              buildMachinesFiles = [];
              useSubstitutes = true;
            };
            boot.isContainer = true;
          };
        })
      ];
    };
  };
}
