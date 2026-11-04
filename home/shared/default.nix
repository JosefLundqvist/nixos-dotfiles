{ pkgs, ... }:
{
  imports = [
    ./neovim
    ./sway.nix
  ];

  programs.zsh.enable = true;
  programs.git.enable = true;
  programs.home-manager.enable = true;
  xdg.enable = true;

  home.packages = with pkgs; [
    fd
    jq
    lazygit
    ripgrep
    dotnet-sdk_10
    cargo
    rustc
  ];
}
