#!/bin/bash

# Script de restauration de la base de données WordPress
# Usage: ./scripts/restore-db.sh [fichier.sql]
#
# Ce script restaure une sauvegarde SQL dans la base de données MariaDB
# Si aucun fichier n'est spécifié, utilise ./backups/db.sql par défaut

set -e  # Arrêt en cas d'erreur

# Couleurs pour les messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Variables depuis l'environnement (ou valeurs par défaut)
DB_NAME="${DB_NAME:-wordpress}"
DB_USER="${DB_USER:-wordpress}"
DB_PASSWORD="${DB_PASSWORD:-wordpress}"
DB_ROOT_PASSWORD="${DB_ROOT_PASSWORD:-rootpassword}"
DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-3306}"

# Fichier SQL à restaurer
if [ -z "$1" ]; then
    SQL_FILE="./backups/db.sql"
else
    SQL_FILE="$1"
fi

# Vérification que le fichier existe
if [ ! -f "$SQL_FILE" ]; then
    echo -e "${RED}Erreur: Le fichier $SQL_FILE n'existe pas${NC}"
    echo "Usage: ./scripts/restore-db.sh [fichier.sql]"
    exit 1
fi

echo -e "${GREEN}=== Restauration de la base de données ===${NC}"
echo "Base de données: $DB_NAME"
echo "Fichier source: $SQL_FILE"
echo ""

# Vérification que le container MariaDB est en cours d'exécution
if ! docker ps | grep -q "wordpress-db"; then
    echo -e "${RED}Erreur: Le container wordpress-db n'est pas en cours d'exécution${NC}"
    echo "Démarrez les containers avec: docker-compose up -d"
    exit 1
fi

# Confirmation de l'utilisateur (sécurité)
echo -e "${YELLOW}ATTENTION: Cette opération va écraser toutes les données actuelles de la base de données !${NC}"
read -p "Voulez-vous continuer ? (oui/non): " confirm

if [ "$confirm" != "oui" ] && [ "$confirm" != "o" ] && [ "$confirm" != "yes" ] && [ "$confirm" != "y" ]; then
    echo "Opération annulée."
    exit 0
fi

# Suppression de la base de données existante et recréation
echo "Suppression de l'ancienne base de données..."
docker exec wordpress-db mysql \
    -uroot \
    -p"$DB_ROOT_PASSWORD" \
    -e "DROP DATABASE IF EXISTS $DB_NAME; CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Restauration de la sauvegarde
echo "Restauration de la sauvegarde..."
docker exec -i wordpress-db mysql \
    -u"$DB_USER" \
    -p"$DB_PASSWORD" \
    -h"$DB_HOST" \
    "$DB_NAME" < "$SQL_FILE"

# Vérification que la restauration a réussi
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Base de données restaurée avec succès${NC}"
    
    # Affichage du nombre de tables restaurées
    TABLE_COUNT=$(docker exec wordpress-db mysql \
        -u"$DB_USER" \
        -p"$DB_PASSWORD" \
        -h"$DB_HOST" \
        -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$DB_NAME';" \
        -s -N 2>/dev/null || echo "0")
    
    echo "Nombre de tables dans la base: $TABLE_COUNT"
else
    echo -e "${RED}✗ Erreur lors de la restauration${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}=== Restauration terminée ===${NC}"
echo -e "${YELLOW}Note: Vous devrez peut-être redémarrer les containers pour que WordPress prenne en compte les changements${NC}"
