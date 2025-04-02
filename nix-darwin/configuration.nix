{ self, pkgs, ... }:

{
  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 5;

  users = {
    users.alex = {
      shell = pkgs.zsh;
      home = "/Users/alex";
    };
  };
}
