#!/bin/bash

# Script wrapper pour docker-compose down avec export automatique de la base
# Usage: ./scripts/docker-compose-down.sh
#
# Ce script exporte automatiquement la base de données avant d'arrêter les containers

set -e

# Couleurs pour les messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Arrêt des containers avec sauvegarde automatique ===${NC}"
echo ""

# Vérifier si les containers sont en cours d'exécution
if docker ps | grep -q "wordpress-db"; then
    echo "Création d'une sauvegarde automatique avant l'arrêt..."
    ./scripts/backup-db.sh db.sql
    echo ""
fi

# Arrêter les containers
echo "Arrêt des containers..."
docker-compose down

echo ""
echo -e "${GREEN}✓ Containers arrêtés${NC}"
echo -e "${YELLOW}Note: La base de données a été sauvegardée dans ./backups/db.sql${NC}"
