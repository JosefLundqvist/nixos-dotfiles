{ pkgs, ... }:
{
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  services.displayManager.ly = {
    enable = true;
    x11Support = false;
  };
}
