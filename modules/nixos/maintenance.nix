{ pkgs, ... }:
let
  gcDue = pkgs.writeShellScript "nix-gc-due" ''
    state_file=/var/lib/nix-gc/last-success
    now="$(${pkgs.coreutils}/bin/date +%s)"
    last_success=0

    if [[ -r "$state_file" ]]; then
      IFS= read -r last_success < "$state_file" || true
    fi

    if [[ ! "$last_success" =~ ^[0-9]+$ ]]; then
      exit 0
    fi

    (( now - last_success >= 14 * 24 * 60 * 60 ))
  '';
in
{
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
    persistent = true;
  };

  systemd.services.nix-gc = {
    serviceConfig = {
      StateDirectory = "nix-gc";
      ExecCondition = gcDue;
    };

    # postStart runs only after the garbage collection command succeeds.
    postStart = ''
      ${pkgs.coreutils}/bin/date +%s > /var/lib/nix-gc/last-success
    '';
  };
}
