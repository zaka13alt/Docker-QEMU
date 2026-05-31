{ pkgs }: {
  deps = [
    pkgs.bashInteractive
    pkgs.xorg.xorgserver
    pkgs.xorg.xf86videodummy
    pkgs.xterm
    pkgs.openbox
    pkgs.novnc
    pkgs.websockify
    pkgs.fluxbox
    pkgs.shared-mime-info
    pkgs.gsettings-desktop-schemas
  ];
}
