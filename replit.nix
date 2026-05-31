{ pkgs }: {
  deps = [
    pkgs.debian-utils
    pkgs.xorg.xorgserver
    pkgs.xorg.xf86videodummy
    pkgs.xorg.xinit
    pkgs.fluxbox
    pkgs.novnc
    pkgs.websockify
    pkgs.python3
    pkgs.bash
    pkgs.shared-mime-info
    pkgs.xterm
  ];
}
