## LP1 - Atelier 2 : Reunionou
**Membres du groupe :**
- PORTARO Lucas
- OZKOK Ozan
- KLOPFENSTEIN Vivien
- CARON Ludovic
- GEHIN Evann

**Lien vers le tableau de bord (Trello)** : https://trello.com/b/Jtmemqjq/reunionou
**Lien vers la documentation de l'API** : https://docs.google.com/document/d/1LGxsNmQHiaLLNxwVOCVfdUchWJgL3k6i5r-HZRcD1Sw/edit?usp=sharing

## Installation générale du projet

**Prérequis** :

- Git
- Docker (docker-compose)
- NodeJS (npm)

**Installation** :

Clonage du projet :

    https://git.ezcorp.io/lp-ciasie/reunionou.git

Lancement des containers Docker :

    cd reunionou
    docker-compose up -d

Import de la base de données MySQL :

- Se rendre sur http://localhost:19780
- Identifiants : com:com
- Importer le fichier SQL se trouvant ici : ./reunionou/BDD/com.sql

Voir le readme correspondant pour l'installation de chaque application.