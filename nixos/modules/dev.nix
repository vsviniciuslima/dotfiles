{ pkgs, inputs, ... }:

{
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
  ];

  myConfig.zshScripts = [
    ./dev-nix.zsh
  ];
}
