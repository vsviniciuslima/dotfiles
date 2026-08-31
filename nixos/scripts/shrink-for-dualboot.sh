#!/usr/bin/env bash
set -euo pipefail

# Script para encolher a partição root do NixOS para 200GiB
# Deve ser executado a partir de um live USB com a partição desmontada
#
# Uso: sudo ./shrink-for-dualboot.sh

DEVICE="${DEVICE:-/dev/nvme0n1}"
PARTITION="${DEVICE}p2"
TARGET_SIZE="200GiB"
TARGET_FS_SIZE="195G"

echo "=========================================="
echo "Encolhimento de partição NixOS"
echo "=========================================="
echo "Device: $DEVICE"
echo "Partição root: $PARTITION"
echo "Tamanho alvo (partição): $TARGET_SIZE"
echo "Tamanho alvo (filesystem): $TARGET_FS_SIZE"
echo "=========================================="
echo

# Verificar se rodando como root
if [[ $EUID -ne 0 ]]; then
  echo "Erro: Este script deve rodar com sudo"
  exit 1
fi

# Verificar se a partição está montada
if mountpoint -q "$PARTITION"; then
  echo "Erro: $PARTITION está montada. Desmonte antes de rodar este script."
  echo "Execute: umount $PARTITION"
  exit 1
fi

# Mostrar layout atual
echo "Layout de disco ATUAL:"
lsblk "$DEVICE"
echo

# Pedir confirmação explícita
echo "⚠️  AVISO: Este processo é destrutivo e irreversível."
echo "Faça backup antes de prosseguir."
echo
read -p "Digite 'YES' para confirmar o encolhimento: " confirmation

if [[ "$confirmation" != "YES" ]]; then
  echo "Operação cancelada."
  exit 0
fi

echo
echo "Iniciando encolhimento..."
echo

# 1. Check filesystem
echo "[1/5] Verificando filesystem..."
e2fsck -f "$PARTITION" || true
sleep 1

# 2. Shrink filesystem (com margem de segurança)
echo "[2/5] Encolhendo filesystem para $TARGET_FS_SIZE..."
resize2fs "$PARTITION" "$TARGET_FS_SIZE"
sleep 1

# 3. Shrink partition
echo "[3/5] Encolhendo partição para $TARGET_SIZE..."
parted --script "$DEVICE" resizepart 2 "$TARGET_SIZE"
sleep 1

# 4. Grow filesystem para preencher a partição
echo "[4/5] Expandindo filesystem para preencher a partição..."
resize2fs "$PARTITION"
sleep 1

# 5. Final check
echo "[5/5] Verificação final..."
e2fsck -f "$PARTITION" || true
sleep 1

echo
echo "=========================================="
echo "Layout de disco APÓS:"
lsblk "$DEVICE"
echo "=========================================="
echo
echo "✓ Encolhimento concluído com sucesso!"
echo "Reinicie a máquina e dê boot no NixOS instalado."
echo "Confirme com: df -h /"
