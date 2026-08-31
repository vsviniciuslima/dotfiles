{ config, pkgs, ... }:
{
  home.username = "viniciussl";
  home.homeDirectory = "/home/viniciussl";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "vsviniciuslima";
      user.email = "vsviniciuslima@usp.br";
      credential."https://github.com".helper = "!gh auth git-credential";
      credential."https://gist.github.com".helper = "!gh auth git-credential";
      safe.directory = [ "/home/viniciussl/dotfiles/nixos" ];
    };
  };

  xdg.configFile."gh/config.yml" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/viniciussl/dotfiles/gh/config.yml";
  };

  home.file.".windsurf/acp/registry.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/windsurf/acp/registry.json";
  };

  home.file.".gemini/antigravity-acp/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/antigravity/acp-settings.json";
  };
}
