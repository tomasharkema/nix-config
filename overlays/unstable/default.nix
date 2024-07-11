{
  channels,
  disko,
  self,
  inputs,
  ...
}: final: prev: rec {
  unstable = channels.unstable;

  pnpm = channels.unstable.pnpm;

  conky = inputs.conky.packages."${prev.system}".default;
  # conky = channels.unstable.conky.overrideAttrs {
  #   x11Support = false;
  #   waylandSupport = true;
  #   nvidiaSupport = true;
  # };
}
