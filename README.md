# Template Docker WordPress

Template Docker complet pour faire tourner WordPress avec PHP 8.4, Nginx, MariaDB et PhpMyAdmin, **sans utiliser l'image officielle WordPress**.

## 📋 Prérequis

- Docker et Docker Compose installés sur votre machine
- Git (optionnel)
- Compatible Mac, Linux et WSL

## 🚀 Installation

### 1. Cloner ou télécharger le projet

```bash
git clone <url-du-repo>
cd wordpress-docker
```

### 2. Créer le fichier `.env`

```bash
cp .env.example .env
```

Modifiez les valeurs dans `.env` si nécessaire (mots de passe, ports, etc.).

### 3. Créer les dossiers nécessaires

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
├── wordpress/              # Fichiers WordPress (vide au départ)
├── database/               # Données MariaDB persistées (bind mount)
└── backups/                # Dossier pour l'import automatique de db.sql
    └── db.sql              # Import automatique au premier démarrage (si présent)
```

## 🌐 Accès aux services

Une fois les containers démarrés, vous pouvez accéder aux services suivants :

| Service | URL | Description |
|---------|-----|-------------|
| **WordPress** | http://localhost:8080 | Site WordPress principal |
| **PhpMyAdmin** | http://localhost:8081 | Interface d'administration de la base de données |
| **MariaDB** | localhost:3306 | Base de données (accès direct) |

**Note :** Les ports peuvent être modifiés dans le fichier `.env`.

## 📦 Installation de WordPress

Le dossier `./wordpress` est vide au départ. Vous devez installer WordPress manuellement :

### Option 1 : Installation manuelle via le navigateur

1. Accédez à http://localhost:8080
2. Suivez l'assistant d'installation WordPress
3. Utilisez les identifiants de la base de données depuis votre fichier `.env`

### Option 2 : Installation via WP-CLI (recommandé)

```bash
# Entrer dans le container PHP
docker exec -it wordpress-php bash

# Télécharger WordPress dans le dossier /var/www/html
wp core download --locale=fr_FR

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

### Import automatique au démarrage (optionnel)

Si le fichier `./backups/db.sql` existe, il sera automatiquement importé lors du **premier démarrage** du container MariaDB (quand `./database` est vide).

**Cas d'usage :** Utile pour initialiser une nouvelle installation avec des données pré-configurées.

**Important :** L'import automatique ne fonctionne que si le dossier `./database` est vide (première initialisation). Si vous avez déjà une base de données existante dans `./database`, elle sera utilisée directement (pas d'import).

Pour forcer un import depuis `db.sql` :
1. Supprimer le dossier `./database` (⚠️ cela supprime toutes les données)
2. Placer votre fichier `db.sql` dans `./backups/`
3. Redémarrer les containers : `docker-compose up -d`

L'import se fera automatiquement lors de la réinitialisation de la base.

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

**Import initial :** Le dossier `./backups` permet d'importer automatiquement un fichier `db.sql` lors du premier démarrage (si `./database` est vide).

## 🔐 Sécurité

⚠️ **Important pour la production :**

1. Modifiez tous les mots de passe par défaut dans `.env`
2. Ne commitez JAMAIS le fichier `.env` dans Git
3. Utilisez des mots de passe forts
4. Configurez un certificat SSL pour HTTPS
5. Limitez l'accès aux ports exposés (firewall)

## 🐛 Dépannage

### Les containers ne démarrent pas

```bash
# Vérifier les logs
docker-compose logs

# Vérifier que les ports ne sont pas déjà utilisés
lsof -i :8080
lsof -i :8081
lsof -i :3306
```

### Erreur de permissions sur les fichiers

Sur Linux/WSL, vous pouvez avoir besoin d'ajuster les permissions :

```bash
sudo chown -R $USER:$USER wordpress database backups
```

**Note :** Le dossier `backups` n'est utilisé que pour l'import automatique de `db.sql` au premier démarrage.

### La base de données ne se connecte pas

1. Vérifiez que le container `db` est démarré : `docker ps`
2. Vérifiez les variables dans `.env`
3. Vérifiez les logs : `docker-compose logs db`

### WordPress ne se charge pas

1. Vérifiez que le dossier `wordpress` contient les fichiers WordPress
2. Vérifiez les logs Nginx : `docker-compose logs nginx`
3. Vérifiez les logs PHP : `docker-compose logs php`

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
