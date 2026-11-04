{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/hyperv.nix
  ];

  networking.hostName = "nixlab";

  # Hyper-V's synthetic display has no accelerated renderer. Keep this
  # software-rendering choice on the VM so physical hosts can use their GPU.
  programs.sway.extraSessionCommands = ''
    export WLR_RENDERER=pixman
  '';

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # Compatibility baseline, not the version to upgrade on each rebuild.
  system.stateVersion = "26.05";
}
