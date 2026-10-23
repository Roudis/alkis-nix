# Your user environment: CLI tools, shell, dotfiles.
# Shared by every machine, macOS and Linux alike.
{ pkgs, lib, username, ... }:

{
  home.username = username;
  home.homeDirectory = lib.mkDefault (
    if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}"
  );

  # Read the home-manager changelog before changing this.
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Search for packages at https://search.nixos.org/packages
  home.packages = with pkgs; [
    # dev
    gh
    neovim
    nodejs
    python311
    pipx
    pre-commit
    rustup
    go-task
    postgresql_18

    # infra
    terraform
    ansible
    kind
    k9s
    seaweedfs

    # misc
    mdbook
    tesseract
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitFull; # includes `git gui`
    settings = {
      user.name = "roudis";
      user.email = "alkisroudis@gmail.com";
      pull.rebase = true;
    };
  };

  programs.starship.enable = true;
  programs.yazi.enable = true;

  programs.pyenv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      g = "git";
      gs = "git status";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit -m";
      gca = "git commit --amend";
      gcane = "git commit --amend --no-edit";
      gco = "git checkout";
      gcob = "git checkout -b";
      gb = "git branch";
      gba = "git branch -a";
      gbd = "git branch -d";
      gbD = "git branch -D";
      gd = "git diff";
      gds = "git diff --staged";
      gl = "git log --oneline --graph --decorate";
      gla = "git log --oneline --graph --decorate --all";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gpu = "git push -u origin HEAD";
      gpl = "git pull";
      gplr = "git pull --rebase";
      gf = "git fetch";
      gfa = "git fetch --all";
      gst = "git stash";
      gstp = "git stash pop";
      gstl = "git stash list";
      grb = "git rebase";
      grbi = "git rebase -i";
      grba = "git rebase --abort";
      grbc = "git rebase --continue";
      gm = "git merge";
      gma = "git merge --abort";
      gr = "git reset";
      grh = "git reset --hard";
      grs = "git reset --soft";
      gcp = "git cherry-pick";
      gcl = "git clone";
      gsh = "git show";
      gtag = "git tag";
    };

    # ~/.zprofile
    profileExtra = lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
      [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
      # Keep Nix-installed tools ahead of Homebrew ones with the same name.
      export PATH="/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:$PATH"
    '';

    # Extra lines for ~/.zshrc
    initContent = ''
      autoload -U +X bashcompinit && bashcompinit
      complete -o nospace -C ${pkgs.terraform}/bin/terraform terraform

      # Tools installed outside Nix
      export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.docker/bin:$PATH"
      [[ -d $HOME/.antigravity/antigravity/bin ]] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
      [[ -d $HOME/.antigravity-ide/antigravity-ide/bin ]] && export PATH="$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"
      [[ -d $HOME/.lmstudio/bin ]] && export PATH="$PATH:$HOME/.lmstudio/bin"

      # Show a random Pokémon on terminal startup
      command -v pokeget &>/dev/null && pokeget random
    '';
  };
}
