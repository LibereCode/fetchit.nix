{ inputs, self, ... }:
{
  flake.homeModules = {
    fetchit =
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

              # TODO ?
              # settings = mkOption {
              # };

              initLua = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
                description = lib.literalMD ''
                  init.lua as a stringblock.
                  If you want to source an external file, simply use:
                  ```nix
                  initLua = builtins.readFile ./init.lua;
                  ```
                '';
              };

              logos = lib.mkOption {
                type = types.nullOr (types.attrsOf types.str);
                default = null;
                description = lib.literalMD ''
                  logo.txt as a stringblock.
                  If you want to source an external file, simply use:
                  ```nix
                  logos = { "logos/logo.txt" = builtins.readFile ./logo.txt; };
                  ```
                '';
                example = {
                  "logos/logo.txt" = ''
                    *------*
                    | 0  0 |
                    |  --  |
                    *------*
                  '';
                  logo2 = ''
                     /\_/\ Schröd?
                    ( X_* )..   ((
                    >= ^ <=  _))
                    (__x__)-(__|-'
                  '';
                };
              };
            };

          };
        config = lib.mkIf cfg.enable {
          home.packages = [ pkg ];

          xdg.configFile = {
            "fetchit/init.lua" =
              if cfg.initLua != null then
                {
                  text = cfg.initLua;
                }
              else
                {
                  source = "${cfg.package}/share/pkgit/config/init.lua";
                };

          }
          // (
            if cfg.logos != null then
              lib.mapAttrs' (name: value: lib.nameValuePair ("fetchit/" + name) { text = value; }) cfg.logos
            else
              {
                "fetchit/logos/logo.txt".source = "${cfg.package}/share/pkgit/config/logos/logo.txt";
              }
          );
        };
      };
    default = self.homeModules.fetchit;
  };
}
