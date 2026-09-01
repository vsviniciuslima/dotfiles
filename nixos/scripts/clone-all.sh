#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-/home/viniciussl/Workspace}"

echo "======================================================"
echo "  GitHub Workspace Cloner"
echo "  Destino: $TARGET_DIR"
echo "======================================================"

# 1. Verificar autenticação gh
if ! gh auth status &>/dev/null; then
    echo "[-] Erro: gh CLI não autenticada. Execute 'gh auth login'." >&2
    exit 1
fi

mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# 2. Obter lista de repositórios do usuário logado
echo "[*] Obtendo lista de repositórios..."
REPOS=$(gh repo list --limit 300 --json name,nameWithOwner --jq '.[] | .nameWithOwner')
TOTAL=$(echo "$REPOS" | grep -c . || true)

if [ "$TOTAL" -eq 0 ]; then
    echo "[-] Nenhum repositório encontrado para a conta logada."
    exit 0
fi

echo "[*] Encontrados $TOTAL repositórios."
echo "------------------------------------------------------"

COUNT=0
SKIPPED=0
CLONED=0
FAILED=0

while IFS= read -r repo_full; do
    [ -z "$repo_full" ] && continue
    COUNT=$((COUNT + 1))
    repo_name="${repo_full#*/}"

    if [ -d "$TARGET_DIR/$repo_name" ]; then
        echo "[$COUNT/$TOTAL] [PULANDO] $repo_name (já existe)"
        SKIPPED=$((SKIPPED + 1))
    else
        echo "[$COUNT/$TOTAL] [CLONANDO] $repo_full -> $repo_name..."
        if gh repo clone "$repo_full" "$TARGET_DIR/$repo_name" -- --quiet 2>/dev/null; then
            CLONED=$((CLONED + 1))
        else
            echo "[-] Falha ao clonar $repo_full"
            FAILED=$((FAILED + 1))
        fi
    fi
done <<< "$REPOS"

echo "------------------------------------------------------"
echo "[+] Concluído!"
echo "    Total processado: $COUNT"
echo "    Clonados com sucesso: $CLONED"
echo "    Ignorados (já existiam): $SKIPPED"
echo "    Falhas: $FAILED"
echo "======================================================"
