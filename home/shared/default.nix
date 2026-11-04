{ pkgs, osConfig, ... }:
{
  imports = [
    ./neovim
    ./sway.nix
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#${osConfig.networking.hostName}";
    };
  };
  programs.git.enable = true;
  programs.home-manager.enable = true;
  xdg.enable = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    fd
    jq
    lazygit
    ripgrep
    wl-clipboard
    nerd-fonts.iosevka
  ];
}
