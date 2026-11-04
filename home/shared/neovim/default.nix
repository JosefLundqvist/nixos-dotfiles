{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;

    # Select writable lazy.nvim state and avoid downloaded native blink binaries.
    extraWrapperArgs = [
      "--set"
      "NVIM_NIX_MANAGED"
      "1"
    ];
    extraPackages = with pkgs; [
      curl
      unzip
      gnutar
      gzip
      gcc
      gnumake
      tree-sitter
      fd
      ripgrep
      git
      lazygit
      trash-cli
      wl-clipboard
      xclip
      stylua
      oxfmt
      nixfmt
      lua-language-server
      nil
      typescript-language-server
      rust-analyzer
      svelte-language-server
      tailwindcss-language-server
      vscode-langservers-extracted
      roslyn-ls
      dotnet-sdk_10
    ];
  };

  # Individual files are linked from the store. lazy.nvim keeps its mutable
  # lockfile and downloaded plugins under the user's state/data directories.
  xdg.configFile."nvim" = {
    source = ./config;
    recursive = true;
  };
}
