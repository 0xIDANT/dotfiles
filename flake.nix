{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }: let
    system = "x86_64-darwin";
    stablePkgs = import nixpkgs { inherit system; };
    unstablePkgs = import nixpkgs-unstable {
      inherit system;
    };
    neovim = unstablePkgs.neovim-unwrapped.override rec {
        treesitter-parsers = {};
    };
  in {
    packages.${system}.default = stablePkgs.buildEnv {
      name = "My Packages";
      paths = [
        stablePkgs.bat
        stablePkgs.delta
        unstablePkgs.eza
        stablePkgs.fd
        unstablePkgs.fzf
        stablePkgs.gitui
        stablePkgs.gnupg
        stablePkgs.jq
        unstablePkgs.pgcli
        stablePkgs.podman
        stablePkgs.podman-compose
        stablePkgs.pwgen
        stablePkgs.qemu # Dependency of Podman
        stablePkgs.ripgrep
        neovim
        stablePkgs.yq-go
        # unstablePkgs.zsh
        unstablePkgs.zsh-autopair
        unstablePkgs.zsh-autosuggestions
        unstablePkgs.zsh-history-substring-search
        unstablePkgs.zsh-powerlevel10k
        unstablePkgs.zsh-syntax-highlighting
      ];
    };

    devShells.${system}.default = stablePkgs.mkShell {
      name = "dotfiles";
      packages = [
        unstablePkgs.ansible
      ];
    };
  };
}
