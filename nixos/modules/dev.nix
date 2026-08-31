{ pkgs, inputs, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries = pkgs.steam-run.args.multiPkgs pkgs;
  };


  # Enable the Docker daemon
  virtualisation.docker.enable = true;

  # (Optional but recommended) Enable rootless mode for better security
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Development CLI tools and packages
  environment.systemPackages = with pkgs; [
    git
    gh
    vim
    fzf
    ripgrep
    eza
    bat
    zoxide

    docker
    lazydocker

    devin-desktop
    # Claude Code CLI tool
    inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default
    claude-agent-acp

    (python3.withPackages (ps: with ps; [
      mkdocs
      mkdocs-material
    ]))
  ];

  myConfig.zshScripts = [
    ./dev-nix.zsh
  ];

  home-manager.users.viniciussl = { config, ... }: {
    
    home.packages = with pkgs; [
      nodejs
    ];

    home.sessionVariables = {
      NODE_PATH = "$HOME/.npm-packages/lib/node_modules";
    };

    home.sessionPath = [
      "$HOME/.npm-packages/bin"
      "$HOME/.local/bin"
    ];

    # 2. This 'config' now refers to the Home Manager context safely!
    home.file.".npmrc".text = ''
      prefix=${config.home.homeDirectory}/.npm-packages
    '';
  };

}
