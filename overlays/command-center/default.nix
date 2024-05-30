{
#command-center,
... }:
final: prev:
{
  #command-center = command-center.packages.${prev.system}.default;
}
