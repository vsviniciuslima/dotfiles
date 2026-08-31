#!/usr/bin/env bash
set -euo pipefail

# Script para verificar que o dual-boot foi configurado corretamente
# Executa após a instalação do Windows
#
# Uso: sudo ./verify-dualboot.sh

DEVICE="${DEVICE:-/dev/nvme0n1}"

echo "=========================================="
echo "Verificação do dual-boot"
echo "=========================================="
echo

# Verificar se rodando como root
if [[ $EUID -ne 0 ]]; then
  echo "Aviso: rodando como não-root. Alguns comandos podem falhar."
  echo
fi

# 1. Layout de partições
echo "[1/4] Layout de partições esperado:"
echo "  - nvme0n1p1: EFI System (1G, /boot)"
echo "  - nvme0n1p2: Linux filesystem (200G, NixOS)"
echo "  - nvme0n1p3: Windows MSR (16M)"
echo "  - nvme0n1p4: Windows NTFS (~730G)"
echo
echo "Layout ATUAL:"
lsblk "$DEVICE" -o NAME,SIZE,TYPE,FSTYPE,PARTTYPE,PARTUUID
echo

# 2. Entradas de boot
echo "[2/4] Entradas de boot no NVRAM (efibootmgr):"
if command -v efibootmgr &> /dev/null; then
  efibootmgr -v || echo "  (efibootmgr falhou — pode ser esperado em alguns hardwares)"
else
  echo "  (efibootmgr não está instalado)"
fi
echo

# 3. Status do systemd-boot
echo "[3/4] Status do systemd-boot (bootctl):"
if command -v bootctl &> /dev/null; then
  bootctl status 2>&1 | head -20 || true
else
  echo "  (bootctl não está disponível)"
fi
echo

# 4. Entradas do boot loader
echo "[4/4] Entradas disponíveis em /boot/loader/entries/:"
if [[ -d /boot/loader/entries/ ]]; then
  ls -la /boot/loader/entries/
  echo
  echo "Conteúdo das entradas:"
  for entry in /boot/loader/entries/*.conf; do
    if [[ -f "$entry" ]]; then
      echo "--- $(basename "$entry") ---"
      cat "$entry"
      echo
    fi
  done
else
  echo "  Diretório /boot/loader/entries/ não encontrado"
fi

echo "=========================================="
echo "Checklist final:"
echo "  ✓ Layout de partições está correto (4 partições)?"
echo "  ✓ Ambas entradas de boot (Linux + Windows) aparecem?"
echo "  ✓ systemd-boot está ativo e em /boot?"
echo "  ✓ Ambas entradas (.conf) estão em /boot/loader/entries/?"
echo
echo "Se algum item falhou, verifique manualmente com:"
echo "  lsblk $DEVICE"
echo "  sudo efibootmgr -v"
echo "  sudo bootctl status"
echo "  ls -la /boot/loader/entries/"
echo "=========================================="
