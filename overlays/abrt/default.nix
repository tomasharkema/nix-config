{
  channels,
  disko,
  self,
  inputs,
  ...
}: final: prev: {
  satyr = self.packages."${prev.system}".satyr;
  libreport = self.packages."${prev.system}".libreport;
  abrt = self.packages."${prev.system}".abrt;
  gnome-abrt = self.packages."${prev.system}".gnome-abrt;
  will-crash = self.packages."${prev.system}".will-crash;
}
