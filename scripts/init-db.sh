#!/bin/bash

# Script d'initialisation automatique de la base de données (OPTIONNEL)
# 
# NOTE: Ce script n'est PAS utilisé automatiquement dans docker-compose.yml
# MariaDB gère déjà l'import automatique des fichiers .sql dans /docker-entrypoint-initdb.d/
# lors de la première initialisation (quand ./database est vide).
#
# Ce script est fourni à titre éducatif pour comprendre comment faire un import manuel.
# Pour utiliser l'import automatique, placez simplement db.sql dans ./backups/
# et supprimez le dossier ./database avant de démarrer les containers.

set -e

DB_NAME="${MYSQL_DATABASE:-wordpress}"
DB_USER="${MYSQL_USER:-wordpress}"
DB_PASSWORD="${MYSQL_PASSWORD:-wordpress}"

# Attendre que MariaDB soit prêt
until mysqladmin ping -h localhost --silent; do
    echo "En attente de MariaDB..."
    sleep 2
done

# Vérifier si le fichier db.sql existe dans le dossier d'initialisation
if [ -f /docker-entrypoint-initdb.d/db.sql ]; then
    echo "Fichier db.sql trouvé, import automatique..."
    
    # Import de la base de données
    mysql -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < /docker-entrypoint-initdb.d/db.sql
    
    if [ $? -eq 0 ]; then
        echo "✓ Import de db.sql réussi"
    else
        echo "✗ Erreur lors de l'import de db.sql"
    fi
else
    echo "Aucun fichier db.sql trouvé, base de données vide"
fi
