En tant que: Responsable des outils de soutien aux développement

Je souhaite: Qu'un nouveau template de validation periodique soit développé

But: Valider de façon périodique de la sécurité des différents Repos 

Détails:
Premièrement, créer un nouveau dossier "Securite" dans ST3.OutilsDevOps. Celui-ci va contenir les nouveaux éléments 
Un nouveau template Extends qui va contenir le pipeline de validation périodique du Repos : ST3.Securite.Extends.ScanPeriodique.yml
Un nouveau template ST3.Securite.ScanGHAST qui est un template régulier qui va contenir les étapes de scan pour GHAST
Un nouveau template ST3.Securite.ScanDevSkim qui est un template régulier qui contient les étapes pour lancer le scan pour DevSkim

Voici un exemple de Scan pour GHAST
XU_AnalysePeriodique.yml - Repos

Le extended pipeline devra lancer la compilation de toutes les solutions du Repos
Appeler le template ST3.Securite.Extends.ScanGHAST
Lancer le scan avec GHAS comme indiqué dans XU_AnalysePeriodique.yml - Repos
Lancer le scan avec DevSkim, ST3.voir avec Fabiano pour un exemple 
Lancer le scan avec DevSkim comme dans l'exemple : (obtenir un exemple)
S'assurer d'alimenter que les scan vont bien alimenter le référentiel des vulnérabilités EX: .Advanced Security - Repos. 


Voici un exemple 
XU_AnalysePeriodique.yml - Repos



Contact1: Martin Desmeules
Contact2: Fabiano Liberati
