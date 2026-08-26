{ inputs, self, ... }:
{
  flake.homeModules.default =
    per@{
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.programs.fetchit;
      inherit (pkgs.stdenv.hostPlatform) system;
      pkg = self.packages.${system}.fetchit;
    in
    {
      options =
        let
          inherit (lib)
            types
            mkOption
            mkEnableOption
            ;
        in
        {
          packages.fetchit = {
            enable = mkEnableOption "fetchit";

            package = mkOption {
              type = types.package;
              default = pkg;
              description = lib.literalMD "`fetchit` **package** to use.";
            };

            settings = mkOption {
            };

          };

          config = lib.mkIf cfg.enable {
            home.packages = [ pkg ];

            xdg.configFile."fetchit".source = "${cfg.package}/share/pkgit/config";
          };
        };
    };
}
