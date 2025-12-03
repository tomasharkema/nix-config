{
  channels,
  disko,
  self,
  inputs,
  ...
}: final: prev: let
  lib = prev.lib;
in {
  # picotool = prev.picotool.overrideAttrs ({cmakeFlags ? [], ...}: {
  #   cmakeFlags =
  #     cmakeFlags
  #     ++ [
  #       (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  #     ];
  # });

  # csdr = prev.csdr.overrideAttrs ({cmakeFlags ? [], ...}: {
  #   cmakeFlags =
  #     cmakeFlags
  #     ++ [
  #       (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  #     ];
  # });

  # gt = prev.gt.overrideAttrs ({cmakeFlags ? [], ...}: {
  #   cmakeFlags =
  #     cmakeFlags
  #     ++ [
  #       (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  #     ];
  # });

  # smuview = prev.smuview.overrideAttrs ({cmakeFlags ? [], ...}: {
  #   cmakeFlags =
  #     cmakeFlags
  #     ++ [
  #       (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  #     ];
  # });

  # # plotinus = prev.plotinus.overrideAttrs ({cmakeFlags ? [], ...}: {
  # #   cmakeFlags =
  # #     cmakeFlags
  # #     ++ [
  # #       (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  # #     ];
  # # });

  # sdrpp = prev.sdrpp.overrideAttrs ({cmakeFlags ? [], ...}: {
  #   cmakeFlags =
  #     cmakeFlags
  #     ++ [
  #       (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  #     ];
  # });

  # digiham = prev.digiham.overrideAttrs ({cmakeFlags ? [], ...}: {
  #   cmakeFlags =
  #     cmakeFlags
  #     ++ [
  #       (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  #     ];
  # });

  # dsview = prev.dsview.overrideAttrs ({cmakeFlags ? [], ...}: {
  #   cmakeFlags =
  #     cmakeFlags
  #     ++ [
  #       (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  #     ];
  # });

  # airspyhf = prev.airspyhf.overrideAttrs ({cmakeFlags ? [], ...}: {
  #   cmakeFlags =
  #     cmakeFlags
  #     ++ [
  #       (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  #     ];
  # });
}
