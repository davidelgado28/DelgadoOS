#!/bin/bash
set -e

CHROOT_DIR="/mnt/delgadoos"
echo "[+] Inicializando base LFS no diretório $CHROOT_DIR"
mkdir -p $CHROOT_DIR/{bin,boot,dev,etc,home,lib,mnt,opt,proc,root,run,sbin,sys,tmp,usr,var}

echo "[+] Compilando/Instalando Toolchain de Desenvolvimento"
chroot $CHROOT_DIR /bin/bash -c "install_packages gcc make git python3 nodejs"

echo "[+] Reduzindo tamanho do sistema"
chroot $CHROOT_DIR /bin/bash -c "find /usr/lib -type f -name '*.a' -exec strip --strip-debug {} ';'"
chroot $CHROOT_DIR /bin/bash -c "find /usr/lib -type f -name '*.so*' -exec strip --strip-unneeded {} ';'"
chroot $CHROOT_DIR /bin/bash -c "find /usr/bin -type f -exec strip --strip-all {} ';'"

echo "[+] Limpando manuais e documentações"
rm -rf $CHROOT_DIR/usr/share/{doc,info,man}
echo "[+] Base LFS pronta."
