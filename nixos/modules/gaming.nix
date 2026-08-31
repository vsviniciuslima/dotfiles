{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [
    hydralauncher
    discord
    heroic
  ];

  # Load Nvidia drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required
    modesetting.enable = true;

    # Nvidia power management (optional, can help with sleep/suspend issues)
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Use the Nvidia open source kernel module (preferred for Turing and newer GPUs like RTX 4060)
    open = true;

    # Enable the Nvidia settings menu applet
    nvidiaSettings = true;

    # Select the appropriate driver version (stable is recommended)
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable OpenGL / Hardware Acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for Steam and 32-bit games
  };

}