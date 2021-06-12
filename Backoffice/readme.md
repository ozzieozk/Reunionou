## Installation de la WebApp

Nous considérons que vos containers Docker sont déjà lancés et que la base de données est bien importée.

**Prérequis** :

- Voir le readme principal

## Accéder au container du backoffice

Prendre connaissance de l'ID du container :

    docker ps -a

Connexion au container à l'aide de son ID (reunionou_back2_1) :

    docker exec -it <CONTAINER_ID> bash

Installation des librairies nécessaires au fonctionnement du backoffice :

    composer install

Le backoffice est désormais disponible à cette adresse : http://backoffice.local:19180/

**Identifiants** :

Adresse email : admin@local.dev
Mot de passe : admin