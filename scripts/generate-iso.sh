#!/bin/bash
set -e

OUT_DIR="$(pwd)/out"
ISO_DIR="$(pwd)/build_iso"
LFS="/mnt/delgadoos"

mkdir -p "$OUT_DIR" "$ISO_DIR/boot/grub" "$ISO_DIR/casper"

echo "Limpando arquivos de depuração (Stripping) para reduzir tamanho"
find $LFS/{,usr/}{bin,lib,sbin} -type f -exec strip --strip-debug '{}' ';' 2>/dev/null || true

echo "Removendo documentação, man pages e arquivos temporários"
rm -rf $LFS/usr/share/{doc,man,info}
rm -rf $LFS/tmp/*

echo "Gerando sistema de arquivos compactado"
mksquashfs $LFS $ISO_DIR/casper/filesystem.squashfs -comp xz -b 1048576 -always-use-fragments -no-recovery -e boot

echo "Copiando Kernel e Initramfs"
cp $LFS/boot/vmlinuz-* $ISO_DIR/boot/vmlinuz
cp $LFS/boot/initrd.img-* $ISO_DIR/boot/initrd.img

echo "Configurando Bootloader"
cat <<EOF > $ISO_DIR/boot/grub/grub.cfg
set default="0"
set timeout=5

menuentry "DelgadoOS - Live Dev Environment" {
    linux /boot/vmlinuz boot=casper quiet splash
    initrd /boot/initrd.img
}
EOF

echo "Gerando delgadoos.iso via Xorriso..."
grub-mkrescue -o "$OUT_DIR/delgadoos.iso" "$ISO_DIR"

echo "Limpeza de diretórios de build temporários..."
rm -rf "$ISO_DIR"
