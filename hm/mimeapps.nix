{ ... }:

{
  # MIME applications
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      # Thunar
      "inode/directory" = "thunar.desktop";

      # MPV
      "video/mp4" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";

      # Loupe and imv
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "image/gif" = "imv.desktop";
      "image/x-xcursor" = "imv.desktop";

      # PortProtonQt
      "application/x-ms-dos-executable" = "ru.linux_gaming.PortProtonQt.desktop";
      "application/x-msdownload" = "ru.linux_gaming.PortProtonQt.desktop";
      "application/x-msi" = "ru.linux_gaming.PortProtonQt.desktop";
      "application/vnd.microsoft.portable-executable" = "ru.linux_gaming.PortProtonQt.desktop";
      "application/x-bat" = "ru.linux_gaming.PortProtonQt.desktop";

      # File Roller
      "application/zip" = "org.gnome.FileRoller.desktop";
      "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
      "application/x-bzip-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/x-bzip1-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/x-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/x-rar" = "org.gnome.FileRoller.desktop";
      "application/vnd.rar" = "org.gnome.FileRoller.desktop";
      "application/x-tar" = "org.gnome.FileRoller.desktop";
      "application/x-xz-compressed-tar" = "org.gnome.FileRoller.desktop";

      # Neovide
      "application/x-shellscript" = "neovide.desktop";
      "application/x-zerosize" = "neovide.desktop";
      "application/xml" = "neovide.desktop";
      "text/css" = "neovide.desktop";
      "text/plain" = "neovide.desktop";
      "text/x-python3" = "neovide.desktop";
      "text/x-shellscript" = "neovide.desktop";

      # Google Chrome
      "application/xhtml+xml" = "google-chrome.desktop";
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/chrome" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/mailto" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";

      # Materialgram
      "x-scheme-handler/tg" = "io.github.kukuruzka165.materialgram.desktop";
      "x-scheme-handler/tonsite" = "io.github.kukuruzka165.materialgram.desktop";
    };
  };
}
