{ pkgs, ... }:
{
  # The system package registers the Wayland session with ly and provides
  # the required graphics, logind, D-Bus and swaylock PAM integration.
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      brightnessctl
      ghostty
      grim
      pulseaudio
      rofi
      swayidle
      swaylock
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.sway = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
    };
  };
}
