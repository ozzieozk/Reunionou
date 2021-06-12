## Installation de l'API

Nous considérons que vos containers Docker sont déjà lancés et que la base de données est bien importée.

**Prérequis** :

- Voir le readme principal
- Ajout du domaine "api.local" dans son fichier "hosts"

## Accéder au container de l'API

Prendre connaissance de l'ID du container :

    docker ps -a


Connexion au container à l'aide de son ID (reunionou_back1_1) :

    docker exec -it <CONTAINER_ID> bash

Installation des librairies nécessaires au fonctionnement de l'API :

    composer install

L'API est désormais disponible à cette adresse : http://api.local:19080/