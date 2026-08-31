{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnomeExtensions.clipboard-history
  ];

  services.desktopManager.gnome.enable = true;


  # Enable dconf system service
  programs.dconf.enable = true;

  # Declarative GNOME configurations at the system level
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        # 1. Register your active folder category IDs
        "org/gnome/desktop/app-folders" = {
          folder-children = [ "Development" "Media" "Utilities" "System" ];
        };

        # 2. Folder Definition: Development Tools
        "org/gnome/desktop/app-folders/folders/Development" = {
          name = "Dev Tools";
          apps = [
            "claude-desktop.desktop"
            "devin-desktop.desktop"
            "org.gnome.Console.desktop"
            "vim.desktop"
            "xterm.desktop"
          ];
        };

        # 3. Folder Definition: Media & Entertainment
        "org/gnome/desktop/app-folders/folders/Media" = {
          name = "Media";
          apps = [
            "spotify.desktop"
            "vlc.desktop"
            "org.gnome.Showtime.desktop"
            "org.gnome.Snapshot.desktop"
          ];
        };

        # 4. Folder Definition: System Utilities
        "org/gnome/desktop/app-folders/folders/Utilities" = {
          name = "Utilities";
          apps = [
            "org.gnome.Decibels.desktop"
            "org.gnome.Connections.desktop"
            "org.gnome.Papers.desktop"
            "org.gnome.font-viewer.desktop"
            "org.gnome.Loupe.desktop"
            "org.gnome.seahorse.Application.desktop"
            "org.gnome.Calculator.desktop"
            "org.gnome.SimpleScan.desktop"
            "org.gnome.Characters.desktop"
            "cups.desktop"
          ];
        };

        # 5. Folder Definition: Core OS & Help Manuals
        "org/gnome/desktop/app-folders/folders/System" = {
          name = "System";
          apps = [
            "org.gnome.Settings.desktop"
            "org.gnome.Extensions.desktop"
            "org.gnome.Tour.desktop"
            "org.gnome.Yelp.desktop"
            "nixos-manual.desktop"
          ];
        };
      };
    }
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Install gnome-disks
  programs.gnome-disks.enable = true;

  # Enable Claude Desktop GUI app
  programs.claude-desktop.enable = true;
}
