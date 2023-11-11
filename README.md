# Calculatrice Textuelle en Assembleur 8086

Ce programme en assembleur 8086 implémente une calculatrice textuelle capable d'effectuer des opérations simples (addition, soustraction, multiplication, division) sur des nombres binaires, décimaux et hexadécimaux. Voici une brève description de chaque section du code :

## Structure du Code

Le code est structuré en trois segments principaux : `data`, `stack`, et `code`.

### Segment `data`

- `info`: En-tête du programme avec des informations sur le projet et les développeurs.
- `opd1`, `opt`, `opd2`: Messages d'invite pour l'utilisateur lors de la saisie des opérandes et de l'opération.
- `erreuropt`: Message en cas d'opération incorrecte.
- `merci`: Message de remerciement pour l'utilisation du programme.
- `plus`, `egale`, `produit`, `soustraction`, `division`: Symboles utilisés dans les messages et pour afficher les opérations.
- `saut`: Saut de ligne pour une meilleure présentation.
- `Bstring`, `Dstring`, `Hstring`: Tableaux pour stocker les opérandes en binaire, décimal et hexadécimal respectivement.
- `msg`, `base`, `erreur`, `quitter`: Messages relatifs à la sélection de la base de calcul.
- `bs`, `opr`, `num1`, `num2`, `result`: Variables pour stocker la base, l'opération, les opérandes et les résultats.

### Segment `stack`

Empilement utilisé pour stocker des données temporaires lors de l'exécution.

### Segment `code`

- `start`: Point d'entrée du programme.
- `recalcul`: Boucle principale pour la saisie des opérandes, de la base et de l'opération.
- `BINAIRE`, `DECIMAL`, `HEXADECIMAL`: Sections pour traiter les opérations dans différentes bases.
- `StringToBinary`, `StringToDecimal`, `StringToHexa`: Fonctions pour convertir les chaînes de caractères en nombres binaires, décimaux et hexadécimaux respectivement.
- `PrintBinary`, `outputdecimal`, `AffHexa`: Fonctions pour afficher les résultats dans différentes bases.
- `sauter`, `additionproc`, `egaleproc`: Fonctions pour afficher des sauts de ligne et des symboles spécifiques.
- `lireBinaire`, `lireDecimal`, `lireHexa`: Fonctions pour lire les opérandes dans différentes bases depuis l'entrée utilisateur.

## Utilisation

Le programme invite l'utilisateur à entrer la base de calcul (binaire, décimal, hexadécimal), les opérandes et l'opération souhaitée. Les résultats sont ensuite affichés dans la base sélectionnée. L'utilisateur peut choisir de quitter le programme ou de recalculer.

## Instructions d'exécution

Assurez-vous d'avoir un environnement de développement compatible avec l'assembleur 8086 pour exécuter ce programme.




## Preview

<img width="543" alt="image" src="https://github.com/Zvki1/textual-calculator-with-assembly-8086/assets/98493579/a469d1b0-3147-42cf-9522-36d1e73d03ff">
