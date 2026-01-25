# 🚀 Guide de démarrage rapide

Ce guide vous permet de démarrer rapidement avec le template WordPress Docker.

## ⚡ Démarrage en 3 étapes

### 1. Configuration initiale

```bash
# Copier le fichier d'environnement
cp .env.example .env

# (Optionnel) Modifier les mots de passe dans .env
```

### 2. Démarrer les containers

```bash
# Construire et démarrer tous les services
docker-compose up -d

# Vérifier que tout fonctionne
docker-compose ps
```

### 3. Installer WordPress

**Option A : Via le navigateur**

1. Ouvrir http://localhost:8080
2. Suivre l'assistant d'installation
3. Utiliser les identifiants depuis `.env`

**Option B : Via WP-CLI (recommandé)**

```bash
# Entrer dans le container PHP
docker exec -it wordpress-php bash

# Télécharger WordPress
wp core download --locale=fr_FR

# Configurer la base de données
wp config create \
    --dbname=wordpress \
    --dbuser=wordpress \
    --dbpass=wordpress \
    --dbhost=db \
    --locale=fr_FR

# Installer WordPress
wp core install \
    --url=http://localhost:8080 \
    --title="Mon Site" \
    --admin_user=admin \
    --admin_password=admin \
    --admin_email=admin@example.com
```


## 📍 Accès aux services

| Service | URL | Identifiants |
|---------|-----|--------------|
| WordPress | http://localhost:8080 | (créés lors de l'installation) |
| PhpMyAdmin | http://localhost:8081 | user: `wordpress` / pass: `wordpress` |
| MariaDB | localhost:3306 | user: `wordpress` / pass: `wordpress` |

## 🔧 Commandes essentielles

```bash
# Démarrer
docker-compose up -d

# Arrêter (les données sont automatiquement persistées dans ./database)
docker-compose down

# Voir les logs
docker-compose logs -f

# Utiliser WP-CLI
docker exec -it wordpress-php wp plugin list
```

**Note :** Les données sont automatiquement persistées dans `./database`. Aucun script nécessaire - la persistance est automatique.

## 📚 Documentation complète

Consultez le [README.md](README.md) pour la documentation détaillée.
