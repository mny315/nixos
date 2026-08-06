{ pkgs, ... }:

{
  # Thunar
  xfconf.settings.thunar = {
    "default-view" = "ThunarIconView";
    "last-view" = "ThunarIconView";

    "misc-change-window-icon" = false;
    "misc-confirm-close-multiple-tabs" = false;
    "misc-date-style" = "THUNAR_DATE_STYLE_SHORT";
    "misc-exec-shell-scripts-by-default" = "THUNAR_EXECUTE_SHELL_SCRIPT_ASK";
    "misc-expandable-folders" = false;
    "misc-file-size-binary" = false;
    "misc-folder-item-count" = "THUNAR_FOLDER_ITEM_COUNT_ONLY_LOCAL";
    "misc-folders-first" = true;
    "misc-highlighting-enabled" = false;
    "misc-image-preview-mode" = "THUNAR_IMAGE_PREVIEW_MODE_STANDALONE";
    "misc-middle-click-in-tab" = true;
    "misc-open-new-window-as-tab" = false;
    "misc-parallel-copy-mode" = "THUNAR_PARALLEL_COPY_MODE_NEVER";
    "misc-recursive-search" = "THUNAR_RECURSIVE_SEARCH_NEVER";
    "misc-show-delete-action" = true;
    "misc-single-click" = false;
    "misc-symbolic-icons-in-sidepane" = false;
    "misc-text-beside-icons" = false;
    "misc-thumbnail-draw-frames" = false;
    "misc-thumbnail-mode" = "THUNAR_THUMBNAIL_MODE_ALWAYS";
    "misc-use-csd" = true;

    "shortcuts-icon-emblems" = false;
    "shortcuts-icon-size" = "THUNAR_ICON_SIZE_32";
    "tree-icon-emblems" = true;
    "tree-icon-size" = "THUNAR_ICON_SIZE_32";

    "hidden-bookmarks" = [
      "network:///"
      "recent:///"
    ];
  };

  # Thunar actions
  xdg.configFile = {
    "Thunar/uca.xml" = {
      force = true;
      text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <actions>
          <action>
            <icon>utilities-terminal</icon>
            <name>Open Terminal Here</name>
            <submenu></submenu>
            <unique-id>1770567449221254-1</unique-id>
            <command>${pkgs.alacritty}/bin/alacritty --working-directory %f</command>
            <description>Open Alacritty in this directory</description>
            <range></range>
            <patterns>*</patterns>
            <startup-notify/>
            <directories/>
          </action>
        </actions>
      '';
    };

    "xfce4/helpers.rc".text = ''
      TerminalEmulator=alacritty
    '';
  };

  # Alacritty
  xdg.dataFile."xfce4/helpers/alacritty.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=X-XFCE-Helper
    Name=Alacritty
    Icon=Alacritty
    X-XFCE-Category=TerminalEmulator
    X-XFCE-Commands=${pkgs.alacritty}/bin/alacritty
    X-XFCE-CommandsWithParameter=${pkgs.alacritty}/bin/alacritty -e %s
  '';
}
