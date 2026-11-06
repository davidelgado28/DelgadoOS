#!/bin/bash
set -e

export LFS=/mnt/delgadoos
export LFS_TGT=$(uname -m)-delgadoos-linux-gnu
export MAKEFLAGS="-j$(nproc)"

echo "==> Iniciando construção do DelgadoOS"

mkdir -pv $LFS/{bin,etc,lib,sbin,usr,var,tools,build}
case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac

echo "==> Fase 1: Compilando Sistema Base LFS"
bash scripts/LFS-page.sh

echo "==> Fase 2: Configurando XFCE e Interface Gráfica (Dark Mode)"
chroot "$LFS" /usr/bin/env -i HOME=/root TERM="$TERM" /bin/bash /scripts/blfs-gui.sh

echo "==> Fase 3: Instalando Stack de Desenvolvimento e Browsers"
chroot "$LFS" /usr/bin/env -i HOME=/root TERM="$TERM" /bin/bash /scripts/dev-apps.sh

echo "==> Fase 4: Limpeza e Geração da Imagem ISO"
bash scripts/generate-iso.sh

echo "==> Sucesso! delgadoos.iso gerado na pasta ./out/"
