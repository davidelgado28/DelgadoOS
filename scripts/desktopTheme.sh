#!/bin/bash
set -e

CHROOT_DIR="/mnt/delgadoos"

echo "[+] Instalando Xorg, XFCE4 e Whisker Menu"
chroot $CHROOT_DIR /bin/bash -c "install_packages xorg-server xfce4 xfce4-whisker-plugin alacritty"

echo "[+] Instalando Brave Browser e VS Code"
chroot $CHROOT_DIR /bin/bash -c "install_packages brave-browser code"

echo "[+] Aplicando fontes e tema Dracula"
chroot $CHROOT_DIR /bin/bash -c "install_packages ttf-fira-code"

mkdir -p $CHROOT_DIR/etc/skel/.config/gtk-3.0/
mkdir -p $CHROOT_DIR/etc/skel/.config/alacritty/
cp ../config/gtk-3.0/settings.ini $CHROOT_DIR/etc/skel/.config/gtk-3.0/settings.ini
cp ../config/alacritty/alacritty.yml $CHROOT_DIR/etc/skel/.config/alacritty/alacritty.yml

cat <<EOF > $CHROOT_DIR/etc/skel/.xinitrc
# Configura o layout do teclado e inicia o XFCE
setxkbmap br
export GTK_THEME=Dracula
exec startxfce4
EOF

echo "[+] Interface e aplicativos instalados."
