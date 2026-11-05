#!/bin/bash
set -e

CHROOT_DIR="/mnt/delgadoos"
WORK_DIR="/tmp/delgadoos_iso"
ISO_NAME="delgadoos-1.0-x86_64.iso"

echo "[+] Preparando estrutura da ISO"
mkdir -p $WORK_DIR/iso/{boot/grub,LiveOS}

echo "[+] Compactando sistema com mksquashfs (ZSTD para alta compressão)"
mksquashfs $CHROOT_DIR $WORK_DIR/iso/LiveOS/rootfs.img -comp zstd -b 1M -noappend -Xcompression-level 22

echo "[+] Configurando o GRUB para boot da imagem"
cat <<EOF > $WORK_DIR/iso/boot/grub/grub.cfg
set default=0
set timeout=5
menuentry "DelgadoOS (Live/Install)" {
    linux /boot/vmlinuz boot=LiveOS quiet splash
    initrd /boot/initrd.img
}
EOF

echo "[+] Copiando Kernel (vmlinuz) e Initramfs"
cp $CHROOT_DIR/boot/vmlinuz $WORK_DIR/iso/boot/vmlinuz
cp $CHROOT_DIR/boot/initrd.img $WORK_DIR/iso/boot/initrd.img

echo "[+] Gerando arquivo ISO usando xorriso"
grub-mkrescue -o ../$ISO_NAME $WORK_DIR/iso

echo "[+] Sucesso! Imagem gerada: $ISO_NAME"
ls -lh ../$ISO_NAME
