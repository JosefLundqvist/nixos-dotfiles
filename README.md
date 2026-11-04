# NixOS dotfiles

Flake-based NixOS and Home Manager configuration for the `josef` account. The current target is an x86_64 NixOS guest named `nixlab` on Hyper-V Generation 2, with a shared Sway Wayland session.

## Configuration layout

| Path | Responsibility |
| --- | --- |
| `flake.nix`, `flake.lock` | Pin NixOS 26.05 (`nixpkgs` `nixos-26.05`) and Home Manager 26.05 (`release-26.05`); compose host and user configuration. |
| `hosts/nixlab/default.nix` | Host name, UEFI/systemd-boot settings, host state version, and Hyper-V software-rendering choice. |
| `hosts/nixlab/hardware-configuration.nix` | Checked-in machine-specific generated filesystems, initrd modules, platform, and Hyper-V guest enablement. Its device UUIDs are specific to the machine from which it was generated. |
| `modules/nixos/` | Shared NixOS base settings, 14-day garbage-collection policy, and user account. |
| `home/josef/` | Home Manager settings for `josef`, including the home state version. |
| `home/shared/` | Shared user configuration such as Zsh, Git, command-line tools, and Neovim. |
| `home/shared/sway.nix` | Shared Sway session settings and keybindings, using the system Sway binary. |
| `home/shared/ghostty.nix` | Ghostty terminal enablement and font settings. |
| `home/shared/neovim/config/` | Lua Neovim configuration and lazy.nvim lockfile. |

NixOS modules own system integration such as the compositor/session and system services; Home Manager owns user applications and configuration such as Ghostty, Rofi, and Sway settings. Some tools are intentionally present in both shared user packages and Neovim's `extraPackages`, because they are useful in the shell as well as from Neovim. `nixfmt` is included as the Nix formatter through the flake formatter and as a Neovim tool.

The VM is expected to boot with UEFI and an EFI System Partition mounted at `/boot`. systemd-boot is unsigned in this setup, so disable Secure Boot in the Hyper-V VM settings. The `ly` login manager offers both the Sway session and a shell console fallback. Sway is configured for keyboard use, with Super/Windows as its modifier. The shared Sway settings apply to all hosts; the `nixlab` host adds `WLR_RENDERER=pixman` for Hyper-V software rendering. SSH is enabled, but password and root SSH login are disabled.

## Adopt on a fresh NixOS install

Install NixOS in the VM first, using an x86_64 NixOS 26.05 installation and an EFI System Partition mounted at `/boot`. Keep the VM console available. The repository must be published at the configured remote before cloning; this workflow does not publish or push it automatically.

On the source computer, review the new files, then commit and push them from `C:/src/nixos-dotfiles` when ready:

```sh
git add .
git commit -m "Add shared NixOS 26.05 configuration and nixlab host"
git push -u origin main
```

The HTTPS clone below works for a public repository. A private repository requires GitHub authentication on the new machine (or an SSH key and the SSH remote URL).

Start a shell with Git and clone the repository over HTTPS:

```sh
nix-shell -p git --run 'git clone https://github.com/JosefLundqvist/nixos-dotfiles.git ~/nixos-dotfiles'
cd ~/nixos-dotfiles
```

The checked-in hardware configuration contains machine-specific device UUIDs. To use this configuration on another machine, generate and review a fresh hardware configuration on that target before activation. The command below writes it to a temporary file first, then installs it into the repository:

```sh
hardware_config="$(mktemp)"
sudo nixos-generate-config --show-hardware-config > "$hardware_config" &&
install -m 0644 "$hardware_config" hosts/nixlab/hardware-configuration.nix
rm "$hardware_config"
```

This replaces the checked-in hardware configuration. Inspect the generated result before proceeding. Confirm that `/`, `/boot`, swap, and any LUKS/other device mappings match the target machine; do not assume existing UUIDs or filesystem types apply. Keep required generated declarations, including initrd modules, encryption settings, and filesystem configuration.

Before adopting this flake on an older installation, set `system.stateVersion` in `hosts/nixlab/default.nix` and `home.stateVersion` in `home/josef/default.nix` to the versions used by the existing system and Home Manager profile. These compatibility baselines should not be raised as part of routine upgrades.

Back up user configuration that activation could replace or manage. In particular, preserve `~/.config/nvim`, `~/.config/sway`, `~/.config/ghostty`, `~/.config/rofi`, and any unmanaged `~/.zshrc`, `~/.zshenv`, `~/.zprofile`, `~/.gitconfig`, or `~/.config/git/config` before switching. Review the Home Manager options and any existing links before moving data; do not overwrite an existing personal configuration without comparing it.

Nix flakes ignore untracked files when evaluating local source. The hardware configuration is tracked, so replacing it is visible to the flake without staging. If you create a new host or hardware file, add that new file to Git before the first evaluation. You can stage a generated replacement to review it in Git:

```sh
git add hosts/nixlab/hardware-configuration.nix
```

Run a first evaluation, check, and full system build. The `--extra-experimental-features` option enables flakes even if the installer's Nix configuration has not enabled them yet:

```sh
nix --extra-experimental-features 'nix-command flakes' eval .#nixosConfigurations.nixlab.config.system.build.toplevel.drvPath
nix --extra-experimental-features 'nix-command flakes' flake check --no-build
nix --extra-experimental-features 'nix-command flakes' build .#nixosConfigurations.nixlab.config.system.build.toplevel --no-link
```

The full build can take time and download substantial dependencies. Resolve evaluation/build errors before activation. Then, from the VM console with an administrator account, activate the configuration:

```sh
sudo nixos-rebuild switch --flake .#nixlab
```

For a fresh install, `josef` is initially locked because no password is stored in this repository. Before activation, move the administrator console session to a spare virtual terminal (for example, send Ctrl+Alt+F2 from the Hyper-V console) and run the switch there. `ly` owns tty1 after activation; keep the administrator session on the spare VT to set `josef`'s password, then return to tty1 and select either the Sway session or the built-in shell session:

```sh
sudo passwd josef
```

On an existing installation, `users.mutableUsers = true` preserves `josef`'s current password. Never add a password or password hash to this repository.

To enable SSH key access, add your **public** key to `users.users.${username}.openssh.authorizedKeys.keys` in `modules/nixos/users.nix` and rebuild. Do this before relying on SSH. Password and root SSH access remain disabled. For the first fresh installation, SSH will not be available unless it was configured previously; use the VM console. Once the guest is running, find its address with:

```sh
ip -br address
```

## Neovim on NixOS

The Home Manager Neovim module supplies command-line tools and language servers from Nix. The Nix package set includes Lua, Nix, TypeScript/JavaScript, Rust (`rust-analyzer`), Svelte (`svelte-language-server`), Tailwind CSS (`tailwindcss-language-server`), C#, and formatter tools including `nixfmt` for Nix files. The config sets `NVIM_NIX_MANAGED=1` in its wrapper so blink.cmp uses its Lua fuzzy implementation and lazy.nvim stores its mutable lockfile under `~/.local/state/nvim/lazy-lock.json`. Plugins are still downloaded by lazy.nvim at runtime, so this setup does not make plugin source fully Nix-reproducible. On first launch, run `:Lazy restore` to install the versions pinned in the lockfile.

To keep plugin updates under version control, copy the updated state lockfile back to `home/shared/neovim/config/lazy-lock.json` and commit it:

```sh
cp ~/.local/state/nvim/lazy-lock.json home/shared/neovim/config/lazy-lock.json
```

Treesitter parsers may need to be installed on first use. In Neovim, run:

```vim
:TSInstall lua nix c_sharp javascript typescript json
```

To add another server, add its Nix package to `programs.neovim.extraPackages` and enable its lspconfig name in `config/lua/jwl/plugins/lsp.lua`.

The VM includes the .NET 10 SDK and Roslyn language server for C# editing. The Lua configuration explicitly opens solutions/projects for the packaged Roslyn 5.7 server; it does not use the newer `--autoLoadProjects` flag. When several solutions exist at the workspace root, the first one alphabetically is opened. Clipboard access depends on terminal/display forwarding and clipboard support on the client side. Icons in the UI need a Nerd Font in the terminal host.

## Sway session

The shared Home Manager configuration manages Sway's settings, with `Mod4` (Super/Windows) as the modifier. NixOS supplies the Sway binary and the session offered by ly. The session uses Ghostty as the terminal, Rofi's `rofi -show drun` application launcher, and Sway's default status bar with Home Manager-configured i3status. On Hyper-V, the `nixlab` host sets `WLR_RENDERER=pixman` for software rendering. Use the Hyper-V VM console for graphical login.

| Keys | Action |
| --- | --- |
| Super+Enter | Open Ghostty terminal |
| Super+D | Open Rofi application launcher |
| Super+Shift+Q | Close focused window |
| Super+1 through Super+9 | Switch to workspace 1 through 9 |
| Super+Shift+C | Reload Sway configuration after rebuild |
| Super+Shift+E | Show exit confirmation |
| Super+Shift+L | Lock the session |

Use the built-in shell session in ly when you need a console instead of Sway.

## Routine changes and maintenance

After editing configuration, check and build before switching:

```sh
nix --extra-experimental-features 'nix-command flakes' flake check --no-build
nix --extra-experimental-features 'nix-command flakes' build .#nixosConfigurations.nixlab.config.system.build.toplevel --no-link
sudo nixos-rebuild switch --flake .#nixlab
```

Update pinned inputs deliberately, then review the lockfile and rebuild:

```sh
nix --extra-experimental-features 'nix-command flakes' flake update
nix --extra-experimental-features 'nix-command flakes' flake check --no-build
nix --extra-experimental-features 'nix-command flakes' build .#nixosConfigurations.nixlab.config.system.build.toplevel --no-link
sudo nixos-rebuild switch --flake .#nixlab
```

Do not routinely change the state-version values as part of input updates. If a new generation fails, select an earlier generation from the boot menu or roll back from a working system with:

```sh
sudo nixos-rebuild switch --rollback
```

### Garbage collection

NixOS checks for garbage collection daily, but runs it only when at least 14 days have elapsed since the previous successful run. The timestamp lives in `/var/lib/nix-gc/last-success`, so the interval survives reboots and missed timer runs catch up at the next daily check. Each run deletes generations older than 30 days; the currently active system generation remains available. This policy is system-wide and managed by `modules/nixos/maintenance.nix`.

Inspect the next timer run and recent service results with:

```sh
systemctl list-timers nix-gc.timer
systemctl status nix-gc.service
journalctl -u nix-gc.service
```

## Adding another host

Add `hosts/<name>/default.nix` and its hardware configuration generated on that machine. Choose the correct system architecture and boot firmware configuration for that host, then add an entry to `nixosConfigurations` in `flake.nix` using `mkHost`. Shared NixOS modules and the `josef` Home Manager configuration are reused; host-specific storage, boot, and hardware settings belong under that host's directory.

## References

- [NixOS manual: flakes](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html)
- [NixOS manual: configuration and options](https://nixos.org/manual/nixos/stable/)
- [Home Manager manual](https://nix-community.github.io/home-manager/index.xhtml)
