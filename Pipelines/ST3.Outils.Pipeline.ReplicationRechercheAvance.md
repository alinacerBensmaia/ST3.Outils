# Résumé du pipeline de réplication vers le dépôt de recherche avancée

## Objectif
Ce pipeline est conçu pour répliquer une branche vers un dépôt de recherche avancée. Il prend un paramètre nommé `nomRepos` pour spécifier le dépôt à répliquer et utilise des commandes PowerShell pour gérer la réplication des fichiers et le nettoyage des anciens fichiers.

## Paramètres
- `nomRepos`: Ce paramètre est obligatoire et définit le nom du dépôt à répliquer. Par défaut, il est vide.

## Étapes principales
### 1. Réplication vers le dépôt de recherche avancée
- **Stage**: ReplicationRechercheAvancee
  - **Job**: Replication
    - Utilisation des variables provenant du groupe `GrST3.Deploiement`.
    - Le pool d'agents utilisé est `Compilation RRQ-AF`.
    - Le pipeline commence par afficher les variables d'environnement avec une commande PowerShell (`get-childitem -path env:*`).

### 2. Vérification du paramètre `nomRepos`
- Le script vérifie que le paramètre `nomRepos` est bien défini. Si ce n'est pas le cas, une erreur est générée et le pipeline est arrêté.

### 3. Définition de la destination
- Si la branche source est `master`, les fichiers sont répliqués vers le répertoire `Master`.
- Pour les branches de développement (autres que `master`), les fichiers sont répliqués vers le répertoire `Dev`. Un nettoyage est effectué pour supprimer les dossiers plus anciens que 60 jours dans le répertoire de destination.

### 4. Réplication des fichiers avec Robocopy
- La commande **Robocopy** est utilisée pour copier les fichiers du répertoire source vers la destination.
- Les options de Robocopy incluent `/MIR` pour la synchronisation miroir, ainsi que des options de copie des données et des attributs.
- En cas d'échec de la commande, une erreur est affichée et le pipeline est interrompu.

## Gestion des erreurs
- Le pipeline utilise un bloc `try/catch` pour capturer les erreurs lors de la réplication avec Robocopy et les gérer de manière appropriée.
- Si une erreur survient pendant l'exécution du script, elle est consignée et le pipeline est arrêté.

## Nettoyage des anciens fichiers
- Pour les branches de développement, un processus de ménage est inclus pour supprimer les fichiers plus anciens que 60 jours dans le répertoire de destination.

## Résumé des opérations
- Le script affiche les informations suivantes :
  - Le nom du dépôt (`nomRepos`).
  - Le répertoire source.
  - Le répertoire de destination.
