# Résumé du pipeline d'extraction du contenu d'un serveur

## Objectif
Ce pipeline permet d'extraire le contenu installé sur un serveur en répertoriant les artefacts présents dans un répertoire spécifique (`C:\RRQ\Libraire_DevOps\Artefacts\Installes\`). Le pipeline s'exécute sur plusieurs environnements, avec des étapes similaires pour chaque phase.

## Variables
- `scriptConsulterInstallation`: Ce script PowerShell répertorie les artefacts installés sur le serveur. S'il n'y a aucun artefact, un message est affiché. Sinon, le script liste chaque artefact et affiche sa date de dernière modification.

## Environnements et stages
Le pipeline est organisé en plusieurs **stages** qui correspondent à différents environnements de déploiement. Chaque stage exécute le même script PowerShell via une tâche intégrée.

### 1. Stage : Unitaire (UNIT)
- **Environnement** : VirtualMachine `UNIT`
- **Script PowerShell** : Exécute le script `scriptConsulterInstallation` pour répertorier les artefacts installés sur l'environnement unitaire.

### 2. Stage : Intégration (INTG)
- **Environnement** : VirtualMachine `INTG`
- **Script PowerShell** : Répertorie les artefacts installés dans l'environnement d'intégration.

### 3. Stage : Simulation Intégration (SIMI)
- **Environnement** : VirtualMachine `SIMI`
- **Script PowerShell** : Exécute le même script pour répertorier les artefacts dans l'environnement de simulation d'intégration.

### 4. Stage : Acceptation (ACCP)
- **Environnement** : VirtualMachine `ACCP`
- **Script PowerShell** : Liste les artefacts dans l'environnement d'acceptation.

### 5. Stage : Formation Acceptation (FORA)
- **Environnement** : VirtualMachine `FORA`
- **Script PowerShell** : Exécute le script dans l'environnement de formation acceptation.

### 6. Stage : Simulation (SIML)
- **Environnement** : VirtualMachine `SIML`
- **Script PowerShell** : Répertorie les artefacts dans l'environnement de simulation.

### 7. Stage : Production (PROD)
- **Environnement** : VirtualMachine `PROD`
- **Script PowerShell** : Répertorie les artefacts installés dans l'environnement de production.

## Tâches principales
- Chaque stage comporte une tâche **PowerShell@2** qui exécute un script inline correspondant à la variable `scriptConsulterInstallation`.
- **Gestion des erreurs** : Si une erreur survient, elle est silencieusement ignorée grâce à l'option `errorActionPreference: SilentlyContinue`.

## Conclusion
Ce pipeline assure une extraction automatique des fichiers installés sur le serveur pour chaque environnement de déploiement. Il suit un schéma uniforme, en exécutant le même script PowerShell pour extraire les informations nécessaires à travers différents environnements.
