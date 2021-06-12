## Installation de la WebApp

Nous considérons que vos containers Docker sont déjà lancés et que la base de données est bien importée.

**Prérequis** :

- Voir le readme principal

## Installation de la WebApp

Installation des différentes librairies nécessaires au fonctionnement de l'application :

    npm install

Lancement de l'application en mode développement (pas de serveur web requis) :

    npm run serve
    
L'application est disponible à cette URL : http://localhost:8080

Build de l'application pour mise en production (serveur web requis par la suite) :

    npm run build

Une fois l'application build, il est nécessaire de faie pointer le serveur web vers le répertoire "./dist".

**Identifiants** :

Adresse email : john@local.dev
Mot de passe : admin
