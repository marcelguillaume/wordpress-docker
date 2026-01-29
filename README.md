# Template Docker WordPress

Template Docker complet pour faire tourner WordPress avec PHP 8.4, Nginx, MariaDB et PhpMyAdmin, **sans utiliser l'image officielle WordPress**.

## 📋 Prérequis

- Docker et Docker Compose installés sur votre machine
- Git (optionnel)
- Compatible Mac, Linux et WSL

## 🚀 Installation

### 1. Cloner ou télécharger le projet

```bash
git clone https://github.com/marcelguillaume/wordpress-docker
cd wordpress-docker
```

### 2. Créer le fichier `.env`

```bash
cp .env.example .env
```

Modifiez les valeurs dans `.env` si nécessaire (mots de passe, ports, etc.).

### 3. Créer les dossiers si nécessaires

```bash
mkdir -p wordpress database backups nginx
```

### 4. Construire et démarrer les containers

```bash
docker-compose build
docker-compose up -d
```

Les containers vont démarrer automatiquement. La première fois, cela peut prendre quelques minutes pour télécharger les images et construire le container PHP.

## 📁 Structure du projet

```
wordpress-docker/
├── docker-compose.yml      # Configuration Docker Compose
├── Dockerfile              # Image PHP 8.4 avec extensions WordPress
├── .env.example            # Exemple de variables d'environnement
├── .gitignore              # Fichiers à ignorer dans Git
├── README.md               # Ce fichier
├── nginx/
│   └── default.conf        # Configuration Nginx
├── wordpress/              # Fichiers WordPress 
├── database/               # Données MariaDB persistées (bind mount)

## 🌐 Accès aux services

Une fois les containers démarrés, vous pouvez accéder aux services suivants :

| Service | URL | Description |
|---------|-----|-------------|
| **WordPress** | http://localhost:8080 | Site WordPress principal |
| **PhpMyAdmin** | http://localhost:8081 | Interface d'administration de la base de données |
| **MariaDB** | localhost:3306 | Base de données (accès direct) |

**Note :** Les ports peuvent être modifiés dans le fichier `.env`.

## 📦 Installation de WordPress

Vous devez installer WordPress manuellement :

### Option 1 : Installation manuelle via le navigateur

1. Accédez à http://localhost:8080
2. Suivez l'assistant d'installation WordPress
3. Utilisez les identifiants de la base de données depuis votre fichier `.env`

### Option 2 : Installation via WP-CLI (recommandé)

```bash
# Entrer dans le container PHP
docker exec -it wordpress-php bash

# Créer le fichier wp-config.php
wp config create \
    --dbname=wordpress \
    --dbuser=wordpress \
    --dbpass=wordpress \
    --dbhost=db \
    --locale=fr_FR

# Installer WordPress
wp core install \
    --url=http://localhost:8080 \
    --title="Mon Site WordPress" \
    --admin_user=admin \
    --admin_password=admin \
    --admin_email=admin@example.com
```

## 🛠️ Commandes WP-CLI utiles

WP-CLI est installé dans le container PHP. Voici quelques commandes utiles :

```bash
# Entrer dans le container PHP
docker exec -it wordpress-php bash

# Une fois dans le container, vous pouvez utiliser wp-cli :
wp --info                    # Informations sur WP-CLI
wp plugin list               # Lister les plugins
wp plugin install <plugin>   # Installer un plugin
wp theme list                # Lister les thèmes
wp theme install <theme>     # Installer un thème
wp user list                 # Lister les utilisateurs
wp db export                 # Exporter la base de données
```

**Astuce :** Vous pouvez aussi exécuter WP-CLI directement depuis votre machine :

```bash
docker exec -it wordpress-php wp --info
docker exec -it wordpress-php wp plugin list
```

## 💾 Persistance de la base de données

**Important :** Les données de la base de données sont **automatiquement persistées** dans le dossier `./database` grâce au bind mount. 

- ✅ Quand vous arrêtez les containers avec `docker-compose down`, les données restent dans `./database`
- ✅ Au prochain démarrage, les données sont automatiquement restaurées
- ✅ **Aucun script nécessaire** - la persistance est automatique

Le dossier `./database` contient tous les fichiers de MariaDB directement sur votre disque local.

## 🔧 Commandes Docker utiles

```bash
# Démarrer les containers
docker-compose up -d

# Arrêter les containers (les données sont automatiquement persistées dans ./database)
docker-compose down

# Voir les logs
docker-compose logs -f

# Voir les logs d'un service spécifique
docker-compose logs -f php
docker-compose logs -f nginx
docker-compose logs -f db

# Reconstruire les containers (après modification du Dockerfile)
docker-compose build --no-cache
docker-compose up -d

# Accéder au shell d'un container
docker exec -it wordpress-php bash
docker exec -it wordpress-db bash
docker exec -it wordpress-nginx sh

# Redémarrer un service spécifique
docker-compose restart php
```

## 📝 Modification des fichiers

Tous les fichiers WordPress dans `./wordpress` sont directement modifiables depuis votre IDE local. Les changements sont immédiatement visibles dans le container grâce aux bind mounts.

**Exemple :**
- Modifiez `./wordpress/wp-config.php` depuis VS Code → changements immédiatement visibles
- Ajoutez un thème dans `./wordpress/wp-content/themes/` → disponible immédiatement

## 💾 Persistance des données

**Base de données :** Les données MariaDB sont automatiquement persistées dans `./database`. Aucun script nécessaire - la persistance est automatique via le bind mount.

**WordPress :** Les fichiers WordPress dans `./wordpress` sont directement sur votre disque local, donc toujours persistés.


## 📚 Ressources

- [Documentation WordPress](https://wordpress.org/support/)
- [Documentation WP-CLI](https://wp-cli.org/)
- [Documentation Docker](https://docs.docker.com/)
- [Documentation Docker Compose](https://docs.docker.com/compose/)

## 📄 Licence

Ce template est fourni à des fins éducatives. Adaptez-le selon vos besoins.

## 🤝 Contribution

Ce projet est destiné à des étudiants. N'hésitez pas à améliorer la documentation selon vos besoins.

---

**Bon développement ! 🚀**


## Problème avec les règles de droit

docker exec -it wordpress-php bash

chown -R www-data:www-data /var/www/html
find /var/www/html/wp-content -type d -exec chmod 755 {} \;
find /var/www/html/wp-content -type f -exec chmod 644 {} \;