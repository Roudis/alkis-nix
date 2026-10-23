# macOS system settings shared by every Mac.
{ pkgs, username, hostname, ... }:

{
  nixpkgs.config.allowUnfree = true; # terraform etc.

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "@admin" ];
  };

  networking.hostName = hostname;
  networking.localHostName = hostname;

  users.users.${username}.home = "/Users/${username}";
  system.primaryUser = username;

  programs.zsh.enable = true;

  # Use Touch ID for sudo.
  security.pam.services.sudo_local.touchIdAuth = true;

  # GUI apps are mostly easier to keep in Homebrew; nix-darwin drives it declaratively.
  # Homebrew itself must already be installed (https://brew.sh).
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # "none" = never uninstall things that aren't listed here.
      # Switch to "uninstall" (or "zap") once the lists below are complete.
      cleanup = "none";
    };
    taps = [ ];
    brews = [ ];
    casks = [ ];
  };

  # macOS preferences. Uncomment what you like; see `man 5 configuration.nix`
  # or https://nix-darwin.github.io/nix-darwin/manual/ for the full list.
  system.defaults = {
    # dock.autohide = true;
    # finder.AppleShowAllExtensions = true;
    # NSGlobalDomain.KeyRepeat = 2;
    # NSGlobalDomain.InitialKeyRepeat = 15;
  };

  # Read the nix-darwin changelog before changing this.
  system.stateVersion = 6;
}
