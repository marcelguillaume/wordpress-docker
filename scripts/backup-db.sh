#!/bin/bash

# Script de sauvegarde de la base de données WordPress
# Usage: ./scripts/backup-db.sh [nom_du_fichier]
#
# Ce script crée une sauvegarde SQL de la base de données MariaDB
# et la place dans le dossier ./backups

set -e  # Arrêt en cas d'erreur

# Couleurs pour les messages (optionnel, pour la lisibilité)
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Variables depuis l'environnement (ou valeurs par défaut)
DB_NAME="${DB_NAME:-wordpress}"
DB_USER="${DB_USER:-wordpress}"
DB_PASSWORD="${DB_PASSWORD:-wordpress}"
DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-3306}"

# Dossier des backups
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Nom du fichier de sauvegarde
if [ -z "$1" ]; then
    BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.sql"
else
    BACKUP_FILE="${BACKUP_DIR}/$1"
fi

# Vérification que le dossier backups existe
if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${YELLOW}Création du dossier backups...${NC}"
    mkdir -p "$BACKUP_DIR"
fi

echo -e "${GREEN}=== Sauvegarde de la base de données ===${NC}"
echo "Base de données: $DB_NAME"
echo "Fichier de sortie: $BACKUP_FILE"
echo ""

# Vérification que le container MariaDB est en cours d'exécution
if ! docker ps | grep -q "wordpress-db"; then
    echo -e "${RED}Erreur: Le container wordpress-db n'est pas en cours d'exécution${NC}"
    echo "Démarrez les containers avec: docker-compose up -d"
    exit 1
fi

# Sauvegarde de la base de données
echo "Création de la sauvegarde..."
docker exec wordpress-db mysqldump \
    -u"$DB_USER" \
    -p"$DB_PASSWORD" \
    -h"$DB_HOST" \
    "$DB_NAME" > "$BACKUP_FILE"

# Vérification que la sauvegarde a réussi
if [ $? -eq 0 ] && [ -f "$BACKUP_FILE" ] && [ -s "$BACKUP_FILE" ]; then
    echo -e "${GREEN}✓ Sauvegarde créée avec succès: $BACKUP_FILE${NC}"
    echo "Taille du fichier: $(du -h "$BACKUP_FILE" | cut -f1)"
    
    # Création d'un lien symbolique vers la dernière sauvegarde (optionnel)
    ln -sf "$(basename "$BACKUP_FILE")" "${BACKUP_DIR}/db.sql"
    echo -e "${GREEN}✓ Lien symbolique créé: ${BACKUP_DIR}/db.sql → $(basename "$BACKUP_FILE")${NC}"
else
    echo -e "${RED}✗ Erreur lors de la création de la sauvegarde${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}=== Sauvegarde terminée ===${NC}"
