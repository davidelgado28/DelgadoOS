#!/bin/bash
set -e

CHROOT_DIR="/mnt/delgadoos"
echo "[+] Instalando Wine-Staging..."
chroot $CHROOT_DIR /bin/bash -c "install_packages wine-staging winetricks"

echo "[+] Configurando binfmt_misc para arquivos PE (.exe)"
mkdir -p $CHROOT_DIR/etc/binfmt.d/
cp ../binfmt/wine.conf $CHROOT_DIR/etc/binfmt.d/wine.conf

cat <<EOF > $CHROOT_DIR/usr/share/applications/wine.desktop
[Desktop Entry]
Name=Wine Windows Program Loader
Exec=wine start /Unix %f
MimeType=application/x-ms-dos-executable;application/x-msdownload;
Icon=wine
NoDisplay=true
Type=Application
EOF

echo "[+] Inserindo associações MIME padrão"
mkdir -p $CHROOT_DIR/etc/skel/.config/
cp ../config/mimeapps.list $CHROOT_DIR/etc/skel/.config/mimeapps.list

echo "[+] Integração com .exe concluída."
