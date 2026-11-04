{ username, ... }:
{
  # Keep passwords in /etc/shadow across rebuilds. Set the password at the
  # VM console with `sudo passwd josef`; never put a password in this repo.
  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = "Josef";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    openssh.authorizedKeys.keys = [
      # Add your PUBLIC key here before relying on SSH access.
    ];
  };
}
