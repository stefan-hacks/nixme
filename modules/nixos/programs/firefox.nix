# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/PROGRAMS/FIREFOX.NIX - Firefox Browser
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    
    # Firefox policies/configuration
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxScreenshots = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "always";
      DisplayMenuBar = "default";
      SearchBar = "unified";
    };
    
    # Preferences
    preferences = {
      "browser.download.startDownloadsFolderList" = 0;
      "browser.download.folderList" = 1;
      "browser.download.useDownloadDir" = true;
      "browser.tabs.firefox-view" = false;
      "browser.tabs.tabmanager.enabled" = false;
      "browser.toolbars.bookmarks.visibility" = "always";
      "general.smoothScroll" = true;
      "ui.systemUsesDarkTheme" = 1;
    };
  };
  
  environment.systemPackages = with pkgs; [
    # Browser tools
    chromium
  ];
}
