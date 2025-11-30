<#
.SYNOPSIS
    Supprime un dossier spécifique d’un répertoire cible, si celui-ci existe.

.DESCRIPTION
    Ce script prend en paramètre le nom d’un dossier et le chemin d’un répertoire cible.
    Il vérifie si le dossier existe dans le répertoire donné, et le supprime s’il est présent.
    Des messages sont affichés à chaque étape pour informer Azure DevOps.

.PARAMETER NomDossier
    Le nom du dossier à rechercher et éventuellement supprimer.

.PARAMETER RepertoireCible
    Le chemin complet du répertoire où le dossier doit être recherché.

.EXAMPLE
    .\RetirerArtefact.ps1 -NomDossier "Build123" -RepertoireCible "C:\Deploy\Temp"
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$NomDossier,

    [Parameter(Mandatory = $true)]
    [string]$RepertoireCible
)

# Vérification du répertoire cible
if (-not (Test-Path -Path $RepertoireCible -PathType Container)) {
    Write-Host "##vso[task.logissue type=error] Le répertoire cible '$RepertoireCible' n'existe pas ou est inaccessible."
    exit 1
}

# Message informatif
Write-Host "Recherche du dossier '$NomDossier' dans '$RepertoireCible'..."

# Suppression si trouvé
$cheminDossier = Join-Path -Path $RepertoireCible -ChildPath $NomDossier

if (Test-Path -Path $cheminDossier -PathType Container) {
    Write-Host "Le dossier '$cheminDossier' existe. Tentative de suppression..."
    try {
        Remove-Item -Path $cheminDossier -Recurse -Force        
        Write-Host "Dossier supprimé avec succes : '$cheminDossier'"
    }
    catch {
        Write-Host "##vso[task.logissue type=error] ERREUR lors de la suppression du dossier : $_"
        exit 1
    }
} else {
    Write-Host "##vso[task.logissue type=warning] Le dossier '$NomDossier' n'existe pas dans '$RepertoireCible'. Aucun repertoire a supprimer."
}
