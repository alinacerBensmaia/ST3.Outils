# Résumé du pipeline Azure DevOps ST3.Outils.Pipeline.PreparerRepertoirePosteDeveloppeur.yml


## Objectif
Ce pipeline effectue les tâches suivantes :
1. Réplication des artefacts depuis le dépôt réseau vers le serveur local.
2. Préparation du répertoire pour l'outil de mise à jour du poste développeur.
3. Réplication des fichiers préparés vers un dépôt réseau pour les développeurs.

## Déclencheur
- Aucune exécution automatique (trigger: none).
- Planification d'exécution toutes les 30 minutes entre 5h et 21h UTC (schedules: cron).
- MAJ complète lors de la première exécution le matin entre 6h et 6h15
- MAJ seulement des artefacts ajoutés lors des autres exécutions le reste de la journée.

## Ressources
- Le pipeline utilise un dépôt Git nommé `ST3.Outils.DevOps`, branché sur `master`.

## Paramètres
- `FORCER`: Ce paramètre détermine si une mise à jour complète doit être faite. Valeurs possibles :
  - Oui
  - Non (valeur par défaut).

## Variables
Les chemins des répertoires et d'autres variables sont définis au début du pipeline :
- `repReseauArtefacts`: \\fic2\Unit\DevOps_RRQAF\Artefacts
- `repLocalArtefacts`: D:\DepotArtefacts
- `repLocalPrepPosteDev`: D:\PrepPosteDev
- `repReseauPrepPosteDev`: \\fic2\Unit\DevOps_RRQAF\PrepPosteDev
- `heureActuelle`: Récupération de l'heure au démarrage du pipeline.

## Étapes principales
### 1. Réplication des artefacts vers le serveur
- Stage: **ReplicationArtefactVersSurPosteDev**
  - Job: **ReplicationArtefactVersSurPosteDev**
  - Script PowerShell : Réplication des artefacts réseau vers le dépôt local des artefacts.

### 2. Préparation du répertoire pour le poste développeur
- Stage: **PreparerRepertoiresPosteDeveloppeur**
  - Job: **PreparerRepertoiresPosteDeveloppeur**
  - Récupération de l'heure actuelle et condition pour la mise à jour complète selon le paramètre `FORCER`.
  - Exécution d'un script PowerShell pour préparer les répertoires en fonction des artefacts récupérés.

### 3. Réplication des fichiers préparés vers le réseau
- Stage: **Replication_PrepPosteDev**
  - Job: **Replication_PrepPosteDev_Vers_Reseau**
  - Script PowerShell : Réplication des fichiers préparés sur le dépôt réseau, avec vérification d'un fichier de validation "GenerationEnCours.txt". Le fichier "GenerationEnCours.txt" permet de savoir si un traitement est déja en cours.
    

## Pool d'agents
- Utilisation du pool d'agents `Compilation RRQ-AF` pour l'exécution des jobs.

## Gestion des erreurs
- Les étapes critiques sont configurées avec `continueOnError: true` pour assurer la continuité du pipeline même en cas d'erreurs.

