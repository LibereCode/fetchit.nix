{ self, inputs, ... }:
{
  imports = [
    ./packages
    ./modules
  ];

  systems = [
    "x86_64-linux"
    #NOTE: need testing for other systems
  ];

  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;
    };
}
