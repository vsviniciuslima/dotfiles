{ config, pkgs, ... }:

{

  programs.zsh.shellAliases = {
    skills = "npx @vercel/skills";
    skills-sync = "cd ~/dotfiles && git add ai/skills/ && git commit -m 'feat(ai): sync skills for claude and antigravity' && git push";
  };

    # Explicitly hook into Home Manager for user 'viniciussl'
  home-manager.users.viniciussl = { config, ... }: {

    home.file = {
      # This config will now look for Vercel configurations inside your user scope
      ".skills-cli/config.json".text = builtins.toJSON {
        canonicalDir = {
          global = "${config.home.homeDirectory}/dotfiles/ai/skills";
        };
      };

      # Now config.lib.file evaluates flawlessly!
      ".claude/skills".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/skills";
      ".gemini/config/skills".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ai/skills";
    };
  };

}
