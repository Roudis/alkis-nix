{
  description = "Alkis' dev machines";

  # Everything this config depends on. Exact versions get pinned in flake.lock,
  # so every machine builds the same thing until you run `nix flake update`.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nix-darwin, home-manager, ... }:
    let
      username = "alkisroudis";

      # A macOS machine: system settings (nix-darwin) + your user env (home-manager).
      mkDarwin = { hostname, system ? "aarch64-darwin", extraModules ? [ ] }:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit username hostname; };
          modules = [
            { nixpkgs.hostPlatform = system; }
            ./modules/darwin.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # Existing dotfiles (e.g. ~/.zshrc) are renamed instead of blocking activation.
              home-manager.backupFileExtension = "before-nix";
              home-manager.extraSpecialArgs = { inherit username; };
              home-manager.users.${username} = import ./home;
            }
          ] ++ extraModules;
        };

      # A non-macOS machine (Linux, WSL, a VM...): only your user env, no system config.
      mkHome = { system, homeDirectory ? "/home/${username}" }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
          extraSpecialArgs = { inherit username; };
          modules = [
            ./home
            { home.homeDirectory = homeDirectory; }
          ];
        };
    in
    {
      # Apply with: sudo darwin-rebuild switch --flake .#<hostname>
      darwinConfigurations = {
        "Alkis-Macbook" = mkDarwin {
          hostname = "Alkis-Macbook";
          extraModules = [ ./hosts/Alkis-Macbook.nix ];
        };
      };

      # Apply with: home-manager switch --flake .#<name>
      homeConfigurations = {
        "linux" = mkHome { system = "x86_64-linux"; };
        "linux-arm" = mkHome { system = "aarch64-linux"; };
      };
    };
}
