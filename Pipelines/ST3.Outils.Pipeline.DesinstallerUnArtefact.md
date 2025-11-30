# ST3.Outils.Pipeline.DesinstallerUnArtefact

## Objectif

Ce pipeline Azure DevOps est conçu pour **désinstaller un artefact** spécifique déployé sur différents environnements (UNIT, INTG, SIMI, SIML, ACCP, FORA). Il supprime également l'artefact du dépôt unitaire si applicable.

## Fonctionnement

Le pipeline principal (`ST3.Outils.Pipeline.DesinstallerUnArtefact.yml`) appelle un template (`ST3.Outils.Pipeline.DesinstallerUnArtefact.Etapes.yml`) qui contient la logique détaillée.

### Étapes principales :

1. **Nettoyage du dépôt unitaire** :
   - Supprime le dossier de l’artefact dans le dépôt `\\fic2\Unit\DevOps_RRQAF\Artefacts` (et éventuellement `\\fic2\De\DevOps_RRQAF\Artefacts` si `UNIT-Dev` est sélectionné).

2. **Désinstallation dans les environnements** :
   - Pour chaque environnement spécifié :
     - Recherche l’artefact correspondant déjà installé.
     - Planifie sa suppression en créant un fichier `.suppression` dans un dossier de retrait (`$ENV:RRQ_APP_DRIVE\Libraire_DevOps\Artefacts\Suppression`).
     - Pour l’environnement PROD, exige un numéro de demande de changement (format `CHGXXXXXXX`).

## Paramètres

| Nom | Description | Type | Obligatoire | Par défaut |
|-----|-------------|------|-------------|------------|
| `nomArtefact` | Nom complet de l'artefact à désinstaller (ex: `FC_Fichier_Inscription_Clientele.Web.20240910.1.Phase6_azure`) | string | Oui | |
| `desinstallationNonPhasable` | Indique si les composants non phasables doivent aussi être désinstallés | boolean | Non | `false` |
| `numeroDemandeChangement` | Numéro de changement requis pour PROD (ex: `CHG1234567`) | string | Non* | "" |

\*Obligatoire uniquement pour l’environnement `PROD`.

## Scripts utilisés

- `ST3.Script.SupprimerUnRepertoire.ps1` :
  - Supprime un dossier spécifique dans un répertoire donné.
- `ST3.Installation.Script.DesinstallerUnArtefact.ps1` :
  - Valide le nom d’artefact.
  - Recherche les fichiers installés correspondants.
  - Crée le fichier de suppression pour traitement futur.
  - Journalise l’exécution.

## Journalisation

Un journal d’exécution est généré dans :

```powershell
$ENV:RRQ_APP_DRIVE\Libraire_DevOps\Artefacts\JournalEvenements
