param (
    [Parameter()]        
    [string]$cheminSource= "", 
    [string]$cheminDestination = "",                  
    [string]$fichierValidation = "",
    [string]$majSeulement = "Non"
)

Write-Host "Valeur des parametres:"
Write-Host "  Chemin source      : $cheminSource"
Write-Host "  Chemin destination : $cheminDestination"
Write-Host "  Fichier de validation : $fichierValidation"
Write-Host "  Mise à jour seulement : $majSeulement"
Write-Host ""

# Vérifier que le fichier de validation n'est pas présent, il indique si le traitement précédent a bien fonctionné
if (-not [string]::IsNullOrEmpty($fichierValidation)) {

    $cheminValidationComplet = Join-Path -Path $cheminSource -ChildPath $fichierValidation

    if (Test-Path $cheminValidationComplet){
        Write-Host ""
        Write-Host "⚠️  AVERTISSEMENT: Traitement annulé, le fichier de validation est encore présent : $cheminValidationComplet"
        Write-Host ""
        exit 0
    }
}

# Vérifier si le répertoire source existe
if (Test-Path -Path $cheminSource -PathType Container) {

    if ($cheminDestination -ne $cheminSource) {
        Write-Host "🔄 Source : $cheminSource -> Destination : $cheminDestination"
        
        # Déterminer l'option de synchronisation
        if ($majSeulement -ieq 'Oui') {
            Write-Host " Mode mise à jour uniquement sélectionné (ajout des fichiers, sans suppression des fichiers obsolètes)"
            $optionRobocopy = "/E"
        } else {
            Write-Host " Mode synchronisation complète sélectionné (suppression des fichiers obsolètes)"
            $optionRobocopy = "/MIR"
        }

        # Construire la commande Robocopy avec l'option choisie
        $commandeRobocopy = "robocopy `"$cheminSource`" `"$cheminDestination`" $optionRobocopy /R:0 /W:0 /NP"

        Write-Host "📌 Commande exécutée : $commandeRobocopy"

        # Exécuter la commande Robocopy
        Invoke-Expression $commandeRobocopy

        Write-Host "✅ Synchronisation terminée"
        
    } else {
        Write-Host "❌ ERREUR: Chemin source et destination identiques !"
        throw "Erreur"
    }
}
else {
    # Le répertoire source n'existe pas, afficher un message d'erreur
    Write-Host "❌ Répertoire source non trouvé : $cheminSource"
}
exit 0
