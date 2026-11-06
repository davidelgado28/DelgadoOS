#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${ROOT_DIR}/config/build.env"

"${ROOT_DIR}/scripts/check-rootfs.sh"

ROOTFS_ABS="$(realpath "${ROOTFS_DIR}")"
WORK_ABS="${ROOT_DIR}/${WORK_DIR}"
OUTPUT_ABS="${ROOT_DIR}/${OUTPUT_DIR}"
ISO_ROOT="${WORK_ABS}/iso-root"

mkdir -p "${WORK_ABS}" "${OUTPUT_ABS}"
rm -rf "${ISO_ROOT}"
mkdir -p "${ISO_ROOT}/boot/grub" "${ISO_ROOT}/LiveOS"

shopt -s nullglob
kernels=( "${ROOTFS_ABS}/boot"/${KERNEL_GLOB} )
initramfs=( "${ROOTFS_ABS}/boot"/${INITRAMFS_GLOB} )
shopt -u nullglob

KERNEL_FILE="${kernels[0]}"
INITRAMFS_FILE="${initramfs[0]}"

cp "${KERNEL_FILE}" "${ISO_ROOT}/boot/vmlinuz"
cp "${INITRAMFS_FILE}" "${ISO_ROOT}/boot/initramfs"

mksquashfs "${ROOTFS_ABS}" "${ISO_ROOT}/LiveOS/squashfs.img" \
  -comp xz -noappend -e dev proc sys run tmp

cat > "${ISO_ROOT}/boot/grub/grub.cfg" <<EOF
set timeout=5
set default=0

menuentry "DelgadoOS" {
    linux /boot/vmlinuz root=live:CDLABEL=${ISO_LABEL} rd.live.image quiet
    initrd /boot/initramfs
}
EOF

grub-mkrescue \
  -o "${OUTPUT_ABS}/${ISO_NAME}" \
  "${ISO_ROOT}" \
  -- \
  -volid "${ISO_LABEL}"

printf '\nISO criada: %s\n' "${OUTPUT_ABS}/${ISO_NAME}"
