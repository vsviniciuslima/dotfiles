{ pkgs, shdoc-src, ... }:

let
  shdoc = pkgs.stdenvNoCC.mkDerivation {
    pname = "shdoc";
    version = "1.4";

    src = shdoc-src;

    nativeBuildInputs = [
      pkgs.gawk
    ];

    dontBuild = true;

    installPhase = ''
      install -Dm755 shdoc $out/bin/shdoc
    '';

    meta = {
      description = "Documentation generator for bash, sh and zsh";
      homepage = "https://github.com/reconquest/shdoc";
      license = pkgs.lib.licenses.mit;
      mainProgram = "shdoc";
      platforms = pkgs.lib.platforms.unix;
    };
  };
in
{
  programs.zsh = {
    enable = true;

    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      theme = "gozilla";
      plugins = [ "git" "docker" ];
    };

    shellAliases = {
      lse = "eza --icons";
      cat = "bat";
      nix-update = "sudo nixos-rebuild switch";
    };
  };

  programs.nixos-cli = {
    enable = true;
    # settings = {
    #   # Whatever settings desired.
    # }
  };

  environment.systemPackages = [
    shdoc
  ];
}
