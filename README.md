# Fetchit-flake

> [!INFO]
> THIS REPO HAS BEEN MOVED TO [codeberg fetchit fork](https://codeberg.org/Kashnomo/fetchit-flake/src/branch/master)


## ABOUT

A **nix** wrapper of the [fastfetch](https://github.com/fastfetch-cli/fastfetch) alternative:
[fetchit](https://codeberg.org/nzuum/fetchit)

## USAGE

### Importing

```nix flake.nix
# flake.nix
{
  inputs = {
    # ... other inputs

    omnisearch-flake = {
      # url = "github:liberecode/omnisearch-flake";
      url = "git+https://codeberg.org/Kashnomo/fetchit-flake?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ... other inputs
  };

  outputs = {
    # ... other output-stuff
  };
}
```

### Adding package

```nix modules/nixos/stuff.nix
## Add this anywhere in your Nixos-config

## (optional) add this in your `let ... in` of the file
## (or just write the full string inline)
let
  inherit (pkgs.stdenv.hostPlatform) system;
  inherit (inputs.fetchit.packages.${system}) fetchit;
in

## for nixos:
environment.systemPackages = [
  inputs.fetchit.packages.${pkgs.stdenv.hostPlatform.system}.fetchit
  # fetchit # <- replacement if you added the let ... in
];

## for home-manager:
home.packages = [
  inputs.fetchit.packages.${pkgs.stdenv.hostPlatform.system}.fetchit
  # fetchit # <- replacement if you added the let ... in
];


```

### home-manager module

```nix modules/home/fetchit/default.nix
## Anywhere in your nix (home-manager) configuration.
## This examples show for a new file that has been imported at:
## <nix-config-dir>/modules/nixos/fetchit/default.nix
{ inputs, ... }: {

  ## This imports pkgs and options
  imports = [ inputs.omnisearch-flake.nixosModules.default ];

  config = {

    ## NOTE: For the homeModule
    programs.fetchit = {
      enable = true;

      ## if null will use default
      initLua = ''
        -- HELLO WORLD !
        column_padding = 2
        art = { source = "./logo2.txt" }
        function fetch()
          return {
            columns = {
              art.out,
              {
                color.red(user.name .. "@" .. host.name),
                color.yellow("os:"),
              },
              {
                "",
                string.lower(os.name),
              }
            }
          }
        end
      '';

      ## if null will use default
      logos = {
        ## Files added to ~/.config/fetchit/*
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
}
```

## LICENSE

This [EUPL](./LICENSE) only extends toward this repo (and not the source).
