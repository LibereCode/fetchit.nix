{ self, inputs, ... }:
{
  perSystem =
    { pkgs, config, ... }:
    {
      packages = {
        fetchit = pkgs.callPackage ./fetchit.nix { };
        default = config.packages.fetchit;
      };
    };
}
