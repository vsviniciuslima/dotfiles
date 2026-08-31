{ config, pkgs, ... }:
{
  home.username = "viniciussl";
  home.homeDirectory = "/home/viniciussl";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "vsviniciuslima";
    userEmail = "vsviniciuslima@usp.br";
    extraConfig = {
      credential."https://github.com".helper = "!gh auth git-credential";
      credential."https://gist.github.com".helper = "!gh auth git-credential";
      safe.directory = [ "/etc/nixos" "/home/viniciussl/dotfiles/nixos" ];
    };
  };

  xdg.configFile."gh/config.yml" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/viniciussl/dotfiles/gh/config.yml";
  };
}
