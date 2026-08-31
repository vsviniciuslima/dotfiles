#!/usr/bin/env bash
set -euo pipefail

# Script para preparar o pendrive do Windows com Ventoy
# O Ventoy já deve estar instalado no pendrive
#
# Uso: sudo ./prepare-windows-usb.sh /caminho/para/Win11.iso /dev/sdX

if [[ $# -lt 2 ]]; then
  echo "Uso: sudo ./prepare-windows-usb.sh <caminho-iso-windows> <device-pendrive>"
  echo "Exemplo: sudo ./prepare-windows-usb.sh ~/Downloads/Win11.iso /dev/sda"
  exit 1
fi

ISO_PATH="$1"
DEVICE="$2"
VENTOY_PART="${DEVICE}1"
MOUNT_POINT="/tmp/ventoy-mount-$$"

echo "=========================================="
echo "Preparação do pendrive Windows com Ventoy"
echo "=========================================="
echo "ISO: $ISO_PATH"
echo "Device: $DEVICE"
echo "Partição Ventoy: $VENTOY_PART"
echo "=========================================="
echo

# Verificar se rodando como root
if [[ $EUID -ne 0 ]]; then
  echo "Erro: Este script deve rodar com sudo"
  exit 1
fi

# Verificar se a ISO existe
if [[ ! -f "$ISO_PATH" ]]; then
  echo "Erro: ISO não encontrada: $ISO_PATH"
  exit 1
fi

# Verificar se o device existe
if [[ ! -b "$DEVICE" ]]; then
  echo "Erro: Device não encontrado: $DEVICE"
  exit 1
fi

# Mostrar informações do device
echo "Informações do device $DEVICE:"
lsblk "$DEVICE"
echo

# Pedir confirmação explícita
echo "⚠️  AVISO: Qualquer arquivo já presente no pendrive será apagado."
echo "Confirme que está usando o device correto: $DEVICE"
echo
read -p "Digite 'YES' para continuar: " confirmation

if [[ "$confirmation" != "YES" ]]; then
  echo "Operação cancelada."
  exit 0
fi

echo
echo "Iniciando preparação..."
echo

# Desmontar o device se já estiver montado
echo "[1/3] Desmontando partições de $DEVICE..."
for part in "${DEVICE}"*; do
  if mountpoint -q "$part" 2>/dev/null; then
    echo "Desmontando $part..."
    umount "$part" || true
  fi
done
sleep 1

# Copiar a ISO para a partição de dados do Ventoy
echo "[2/3] Montando partição Ventoy..."
mkdir -p "$MOUNT_POINT"
mount "$VENTOY_PART" "$MOUNT_POINT"
sleep 1

echo "[3/3] Copiando ISO para o pendrive..."
echo "Fonte: $ISO_PATH"
echo "Destino: $MOUNT_POINT/"
# Usar cp com progresso (rsync mais lento mas dá feedback melhor)
rsync -avh --progress "$ISO_PATH" "$MOUNT_POINT/" || {
  echo "Erro ao copiar a ISO. Desmontando..."
  umount "$MOUNT_POINT"
  rm -rf "$MOUNT_POINT"
  exit 1
}

# Sincronizar
echo
echo "Sincronizando filesystem..."
sync

# Desmontar
echo "Desmontando..."
umount "$MOUNT_POINT"
rm -rf "$MOUNT_POINT"

echo
echo "=========================================="
echo "✓ Pendrive preparado com sucesso!"
echo "ISO copiada: $(basename "$ISO_PATH")"
echo "=========================================="
echo
echo "O pendrive está pronto para boot com o Ventoy."
echo "Reinicie e selecione o ISO do Windows 11 no menu do Ventoy."
