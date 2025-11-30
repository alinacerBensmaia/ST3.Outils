
# Pipeline `ST3.Outils.Pipeline.TraiterDepotCompilation.yml`

## 📌 Objectif

Ce pipeline permet de **mettre à jour automatiquement le dépôt réseau `Compilation\Exec`** en trois grandes étapes :
1. Réplication du dépôt d’artefacts réseau vers un dépôt local.
2. Traitement des artefacts pour générer un dépôt compilation local (extraction des exécutables).
3. Réplication du dépôt compilation local vers le dépôt réseau final.

---

## 🔄 Déclenchement

```yaml
trigger: none
```

Aucune exécution automatique à chaque commit.

### 🔁 Exécution planifiée (cron)

- **Tous les mardis à 05h00 (heure locale, UTC-4)** sur la branche `master` :
```yaml
schedules:
  - cron: "0 9 * * 2"
```

---

## 📥 Paramètres

| Nom                        | Description                                               | Par défaut                                                |
|---------------------------|-----------------------------------------------------------|------------------------------------------------------------|
| `repDepotsArtefacts`      | Chemin local vers le dépôt des artefacts                 | `D:\DepotArtefacts`                                        |
| `repDepotsArtefactsReseau`| Chemin réseau du dépôt des artefacts                     | `\\fic2\Unit\DevOps_RRQAF\Artefacts`                   |
| `repDepotCompilationLocal`| Chemin local du dépôt compilation                        | `D:\DepotBuild\Compilation\Exec`                         |
| `repReseauDepotCompilation`| Chemin réseau du dépôt compilation                      | `\\fic2\Unit\DevOps_RRQAF\Compilation\Exec`           |
| `majSeulement`            | Ne copier que les fichiers nouveaux ou modifiés ?         | `Non`                                                      |

---

## 🏗️ Pool utilisé

```yaml
pool:
  name: Compilation RRQ-AF
```

---

## 🧩 Stages

### 1. `Replication_ReseauVersLocal`
**But :** Copier les artefacts du dépôt réseau vers un dépôt local, sauf si un traitement précédent est encore en cours (`GenerationEnCoursCompilation.txt`).

- Utilise le script PowerShell :
  ```
  Pipelines\ST3.Outils.Script.Repliquer.DepotFichiers.ps1
  ```

### 2. `TraiterDepotCompilation`
**But :** Traiter les artefacts localement pour construire le dépôt compilation (DLL/EXE triés par manifestes).

- Utilise le script PowerShell :
  ```
  Deploiement\V2\Script\ST3.Script.TraiterDepotCompilation.ps1
  ```

- Retourne une variable de sortie :
  ```yaml
  etapeAlimenterDepotCompilationSucces
  ```

### 3. `Replication_VersDepotReseau`
**But :** Répliquer le dépôt compilation local vers le dépôt réseau **si** l’étape précédente a réussi.

- Affiche un message d'erreur si la variable `etapeAlimenterDepotCompilationSucces` est différente de `Oui`.
- Réplication avec le même script que l'étape 1.

---

## 📎 Fichiers dépendants

- `ST3.Outils.Script.Repliquer.DepotFichiers.ps1`  
  Permet de faire la réplication conditionnelle via Robocopy.
- `ST3.Script.TraiterDepotCompilation.ps1`  
  Alimente le dépôt compilation à partir des artefacts.

---

## 🧪 Résilience

- `continueOnError: true` est utilisé pour **permettre le diagnostic** même si certaines étapes échouent.
- La variable `etapeAlimenterDepotCompilationSucces` permet une **vérification explicite** avant la dernière réplication.

---

## 🧼 Bonnes pratiques

- Assurez-vous que le fichier `GenerationEnCoursCompilation.txt` est bien supprimé à la fin des traitements.
- Exécuter manuellement le pipeline si un ajustement temporaire est requis (ex. : `majSeulement: Oui`).
