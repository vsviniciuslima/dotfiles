{ pkgs, config, ... }:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
    user = "viniciussl";
    group = "users"; 
    dataDir = "/home/viniciussl/.config/syncthing"; # Stores its config in your home dir
    settings = {
      devices = {
        "android" = { id = "WNDUKCH-4N22A2A-H4OXLCL-2WMASG3-BZYW4KH-YA3EHMK-DRR67TR-SJF4NQX"; };
      };
      # folders = {
      #   "obsidian-vault" = { # Unique Folder ID used by Syncthing
      #     path = "/home/viniciussl/Documents/obsidian-vault";
      #     devices = [ "android" ]; # Automatically share it with this device
      #     type = "sendreceive";
      #   };
      # };
    };
  };

}
