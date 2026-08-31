{ pkgs, ... }:

{
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users."viniciussl" = {
    isNormalUser = true;
    description = "Vinicius Santana Lima";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      spotify
      vlc
      microsoft-edge
      bitwarden-desktop
      eza
      bat
      wl-clipboard
      obsidian
      telegram-desktop
      zapzap
      notion-electron
      mailspring
      playerctl
      tree
    ];

     
  };

  programs.zsh.shellAliases = {
    ytdl = "yt-dlp --extract-audio --audio-format mp3";
    fix-spotify = "rm -rf ~/.cache/spotify";
  };

  myConfig.zshScripts = [
    ./users-media.zsh
  ];

  # Set zsh as the default shell for users
  users.defaultUserShell = pkgs.zsh;
}
