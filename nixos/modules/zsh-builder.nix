{ config, lib, ... }: {
  options = {
    # 1. We define a brand new custom option schema
    myConfig.zshScripts = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [];
      description = "List of .zsh script files to automatically source in interactiveShellInit.";
    };
  };

  config = {
    # 2. We consume the data and tell Nix to map it directly into the real Zsh config
    programs.zsh.interactiveShellInit = lib.concatMapStringsSep "\n" 
      (path: "source ${path}") 
      config.myConfig.zshScripts;
  };
}
