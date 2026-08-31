# nixos/modules/antigravity.nix
{ pkgs, inputs, ... }:

{
  environment.systemPackages = [
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.default # Base App (Antigravity 2.0)
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-ide # IDE
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli # CLI (agy)

    # Antigravity ACP Server wrapper
    (pkgs.writeShellScriptBin "agy_acp_server.par" ''
      exec /home/viniciussl/.local/bin/agy_acp_server.par "$@"
    '')
  ];
}
