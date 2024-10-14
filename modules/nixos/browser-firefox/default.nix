{ pkgs, lib, inputs, ... }:
  with lib;
{
  home-manager.users.fxyoge = {
    # see: https://gitlab.com/usmcamp0811/dotfiles/-/blob/fb584a888680ff909319efdcbf33d863d0c00eaa/modules/home/apps/firefox/default.nix
    programs.firefox = {
      enable = true;
      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;

        # when i make my own extensions repo, i probably want to copy github:seadome/firefox-addons instead
        extensions = with inputs.firefox-addons-rycee.packages.${pkgs.system}; [
          sponsorblock
          tree-style-tab
          ublock-origin
          violentmonkey
        ];

        extraConfig = strings.concatStrings [
          (builtins.readFile "${inputs.arkenfox}/user.js")
          (builtins.readFile ./user.js)
        ];

        userChrome = strings.concatStrings [
          (builtins.readFile ./userChrome.css)
        ];

        search = {
          force = true;
          default = "Google";
          privateDefault = "Google";
          order = [
            "Google"
          ];
          engines = {
            "Amazon.com".metaData.hidden = true;
            "Bing".metaData.hidden = true;
            "DuckDuckGo".metaData.hidden = true;
            "eBay".metaData.hidden = true;
            "Google".metaData.alias = "@g";
            "Wikipedia (en)".metaData.hidden = true;
          };
        };
      };
    };
  };
}
