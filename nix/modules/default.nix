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
          programs.fetchit = {
            enable = mkEnableOption "fetchit";

            package = mkOption {
              type = types.package;
              default = pkg;
              description = lib.literalMD "`fetchit` **package** to use.";
            };

            # settings = mkOption {
            # };

            initLua = lib.mkOption {
              type = types.nullOr types.string;
              default = null;
              description = lib.literalMD ''
                init.lua as a stringblock.
                If you want to source an external file, simply use:
                ```nix
                initLua = builtins.readFile ./init.lua;
                ```
              '';
            };
          };

        };
      config = lib.mkIf cfg.enable {
        home.packages = [ pkg ];

        xdg.configFile."fetchit" =
          if cfg.initLua != null then
            {
              text = cfg.initLua;
            }
          else
            {
              source = "${cfg.package}/share/pkgit/config";
            };
      };
    };
}
