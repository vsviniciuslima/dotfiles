{ inputs, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm-bak";
  home-manager.users.viniciussl = import ../home/viniciussl.nix;
}
