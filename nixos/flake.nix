{
  description = "NixOS master configuration with Claude Desktop & Claude Code";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # NixOs CLI
    nixos-cli.url = "github:nix-community/nixos-cli";

    # Claude
    ## 1. Claude Code (CLI tool)
    claude-code.url = "github:sadjow/claude-code-nix";
    claude-code.inputs.nixpkgs.follows = "nixpkgs";

    ## 2. Claude Desktop (GUI application)
    claude-desktop.url = "github:poeck/claude-desktop-nix-flake";
    claude-desktop.inputs.nixpkgs.follows = "nixpkgs";

    # shdoc 
    shdoc-src = {
      url = "github:reconquest/shdoc"; 
      flake = false; 
    };

  };

  outputs = { 
    self, 
    nixpkgs, 
    nixos-cli,
    claude-code, 
    claude-desktop, 
    shdoc-src,
    ... 
  }@inputs: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      # Passes all input repositories down into your configuration.nix file
      specialArgs = { 
        inherit inputs shdoc-src; 
      };

      modules = [
        ./hosts/desktop/configuration.nix
        nixos-cli.nixosModules.nixos-cli
        # Add this line to import the official module directly into your system
        inputs.claude-desktop.nixosModules.default
      ];
    };
  };
}
