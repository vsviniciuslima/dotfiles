#!/usr/bin/env bash
# Script para organizar os repositórios de /home/viniciussl/Workspace
# no Modelo Híbrido (Projetos / Estudos / Acadêmico / Looplex / Infra / Docs / Forks)
set -euo pipefail

BASE_DIR="${1:-/home/viniciussl/Workspace}"
cd "$BASE_DIR"

echo "[*] Organizando repositórios em $BASE_DIR..."

move_repo() {
    local target_dir="$1"
    local repo_name="$2"
    if [ -d "$BASE_DIR/$repo_name" ]; then
        mkdir -p "$BASE_DIR/$target_dir"
        echo "  -> Movendo $repo_name para $target_dir/"
        mv "$BASE_DIR/$repo_name" "$BASE_DIR/$target_dir/"
    fi
}

# 1. Acadêmico (USP)
for r in ACH2026-Ep1 redes-ep2 mqamv dsid-norton GeradorDeRelatorios Pong; do
    move_repo "academic" "$r"
done

# 2. Looplex (Corporativo)
for r in looplex-azure-function looplex-spring-cloud-azure-function looplex-xp looplex-java-spring-template looplex-documentation; do
    move_repo "work/looplex" "$r"
done

# 3. Projetos / Apps Ativos
# Ecossistema e-simulados
for r in e-simulados e-simulados-api e-simulados-front simulados; do
    move_repo "projects/e-simulados" "$r"
done
# Ferramentas e Apps Pessoais
for r in dev-cli lp clipboard-sync whatsapp mkdocs-specialist aissistent DocumentAssembler document-assembler-deysi camel-openapi-generator; do
    move_repo "projects/apps" "$r"
done

# 4. Estudos / Sandboxes
# Java / Spring / Quarkus
for r in spotify sales gifts quarkus-api quarkus-azure-function quarkus-az-function javaee commit-basics spring-bootstrap spring-security spring kanban-api learningGson demo test sandbox pubsub-dapr-aks-java integration-middleware; do
    move_repo "study/java" "$r"
done
# Web / Node / Frontend
for r in nextjs nextjs-blog nextjs-playground nextjs-sandbox mst-antd-kanban mytodo-mvc-mst-antd mst-antd-todo oc-front my-mongodb-api node-rest-api dashboard-bootstrap; do
    move_repo "study/web" "$r"
done

# 5. Infra & Configurações
for r in dotfiles skills nixos; do
    move_repo "infra" "$r"
done

# 6. Documentação / Notas Pessoais
for r in obsidian draw.io vsviniciuslima; do
    move_repo "docs" "$r"
done

# 7. Forks
for r in hello-jdbc InovaTecCPE.github.io ride_tracker my-os-customizations; do
    move_repo "forks" "$r"
done

echo "[+] Organização concluída!"
