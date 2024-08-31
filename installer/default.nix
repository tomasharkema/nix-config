{
  inputs,
  channels,
}: {
  iso = import ./iso.nix {
    inherit inputs;
    inherit channels;
  };
  img = import ./img.nix {
    inherit inputs;
    inherit channels;
  };
  netboot = import ./netboot.nix {
    inherit inputs;
    inherit channels;
  };
}
