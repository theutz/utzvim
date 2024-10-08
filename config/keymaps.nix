{lib, ...}: let
  inherit (lib) mapAttrsToList;
  inherit (builtins) map elemAt;

  winKeyMapper = key: desc: {
    key = "<leader>w${key}";
    mode = ["n"];
    action = "<cmd>wincmd ${key}<cr>";
    options.desc = desc;
  };
  winCmds = {
    "+" = "Increase height";
    "-" = "Decrease height";
    "<" = "Decrease width";
    "=" = "Equal width and height";
    ">" = "Increase width";
    "_" = "Max out the height";
    "h" = "Focus left window";
    "j" = "Focus window below";
    "k" = "Focus window above";
    "l" = "Focus right window";
    "o" = "Close all others";
    "q" = "Close window";
    "s" = "Split window horizontally";
    "T" = "Break into new tab";
    "v" = "Split window vertically";
    "w" = "Switch windows";
    "x" = "Swap current with next";
    "|" = "Max out the width";
  };
  winKeys = mapAttrsToList winKeyMapper winCmds;

  leaderMapper = arg: let
    key = elemAt arg 0;
    cmd = elemAt arg 1;
    desc = elemAt arg 2;
  in {
    mode = ["n"];
    key = "<leader>${key}";
    action = "<cmd>${cmd}<cr>";
    options.desc = desc;
  };
  leaderCmds = [
    ["bd" "bd" "Delete buffer"]
    ["bD" "bd!" "Delete buffer (force)"]
    ["bp" "bp" "Previous buffer"]
    ["bn" "bn" "Next buffer"]
  ];
  leaderKeys = map leaderMapper leaderCmds;
in {
  keymaps =
    winKeys
    ++ leaderKeys
    ++ [
      {
        mode = ["n"];
        key = "<C-s>";
        action = "<cmd>w<cr>";
        options = {
          desc = "Save file";
        };
      }
      {
        mode = ["n" "i"];
        key = "<esc>";
        action = "<cmd>nohl<cr><esc>";
        options.desc = "Clear highlighting";
      }
      {
        mode = ["n"];
        key = "[b";
        action = "<cmd>bp<cr>";
        options = {
          desc = "Previous buffer";
        };
      }
      {
        mode = ["n"];
        key = "]b";
        action = "<cmd>bn<cr>";
        options = {
          desc = "Next buffer";
        };
      }
      {
        mode = ["n"];
        key = "<leader>qq";
        action = "<cmd>xa<cr>";
        options.desc = "Write all and quit";
      }
      {
        mode = ["n"];
        key = "<leader><tab>n";
        action = "<cmd>tabnext<cr>";
        options.desc = "Next tab";
      }
      {
        mode = ["n"];
        key = "<leader><tab>]";
        action = "<cmd>tabnext<cr>";
        options.desc = "Next tab";
      }
      {
        mode = ["n"];
        key = "<leader><tab>p";
        action = "<cmd>tabprev<cr>";
        options.desc = "Prev tab";
      }
      {
        mode = ["n"];
        key = "<leader><tab>[";
        action = "<cmd>tabprev<cr>";
        options.desc = "Prev tab";
      }
      {
        mode = ["n"];
        key = "<leader><tab><space>";
        action = "<cmd>wincmd T<cr>";
        options.desc = "Open in new tab";
      }
    ];
}
