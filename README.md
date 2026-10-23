# alkis-nix

Declarative setup for my dev machines, using a Nix flake.

- **macOS**: [nix-darwin](https://github.com/nix-darwin/nix-darwin) (system settings, Homebrew casks) + [home-manager](https://github.com/nix-community/home-manager) (user tools, shell, dotfiles)
- **Linux**: home-manager only

## Layout

```
flake.nix              entry point: lists machines and pinned inputs
flake.lock             exact versions of everything (commit this!)
modules/darwin.nix     macOS settings shared by every Mac
hosts/<hostname>.nix   settings for one specific machine
home/default.nix       CLI tools, zsh, git, etc. — shared by all machines
```

## Setting up a new Mac

1. Install Nix (https://nixos.org/download) and Homebrew (https://brew.sh).
2. Clone this repo, e.g. `git clone <url> ~/alkis-nix && cd ~/alkis-nix`.
3. If the machine is new, add it to `darwinConfigurations` in `flake.nix` (copy the
   `Alkis-Macbook` entry and create `hosts/<hostname>.nix`).
4. First run (this installs `darwin-rebuild`):

   ```sh
   sudo nix --extra-experimental-features 'nix-command flakes' \
     run nix-darwin/master#darwin-rebuild -- switch --flake .#Alkis-Macbook
   ```

   If it stops with *"Unexpected files in /etc"*, move the listed files aside
   (e.g. `sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin`) and run it again.

5. Open a new terminal.

## Setting up a Linux machine

```sh
nix --extra-experimental-features 'nix-command flakes' \
  run home-manager/master -- switch --flake .#linux        # or .#linux-arm
```

## Day to day

| Task | Command |
| --- | --- |
| Apply changes (Mac) | `sudo darwin-rebuild switch --flake .` |
| Apply changes (Linux) | `home-manager switch --flake .#linux` |
| Update all packages | `nix flake update`, then apply and commit `flake.lock` |
| Undo the last change (Mac) | `sudo darwin-rebuild --rollback` |
| Try a tool without installing | `nix shell nixpkgs#ripgrep` |
| Find a package | https://search.nixos.org/packages |

To add a tool, put it in `home.packages` in `home/default.nix`, apply, and commit.
