{lib, ...}: let
  inherit (lib) map elemAt mapAttrsToList;
in {
  plugins.which-key = {
    enable = true;
    settings = {
      preset = "modern";
      spec = [
        {
          mode = ["n"];
          __unkeyed-1 = "<leader>s";
          group = "Search";
        }
      ];
    };
  };
}
