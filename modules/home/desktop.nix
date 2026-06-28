# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/HOME/DESKTOP.NIX - Desktop Applications and Settings
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  # ═══════════════════════════════════════════════════════════════════════════
  # GNOME SETTINGS (dconf) - stefan-hacks configuration
  # ═══════════════════════════════════════════════════════════════════════════
  dconf.settings = {
    # Keyboard
    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.hm.gvariant.mkTuple [ "xkb" "gb" ])
        (lib.hm.gvariant.mkTuple [ "xkb" "us" ])
      ];
      mru-sources = [
        (lib.hm.gvariant.mkTuple [ "xkb" "us" ])
        (lib.hm.gvariant.mkTuple [ "xkb" "gb" ])
      ];
    };
    
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
      speed = 1.0;
    };
    
    "org/gnome/desktop/peripherals/touchpad" = {
      speed = 1.0;
      two-finger-scrolling-enabled = true;
    };

    # Interface - Catppuccin Mocha theme
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      accent-color = "blue";
      enable-hot-corners = false;
      show-battery-percentage = true;
      clock-show-seconds = true;
      clock-show-weekday = true;
      enable-animations = false;
      font-name = "Hack Nerd Font 11";
      document-font-name = "Hack Nerd Font 11";
      monospace-font-name = "Hack Nerd Font Mono 11";
      gtk-theme = "Yaru-blue-dark";
      icon-theme = "Yaru-blue-dark";
      overlay-scrolling = false;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,minimize,maximize:appmenu";
      action-right-click-titlebar = "none";
    };
    
    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [];
      begin-move = [];
      begin-resize = [];
      "cycle-group" = ["<Control><Alt>Escape"];
      "cycle-group-backward" = ["<Shift><Control><Alt>Escape"];
      "move-to-monitor-left" = ["<Shift><Super>h"];
      "move-to-monitor-right" = ["<Shift><Super>l"];
      "switch-to-workspace-left" = ["<Alt>F11"];
      "switch-to-workspace-right" = ["<Alt>F12"];
      unmaximize = ["<Super>Down"];
    };

    "org/gnome/desktop/session" = {
      idle-delay = 900;
    };

    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
      event-sounds = true;
    };

    "org/gnome/desktop/lockdown" = {
      disable-lock-screen = false;
    };

    # Wallpaper
    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/stefan-hacks/Pictures/wallpapers/Catppuccin%20Mocha/17.%20Catppuccin%20Mocha.jpg";
      picture-uri-dark = "file:///home/stefan-hacks/Pictures/wallpapers/Catppuccin%20Mocha/17.%20Catppuccin%20Mocha.jpg";
      picture-options = "zoom";
      primary-color = "#3071AE";
      secondary-color = "#000000";
      color-shading-type = "solid";
    };

    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///usr/share/backgrounds/gnome/adwaita-l.jpg";
      color-shading-type = "solid";
      picture-options = "zoom";
      primary-color = "#3071AE";
      secondary-color = "#000000";
    };

    # Files (Nautilus)
    "org/gnome/nautilus/preferences" = {
      show-create-link = true;
      show-delete-permanently = true;
      default-folder-viewer = "list-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/nautilus/list-view" = {
      default-column-order = ["name" "size" "type" "owner" "group" "permissions" "date_modified" "date_accessed" "date_created" "recency" "detailed_type"];
      default-visible-columns = ["name" "size" "type" "date_modified"];
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = [1032 1045];
      "initial-size-file-chooser" = [890 550];
      maximized = false;
    };

    # Terminal
    "org/gnome/desktop/default-applications/terminal" = {
      exec = "kitty";
    };

    # App folders
    "org/gnome/desktop/app-folders" = {
      folder-children = ["System" "Utilities" "YaST" "Pardus"];
    };

    "org/gnome/desktop/app-folders/folders/System" = {
      apps = ["nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.DiskUtility.desktop" "im-config.desktop" "org.gnome.Logs.desktop" "org.freedesktop.MalcontentControl.desktop" "org.gnome.tweaks.desktop" "org.gnome.SystemMonitor.desktop"];
      name = "X-GNOME-Shell-System.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = ["org.gnome.Connections.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.font-viewer.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop"];
      name = "X-GNOME-Shell-Utilities.directory";
      translate = true;
    };

    # Shell
    "org/gnome/shell" = {
      favorite-apps = ["mullvad-vpn.desktop" "kitty.desktop" "terminator.desktop" "virtualbox.desktop" "org.gnome.Nautilus.desktop" "firefox-esr.desktop" "chromium.desktop" "1password.desktop" "net.cozic.joplin_desktop.desktop" "org.gnome.Evolution.desktop" "org.onlyoffice.desktopeditors.desktop" "com.discordapp.Discord.desktop" "com.ktechpit.whatsie.desktop" "org.gnome.Software.desktop" "io.gitlab.adhami3310.Impression.desktop" "org.qbittorrent.qBittorrent.desktop"];
      enabled-extensions = ["user-theme@gnome-shell-extensions.gcampax.github.com" "dash-to-dock@micxgx.gmail.com" "GPaste@gnome-shell-extensions.gnome.org" "wifi-signal-plus@jalil.arfaoui.net" "dash2dock-lite@icedman.github.com" "arcmenu@arcmenu.com" "appindicatorsupport@rgcjonas.gmail.com" "blur-my-shell@aunetx" "clipboard-indicator@tudmotu.com" "notification-configurator@exposedcat" "pomodoro-timer@Oguzhankokulu.github.com" "openbar@neuromorph" "quick-settings-audio-panel@rayzeq.github.io" "quake-terminal@diegodario88.github.io" "steal-my-focus-window@steal-my-focus-window" "wallpicker@omarxkhalid.github.io" "just-perfection-desktop@just-perfection" "desktop-widgets@NiffirgkcaJ.github.com" "vitalsWidget@ctrln3rd.github.com" "nowplay@LalaloyXyz" "modernclock@gnome-port" "dynamic-music-pill@andbal" "CoverflowAltTab@palatis.blogspot.com" "wack-lockscreen-clock@rinzler69-wastaken.github.io"];
      disabled-extensions = ["forge@jmmaranan.com" "Vitals@CoreCoding.com" "task-widget@juozasmiskinis.gitlab.io" "soundbar@karthickk.gitlab.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com"];
      disable-user-extensions = false;
      disable-overview-on-startup = false;
      "last-selected-power-profile" = "power-saver";
      "welcome-dialog-last-shown-version" = "48.7";
    };

    "org/gnome/shell/keybindings" = {
      "toggle-overview" = ["<Alt>o"];
      "toggle-message-tray" = ["<Control>F2"];
      "toggle-quick-settings" = ["<Control>F3"];
      "show-screenshot-ui" = ["<Alt>F9"];
    };

    "org/gnome/shell/extensions/arcmenu" = {
      "arcmenu-hotkey" = ["<Control>F1"];
      "menu-layout" = "whisker";
      "menu-height" = 500;
      "menu-width" = 500;
      "left-panel-width" = 175;
      "right-panel-width" = 200;
      "runner-hotkey" = ["<Alt>space"];
      "runner-menu-height" = 625;
      "runner-menu-width" = 710;
      "runner-position" = "Centered";
      "menu-font-size" = 9;
      "menu-button-icon-size" = 22;
      "menu-item-icon-size" = "ExtraSmall";
      "menu-item-grid-icon-size" = "Small";
      "menu-item-category-icon-size" = "ExtraSmall";
      "quicklinks-item-icon-size" = "ExtraSmall";
      "button-item-icon-size" = "ExtraSmall";
      "misc-item-icon-size" = "Extralarge";
      "menu-button-icon" = "emblem-debian-white";
      "show-activities-button" = true;
      "show-category-sub-menus" = true;
      "group-apps-alphabetically-grid-layouts" = true;
      "hide-overview-on-arcmenu-open" = true;
      "highlight-search-result-terms" = true;
      "runner-show-frequent-apps" = true;
      "runner-show-settings-button" = true;
      "vert-separator" = true;
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      "hacks-level" = 1;
      "settings-version" = 2;
      "rounded-blur-found" = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = false;
      "override-background" = true;
      "static-blur" = true;
      brightness = 0.6;
      sigma = 30;
      "style-dash-to-dock" = 0;
    };

    "org/gnome/shell/extensions/clipboard-indicator" = {
      "blink-icon-on-copy" = true;
      "cache-size" = 20;
      "clear-on-boot" = true;
      "history-size" = 20;
      "move-item-first" = true;
      "notify-on-copy" = true;
      "regex-search" = true;
      "strip-text" = true;
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      "apply-custom-theme" = true;
      "background-opacity" = 0.8;
      "custom-theme-shrink" = true;
      "dash-max-icon-size" = 38;
      "dock-position" = "BOTTOM";
      "height-fraction" = 0.65;
      "intellihide-mode" = "ALL_WINDOWS";
      "preferred-monitor" = -2;
      "preferred-monitor-by-connector" = "DP-5";
    };

    "org/gnome/shell/extensions/dash2dock-lite" = {
      "autohide-dash" = false;
      "autohide-speed" = 0.25;
      "blur-background" = false;
      "border-radius" = 7.96;
      "clock-icon" = false;
      "dock-padding" = 0.178;
      "edge-distance" = 0.141;
      "icon-border-radius" = 3.0;
      "icon-shadow" = false;
      "icon-spacing" = 0.0;
      "items-pullout-angle" = 0.5;
      "mounted-icon" = false;
      "preferred-monitor" = 0;
      "shrink-icons" = true;
      "trash-icon" = true;
      "downloads-icon" = true;
      "separator-thickness" = 1;
      "animation-magnify" = 0.03;
      "animation-rise" = 0.15;
      "animation-spread" = 0.47;
      "animation-bounce" = 0.75;
      "scroll-sensitivity" = 0.4;
    };

    "org/gnome/shell/extensions/dynamic-music-pill" = {
      "edge-margin" = 7;
      "enable-lyrics" = false;
      "enable-shadow" = false;
      "enable-transparency" = true;
      "has-seen-first-hint" = true;
      "hide-text" = true;
      "horizontal-offset" = -10;
      "panel-pill-height" = 28;
      "panel-pill-width" = 430;
      "pill-dynamic-width" = false;
      "popup-enable-shadow" = false;
      "popup-hide-on-leave" = true;
      "popup-hide-pill-visualizer" = false;
      "popup-show-album-title" = true;
      "popup-show-visualizer" = true;
      "popup-visualizer-bars" = 20;
      "popup-custom-width" = 360;
      "position-mode" = 3;
      "scroll-on-hover-only" = true;
      "scroll-text" = true;
      "show-pill-border" = false;
      "sync-accent-color" = false;
      "tablet-mode" = 0;
      "target-container" = 2;
      "transparency-art" = false;
      "transparency-strength" = 0;
      "transparency-vis" = false;
      "use-custom-colors" = true;
      "visualizer-bars" = 30;
      "visualizer-height" = 100;
      "visualizer-padding" = 5;
      "visualizer-style" = 3;
    };

    "org/gnome/shell/extensions/openbar" = {
      "position" = "Top";
      "height" = 35.0;
      "bartype" = "Trilands";
      "autotheme-dark" = "Color";
      "autotheme-light" = "Color";
      "autotheme-refresh" = true;
      "autotheme-font" = true;
      "autobg-menu" = true;
      "autofg-bar" = true;
      "autofg-menu" = true;
      "autohg-bar" = true;
      "autohg-menu" = true;
      "bg-change" = true;
      "auto-bgalpha" = true;
      "balpha" = 0.85;
      "bgalpha" = 0.0;
      "bgalpha-wmax" = 1.0;
      "bgalpha2" = 0.6;
      "boxalpha" = 0.0;
      "mbgalpha" = 0.95;
      "msalpha" = 0.85;
      "smbgalpha" = 0.95;
      "isalpha" = 0.95;
      "fgalpha" = 1.0;
      "mfgalpha" = 1.0;
      "halpha" = 0.16;
      "mhalpha" = 0.3;
      "mshalpha" = 0.16;
      "shalpha" = 0.0;
      "bradius" = 30.0;
      "menu-radius" = 21.0;
      "qtoggle-radius" = 50.0;
      "notif-radius" = 10.0;
      "dbradius" = 79.0;
      "winbradius" = 17.0;
      "corner-radius" = true;
      "radius-topleft" = true;
      "radius-topright" = true;
      "radius-bottomleft" = true;
      "radius-bottomright" = true;
      "bwidth" = 1.0;
      "winbwidth" = 1.0;
      "winbalpha" = 1.0;
      "menustyle" = true;
      "dashdock-style" = "Custom";
      "bgpalette" = false;
      "candybar" = false;
      "candyalpha" = 0.0;
      "gradient" = false;
      "mbg-gradient" = false;
      "neon" = false;
      "shadow" = false;
      "dshadow" = false;
      "heffect" = false;
      "traffic-light" = false;
      "set-fullscreen" = true;
      "set-notif-position" = true;
      "trigger-autotheme" = true;
      "apply-accent-shell" = true;
      "apply-all-shell" = true;
      "apply-flatpak" = true;
      "apply-gtk" = true;
      "apply-menu-notif" = true;
      "apply-menu-shell" = true;
      "set-yarutheme" = true;
      "accent-override" = false;
      "color-scheme" = "prefer-dark";
      "view-hint" = 90;
      "headerbar-hint" = 100;
      "sidebar-hint" = 100;
      "window-hint" = 90;
      "card-hint" = 100;
      "monitor-width" = 1920;
      "monitor-height" = 1080;
      "monitors" = "all";
      "vpad" = 5.3;
      "hpad" = 1.0;
      "disize" = 40.0;
      "margin" = 0.0;
      "margin-wmax" = 0.0;
      "bottom-margin" = 0.0;
      "cust-margin-wmax" = false;
      "set-bottom-margin" = false;
      "border-wmax" = false;
      "neon-wmax" = false;
      "wmaxbar" = false;
      "wmax-hbarhint" = false;
      "pause-reload" = false;
      "reloadstyle" = false;
      "removestyle" = false;
      "trigger-reload" = false;
      "set-overview" = false;
      "set-notifications" = false;
      "set-notif-position" = true;
      "import-export" = false;
      "prefs-visible-page" = 0;
      "default-font" = "Sans 12";
      "font" = "";
      "bordertype" = "solid";
      "sbar-gradient" = "none";
      "gtk-shadow" = "None";
      "gtk-transparency" = 1.0;
      "gtk-popover" = true;
      "hbar-gtk3only" = true;
      "handle-border" = 3.0;
      "slider-height" = 4.0;
      "smbgoverride" = true;
      "width-top" = true;
      "width-bottom" = true;
      "width-left" = true;
      "width-right" = true;
      "fitts-widgets" = true;
    };

    "org/gnome/shell/extensions/notification-configurator" = {
      "notification-position" = "right";
      "notification-threshold" = 4000;
      "notification-timeout" = 2500;
    };

    "org/gnome/shell/extensions/pomodoro-timer" = {
      "auto-start-breaks" = true;
      "auto-start-work" = true;
      "session-started" = true;
      "session-state" = "idle";
      "session-remaining-time" = 1500;
      "session-completed-intervals" = 3;
      "session-interval-type" = "work";
    };

    "org/gnome/shell/extensions/quake-terminal" = {
      "animation-time" = 110;
      "horizontal-size" = 95;
      "vertical-size" = 95;
      "render-on-primary-monitor" = true;
      "terminal-id" = "kitty.desktop";
      "terminal-shortcut" = ["<Control><Alt>q"];
    };

    "org/gnome/shell/extensions/quick-settings-audio-panel" = {
      "panel-type" = "independent-panel";
      version = 2;
    };

    "org/gnome/shell/extensions/vitalswidget" = {
      orientation = "horizontal";
      "vital-orientation" = "vertical";
      "show-labels" = true;
      "show-rings" = true;
      "padding-horizontal" = 3;
      "padding-vertical" = 1;
      "position-x" = 80.0;
      "position-y" = 91.0;
    };

    "org/gnome/shell/extensions/wack-lockscreen-clock" = {
      "lockscreen-mode" = "cupertino";
      "cupertino-always-show-user" = true;
    };

    "org/gnome/shell/extensions/wallpicker" = {
      "picture-mode" = "zoom";
      "wall-dirs" = ["/home/stefan-hacks/Pictures/wallpapers"];
    };

    "org/gnome/shell/extensions/just-perfection" = {
      animation = 0;
      "clock-menu-position" = 0;
      "startup-status" = 0;
    };

    "org/gnome/shell/extensions/desktop-widgets" = {
      "profiles-json" = ''{"activeProfileId":"default","profiles":{"default":{"name":"Default","widgets":[{"type":"datetime","config":{"format":"MMMM d, yyyy"},"uuid":"19e553ab-3d5f-46bf-bcbb-aaceadb28943","gridCol":3,"gridRow":2,"anchor":"center"}],"positionMode":"grid","gridColumns":6,"gridRows":4}}}'';
    };

    # Calculator
    "org/gnome/calculator" = {
      base = 10;
      "button-mode" = "basic";
      "target-units" = "radian";
      "source-units" = "degree";
      "window-maximized" = false;
      "window-size" = [482 616];
    };

    # Calendar
    "org/gnome/calendar" = {
      "active-view" = "month";
      "window-maximized" = true;
      "window-size" = [768 600];
    };

    # Clocks
    "org/gnome/clocks" = {
      "world-clocks" = [
        {"location" = lib.hm.gvariant.mkVariant (lib.hm.gvariant.mkTuple [2 (lib.hm.gvariant.mkTuple ["Rio de Janeiro" "SBRJ" true [(lib.hm.gvariant.mkTuple [(-0.39968039870670141) (-0.75340046626198298)])] [(lib.hm.gvariant.mkTuple [(-0.39968039870670141) (-0.75456400746111763)])])])}
        {"location" = lib.hm.gvariant.mkVariant (lib.hm.gvariant.mkTuple [2 (lib.hm.gvariant.mkTuple ["London" "EGWU" false [(lib.hm.gvariant.mkTuple [0.89971722940307675 (-0.007272211034407213)])] [(lib.hm.gvariant.mkTuple [0.89971722940307675 (-0.007272211034407213)])])])}
        {"location" = lib.hm.gvariant.mkVariant (lib.hm.gvariant.mkTuple [2 (lib.hm.gvariant.mkTuple ["Paris" "LFPB" true [(lib.hm.gvariant.mkTuple [0.85462956287765413 0.042760566673861078])] [(lib.hm.gvariant.mkTuple [0.8528842336256599 0.040724343395436846)])])])}
        {"location" = lib.hm.gvariant.mkVariant (lib.hm.gvariant.mkTuple [2 (lib.hm.gvariant.mkTuple ["Mexico City" "MMMX" true [(lib.hm.gvariant.mkTuple [0.33917564548646723 (-1.7296212887263802)])] [(lib.hm.gvariant.mkTuple [0.33919020153242879 (-1.7302951778038682)])])])}
        {"location" = lib.hm.gvariant.mkVariant (lib.hm.gvariant.mkTuple [2 (lib.hm.gvariant.mkTuple ["New York" "KNYC" true [(lib.hm.gvariant.mkTuple [0.71180344078725644 (-1.2909618758762367)])] [(lib.hm.gvariant.mkTuple [0.71059804659265924 (-1.2916478949920254)])])])}
        {"location" = lib.hm.gvariant.mkVariant (lib.hm.gvariant.mkTuple [2 (lib.hm.gvariant.mkTuple ["Los Angeles" "KCQT" true [(lib.hm.gvariant.mkTuple [0.59370283970450188 (-2.0644336110828618)])] [(lib.hm.gvariant.mkTuple [0.59432360095955872 (-2.063741622941031)])])])}
        {"location" = lib.hm.gvariant.mkVariant (lib.hm.gvariant.mkTuple [2 (lib.hm.gvariant.mkTuple ["Tokyo" "RJTI" true [(lib.hm.gvariant.mkTuple [0.62191898430954862 2.4408429589140699)])] [(lib.hm.gvariant.mkTuple [0.62282074357417661 2.4391218722853854)])])}
        {"location" = lib.hm.gvariant.mkVariant (lib.hm.gvariant.mkTuple [2 (lib.hm.gvariant.mkTuple ["Jakarta" "WIII" false [(lib.hm.gvariant.mkTuple [(-0.10675597839808398) 1.8613936472519526)])] [(lib.hm.gvariant.mkTuple [(-0.10675597839808398) 1.8613936472519526)])])}
        {"location" = lib.hm.gvariant.mkVariant (lib.hm.gvariant.mkTuple [2 (lib.hm.gvariant.mkTuple ["Doha" "OTBD" true [(lib.hm.gvariant.mkTuple [0.44069563612856821 0.90000812342950687)])] [(lib.hm.gvariant.mkTuple [0.44133559600539696 0.89942633537664685)])])}
      ];
    };

    # Maps
    "org/gnome/maps" = {
      "last-viewed-location" = [(-22.7636) (-43.3996)];
      "map-type" = "MapsVectorSource";
      "transportation-type" = "car";
      "window-maximized" = true;
    };

    # Weather
    "org/gnome/Weather" = {
      locations = [(lib.hm.gvariant.mkTuple [2 (lib.hm.gvariant.mkTuple ["Rio de Janeiro" "SBRJ" true [(lib.hm.gvariant.mkTuple [(-0.39968039870670141) (-0.75340046626198298)])] [(lib.hm.gvariant.mkTuple [(-0.39968039870670141) (-0.75456400746111763)])])])];
      "window-maximized" = false;
      "window-width" = 519;
      "window-height" = 540;
    };

    # System Monitor
    "org/gnome/gnome-system-monitor" = {
      "show-dependencies" = false;
      "show-whose-processes" = "user";
    };

    # Power settings
    "org/gnome/settings-daemon/plugins/power" = {
      "power-button-action" = "interactive";
      "sleep-inactive-ac-timeout" = 1200;
      "sleep-inactive-ac-type" = "suspend";
    };

    # Media keys
    "org/gnome/settings-daemon/plugins/media-keys" = {
      "custom-keybindings" = [];
      "mic-mute" = ["<Alt>F8"];
      "next" = ["<Control><Super>period"];
      "play" = ["<Control><Super>slash"];
      "previous" = ["<Control><Super>comma"];
      "screen-brightness-down" = ["<Ctrl><Super>Down"];
      "screen-brightness-up" = ["<Ctrl><Super>Up"];
      "screensaver" = ["<Control><Alt><Super>l"];
      "volume-down" = ["<Alt>F6"];
      "volume-mute" = ["<Alt>F5"];
      "volume-up" = ["<Alt>F7"];
    };

    # Control Center
    "org/gnome/control-center" = {
      "last-panel" = "system";
      "window-state" = [948 1029 false];
    };

    # Music
    "org/gnome/Music" = {
      "window-maximized" = true;
    };

    # GPaste
    "org/gnome/GPaste" = {
      "growing-lines" = true;
      "images-support" = true;
      "min-text-item-size" = lib.hm.gvariant.mkUint64 10;
      "primary-to-history" = true;
      "synchronize-clipboards" = true;
      "track-extension-state" = true;
      "trim-items" = true;
    };

    # GWeather
    "org/gnome/GWeather4" = {
      "temperature-unit" = "centigrade";
    };

    # Loupe image viewer
    "org/gnome/Loupe" = {
      "show-properties" = true;
    };

    # Totem video player
    "org/gnome/Totem" = {
      "active-plugins" = ["mpris" "autoload-subtitles" "screenshot" "rotation" "recent" "variable-rate" "open-directory" "skipto" "screensaver" "save-file" "movie-properties"];
      "subtitle-encoding" = "UTF-8";
    };
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # DESKTOP APPLICATIONS
  # ═══════════════════════════════════════════════════════════════════════════
  home.packages = with pkgs; [
    # File manager
    gnome.nautilus
    gnome.nautilus-python
    
    # Image viewer
    gthumb
    
    # Document viewer
    zathura
    
    # System utilities
    gnome-system-monitor
    gnome-calculator
    gnome-calendar
    # Note: gnome-todo removed - package no longer exists
    gnome-screenshot
    gnome-connections
    
    # Settings
    gnome-settings-daemon
    gnome-tweaks
    dconf-editor
    
    # ═══════════════════════════════════════════════════════════════════════════
    # GNOME EXTENSIONS - For Ghost Host / stefan-hacks
    # ═══════════════════════════════════════════════════════════════════════════
    # Extension Manager GUI tool
    gnome-extension-manager
    
    # Base extensions package
    gnome-shell-extensions
    
    # Individual extensions from pkgs.gnomeExtensions
    gnomeExtensions.appindicator
    gnomeExtensions.open-bar
    gnomeExtensions.arcmenu
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dynamic-music-pill
    gnomeExtensions.modern-clock
    gnomeExtensions.notification-configurator
    gnomeExtensions.quake-terminal
    gnomeExtensions.quick-settings-audio-panel
    gnomeExtensions.steal-my-focus-window
    gnomeExtensions.user-themes
    gnomeExtensions.vitals-widget
    gnomeExtensions.wallpicker
  ];
  
  # ═══════════════════════════════════════════════════════════════════════════
  # ENABLE GNOME EXTENSIONS (UUIDs for extension-manager to activate)
  # ═══════════════════════════════════════════════════════════════════════════
  # These are the extension UUIDs that will be enabled by default
  home.file = {
    ".config/gnome-extensions/enabled".text = ''
      appindicator@kavisouza.me
      openbar@kali.team
      arcmenu@arcmenu.com
      blur-my-shell@aunetx
      dynamic-music-pill@peixotonatan
      modern-clock@modi-a-hammad
      notification-configurator@trixter
      quake-terminal@yurin.cold
      quick-settings-audio-panel@peixotonatan
      steal-my-focus-window@kavelra
      user-theme@gnome-shell-extensions.gcampax.github.com
      vitals-widget@corecoding.com
      wallpicker@tomasz.jasionar
    '';
  };
}
