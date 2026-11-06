#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${ROOT_DIR}/config/build.env"

fail() {
    printf 'ERRO: %s\n' "$*" >&2
    exit 1
}

[[ -d "${ROOTFS_DIR}" ]] || fail \
  "Rootfs não encontrado: ${ROOTFS_DIR}. Compile e coloque o sistema nesse diretório."

[[ -x "${ROOTFS_DIR}/bin/sh" || -x "${ROOTFS_DIR}/usr/bin/sh" ]] || fail \
  "Não encontrei um shell executável no rootfs."

[[ -d "${ROOTFS_DIR}/boot" ]] || fail \
  "Diretório /boot ausente no rootfs."

shopt -s nullglob
kernels=( "${ROOTFS_DIR}/boot"/${KERNEL_GLOB} )
initramfs=( "${ROOTFS_DIR}/boot"/${INITRAMFS_GLOB} )
shopt -u nullglob

((${#kernels[@]} > 0)) || fail \
  "Não encontrei ${KERNEL_GLOB} em ${ROOTFS_DIR}/boot."

((${#initramfs[@]} > 0)) || fail \
  "Não encontrei ${INITRAMFS_GLOB} em ${ROOTFS_DIR}/boot."

for tool in mksquashfs grub-mkrescue xorriso; do
    command -v "${tool}" >/dev/null 2>&1 || fail \
      "Ferramenta necessária ausente: ${tool}"
done

printf 'Rootfs verificado: %s\n' "${ROOTFS_DIR}"
printf 'Kernel: %s\n' "${kernels[0]}"
printf 'Initramfs: %s\n' "${initramfs[0]}"
