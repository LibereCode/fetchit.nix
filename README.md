# Fetchit-flake

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
      url = "github:liberecode/omnisearch-flake";
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

> [!WARNING]
> NOT IMPLEMENTED YET

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

      ## Will be applied to omnisearch's config.ini
      settings = {
        ## ... settings here ...
        ## example that evaluates to the original example:
        column_padding = 2;
        art = {
          source = "./logo.txt";
        };
        functions = {
          fetch = {
            ## (need to be a list of lists)
            columns = [
              [
                "art.out"
              ]
              [
                "color.red(user.name .. '@' .. host.name)"
                "color.yellow('os:')"
                "color.green('kernel:')"
                "color.cyan('cpu:')"
                "color.blue('gpu:')"
                "color.magenta('ram:')"
              ]
              [
                "''"
                "string.lower(os.name)"
                "string.lower(kernel.sysname)..' '..kernel.release"
                "string.lower(cpu.name)"
                "string.lower(gpu.name)"
                ''
                string.format(
                  '%.1fGB/%.1fGB (%.1f%%)',
                  memory.used_gb, memory.total_gb, memory.percent
                )
                ''
              ]
            ];
          };
        };
      };
    };
  };
}
```

## LICENSE

This [EUPL](./LICENSE) only extends toward this repo (and not the source).
