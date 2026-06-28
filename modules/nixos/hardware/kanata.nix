# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/HARDWARE/KANATA.NIX - Keyboard Remapping via Kanata
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  services.kanata = {
    enable = true;
    keyboards.default = {
      devices = [];
      config = ''
        (defsrc caps)
        (defalias cap esc)
        (deflayer base @cap)
      '';
    };
  };
  hardware.uinput.enable = true;
}
