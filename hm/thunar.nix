{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types optionalAttrs concatStringsSep;

  cfg = config.modules.thunar;

  wezterm = "${pkgs.wezterm}/bin/wezterm";
  bookmarksText = concatStringsSep "\n" cfg.bookmarks + "\n";
in
{
  options.modules.thunar = {
    enable = mkEnableOption "declarative Thunar config";

    bookmarks = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [
        "file:///home/mny315/Downloads"
        "file:///home/mny315/Documents"
      ];
      description = "GTK bookmarks entries for Thunar/sidebar.";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile =
      {
        "Thunar/uca.xml".text = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <actions>
            <action>
              <icon>utilities-terminal</icon>
              <name>Open Terminal Here</name>
              <submenu></submenu>
              <unique-id>1770567449221254-1</unique-id>
              <command>${wezterm} start --cwd "%f"</command>
              <description>Open WezTerm in this directory</description>
              <range></range>
              <patterns>*</patterns>
              <startup-notify/>
              <directories/>
            </action>
          </actions>
        '';

        "xfce4/helpers.rc".text = ''
          TerminalEmulator=wezterm
        '';

        "xfce4/xfconf/xfce-perchannel-xml/thunar.xml".text = ''
          <?xml version="1.1" encoding="UTF-8"?>
          <channel name="thunar" version="1.0">
            <property name="misc-single-click" type="bool" value="false"/>
            <property name="misc-change-window-icon" type="bool" value="false"/>
            <property name="misc-folders-first" type="bool" value="true"/>
            <property name="misc-file-size-binary" type="bool" value="false"/>

            <property name="shortcuts-icon-size" type="string" value="THUNAR_ICON_SIZE_32"/>
            <property name="tree-icon-size" type="string" value="THUNAR_ICON_SIZE_32"/>
            <property name="shortcuts-icon-emblems" type="bool" value="false"/>
            <property name="tree-icon-emblems" type="bool" value="true"/>
            <property name="misc-symbolic-icons-in-sidepane" type="bool" value="false"/>

            <property name="default-view" type="string" value="ThunarDetailsView"/>
            <property name="misc-middle-click-in-tab" type="bool" value="true"/>
            <property name="misc-open-new-window-as-tab" type="bool" value="false"/>
            <property name="misc-confirm-close-multiple-tabs" type="bool" value="false"/>
            <property name="misc-text-beside-icons" type="bool" value="false"/>
            <property name="misc-expandable-folders" type="bool" value="false"/>
            <property name="misc-use-csd" type="bool" value="true"/>

            <property name="misc-exec-shell-scripts-by-default" type="string" value="THUNAR_EXECUTE_SHELL_SCRIPT_ASK"/>
            <property name="misc-image-preview-mode" type="string" value="THUNAR_IMAGE_PREVIEW_MODE_STANDALONE"/>
            <property name="misc-thumbnail-draw-frames" type="bool" value="false"/>
            <property name="misc-thumbnail-mode" type="string" value="THUNAR_THUMBNAIL_MODE_ALWAYS"/>
            <property name="misc-highlighting-enabled" type="bool" value="false"/>
            <property name="misc-date-style" type="string" value="THUNAR_DATE_STYLE_SHORT"/>
            <property name="misc-show-delete-action" type="bool" value="true"/>
            <property name="misc-folder-item-count" type="string" value="THUNAR_FOLDER_ITEM_COUNT_ONLY_LOCAL"/>
            <property name="misc-parallel-copy-mode" type="string" value="THUNAR_PARALLEL_COPY_MODE_NEVER"/>
            <property name="misc-recursive-search" type="string" value="THUNAR_RECURSIVE_SEARCH_NEVER"/>

            <property name="hidden-bookmarks" type="array">
              <value type="string" value="network:///"/>
              <value type="string" value="recent:///"/>
            </property>
          </channel>
        '';
      }
      // optionalAttrs (cfg.bookmarks != []) {
        "gtk-3.0/bookmarks".text = bookmarksText;
      };

    xdg.dataFile."xfce4/helpers/wezterm.desktop".text = ''
      [Desktop Entry]
      Version=1.0
      Type=X-XFCE-Helper
      Name=WezTerm
      Icon=org.wezfurlong.wezterm
      X-XFCE-Category=TerminalEmulator
      X-XFCE-Commands=${wezterm} start
      X-XFCE-CommandsWithParameter=${wezterm} start -- %s
    '';
  };
}
