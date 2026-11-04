{
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  wayland.windowManager.sway = {
    enable = true;
    # NixOS owns the compositor package and ly session; Home Manager owns
    # ~/.config/sway/config. Avoid installing a second Sway wrapper here.
    package = null;
    systemd.enable = true;
    systemd.dbusImplementation = osConfig.services.dbus.implementation;

    config = {
      modifier = "Mod4"; # Super / Windows key
      terminal = "${pkgs.ghostty}/bin/ghostty";
      menu = "${pkgs.rofi}/bin/rofi -show drun";
      fonts = {
        names = [ "Iosevka Nerd Font Mono" ];
        size = 10.0;
      };
      input."type:keyboard".xkb_layout = "us";
      keybindings = lib.mkOptionDefault {
        "Mod4+Shift+l" = "exec ${pkgs.swaylock}/bin/swaylock -f -c 1e1e1e";
      };
      bars = [
        {
          position = "bottom";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          trayOutput = "primary";
          fonts = {
            names = [ "Iosevka Nerd Font Mono" ];
            size = 10.0;
          };
        }
      ];
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "Iosevka Nerd Font Mono";
      font-size = 12;
    };
  };
  programs.rofi = {
    enable = true;
    modes = [ "drun" ];
    terminal = "${pkgs.ghostty}/bin/ghostty";
  };

  programs.i3status.enable = true;

  home.packages = with pkgs; [
    wl-clipboard
  ];
}
