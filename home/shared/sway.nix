{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  terminal = lib.getExe config.programs.ghostty.package;
  swayFonts = {
    names = [ "Iosevka Nerd Font Mono" ];
    size = 10.0;
  };
in
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
      inherit terminal;
      menu = "${lib.getExe config.programs.rofi.finalPackage} -show drun";
      fonts = swayFonts;
      input."type:keyboard".xkb_layout = "us";
      keybindings = lib.mkOptionDefault {
        "${config.wayland.windowManager.sway.config.modifier}+Shift+l" = "exec ${pkgs.swaylock}/bin/swaylock -f -c 1e1e1e";
      };
      bars = [
        {
          position = "bottom";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          trayOutput = "primary";
          fonts = swayFonts;
        }
      ];
    };
  };

  programs.rofi = {
    enable = true;
    modes = [ "drun" ];
    inherit terminal;
  };

  programs.i3status.enable = true;

  home.packages = with pkgs; [
    wl-clipboard
  ];
}
