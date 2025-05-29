{
  description = "A Typst project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.11";

    typix = {
      url = "github:loqusion/typix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Example of downloading icons from a non-flake source
    # font-awesome = {
    #   url = "github:FortAwesome/Font-Awesome";
    #   flake = false;
    # };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    typix,
    flake-utils,
    nix-github-actions,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (pkgs) lib;

      typixLib = typix.lib.${system};

      typstSrc = typixLib.cleanTypstSource ./.;
      src = lib.fileset.toSource {
        root = ./.;
        fileset = lib.fileset.unions [
          (lib.fileset.fromSource typstSrc)
          ./figures
        ];
      };

      commonArgs = {
        typstSource = "main.typ";

        fontPaths = [
          # Add paths to fonts here
          # "${pkgs.roboto}/share/fonts/truetype"
        ];

        virtualPaths = [
          # Add paths that must be locally accessible to typst here
          # {
          #   dest = "icons";
          #   src = "${inputs.font-awesome}/svgs/regular";
          # }
        ];
      };

      unstable_typstPackages = [
        {
          name = "muchpdf";
          version = "0.1.0";
          hash = "sha256-p04JDPChl5SGLGy+6ybQ51pTzKGkDT/1UVhXnqfduaQ=";
        }
        {
          name = "cades";
          version = "0.3.0";
          hash = "sha256-ql745M6B7mT04/sAQabccMljJPeDzoNxnkejqUClqBc=";
        }
        {
          name = "wrap-it";
          version = "0.1.1";
          hash = "sha256-XUo7cbJVlgxVuf2nu2ps1WFnejtcr/VEDt1igB6ggsQ=";
        }
        {
          name = "jogs";
          version = "0.2.0";
          hash = "sha256-hhp43vV9spT2GTGKd5jIPbfydSNLcZEip8xzVaztfss=";
        }
      ];

      # Compile a Typst project, *without* copying the result
      # to the current directory
      build-drv = typixLib.buildTypstProject (commonArgs
        // {
          inherit src;
          inherit unstable_typstPackages;
        });

      # Compile a Typst project, and then copy the result
      # to the current directory
      build-script = typixLib.buildTypstProjectLocal (commonArgs
        // {
          inherit src;
          inherit unstable_typstPackages;
        });

      # Watch a project and recompile on changes
      watch-script = typixLib.watchTypstProject commonArgs;
    in {
      checks = {
        inherit build-drv build-script watch-script;
      };

      packages.default = build-drv;

      apps = rec {
        default = watch;
        build = flake-utils.lib.mkApp {
          drv = build-script;
        };
        watch = flake-utils.lib.mkApp {
          drv = watch-script;
        };
      };

      devShells.default = typixLib.devShell {
        inherit (commonArgs) fontPaths virtualPaths;
        packages = [
          # WARNING: Don't run `typst-build` directly, instead use `nix run .#build`
          # See https://github.com/loqusion/typix/issues/2
          # build-script
          watch-script
          # More packages can be added here, like typstfmt
          # pkgs.typstfmt
        ];
      };

    }) // {
      githubActions = nix-github-actions.lib.mkGithubMatrix { checks = self.packages; };
    };
}
