# Note De Clarification

## Liste des objets présents dans la base et leur propriétés
* Agence : identifiant (clé primaire) nom de l'agence, nombre d'employés
* Employe : identifiant de l'employé (clé primaire), nom, prénom, âge, email, adresse
* Agent technique : hérite des attributs de "Employe", référence à l'identifiant d'employé (clé primaire)
* Agent commercial : hérite des attributs de "Employe", référence à l'identifiant d'employé (clé primaire)
  On fait cet héritage pour rassembler les attributs (identiques) des employés, mais pour différencier leurs actions
* Controle : identifiant du contrôle (clé primaire), date de fin de location, degats de fin de location, kilomètres parcourus en fin de location, niveau de carburant en fin de location
* Facturation : identifiant de facturation (clé primaire), payee ou non payee, montant, date, moyen de règlement (espèce, carte de crédit, carte de débit), clé étrangère vers le contrat de location, clé étrangère vers l'agent commecial qui s'en occupe
* Societe de réparation : identifiant de la société (clé primaire), nom de la société
* Reparation : nombre de jours d'immobilisation du véhicule
* Vehicule : numéro d'immatriculation (clé primaire), marque, type (citadine, p_berline, m_berline, g_berline, 4x4 SUV, break, familiale, pickup, utilitaire), modèle, carburant (SP, SP95, SP98, Diesel, Electrique, Ecocarburant), options (gps, ac, sport, bluemotion, easypark), état, kilomètres parcourus, niveau du carburant, indice d'anncienneté (entre 0 et 9), fréquence d'entretien en semaines
* Entretien : identifiant de l'entretien (clé primaire), date de réalisation de l'entretien, clé étrangère vers le véhicule, clé étrangère vers la société de réparation, clé étrangère vers le contrat de location, clé étrangère vers l'agent technique associé
* Client : identifiant du client (clé primaire), nom du client, prénom, adresse, âge, téléphone, copie du permis
* Particulier : hérite des attributs de "Client" sans attribut en plus car il n'a pas de propriétés en plus
* Professionnel : hérite des attributs de "Client", mais aussi nom de l'entreprise, identifiant de l'entreprise, liste des conducteurs. Le client professionnel est effectivement un client type mais avec davantage de renseignements.
  On fait cet héritage pour éviter les doublons de champs dans les tables client et professionnel et pour différencier les actions (différentes) d'un client particulier et professionnel
* Location : identifiant de location (clé primaire), moyen de réalisation de la location (en ligne, téléphone, agence), clé étrangère au client particulier ou professionnel qui a fait la location
* Contrat de location : identifiant de la location (clé primaire), dégâts apparents en début de location, kilomètres parcourus en début de location, niveau de carburant en début de location, seuil de kilométrage, prix du carburant après le seuil, date de début du contrat, date prévue de fin du contrat, clé étrangère vers la location, clé étrangère vers le véhicule, clé étrangère vers l'agent commercial
* Validation finale : est effectuée par un agent commercial

## Liste des contraintes associées à ces objets 
* Une agence est composée d'au moins 2 employés : Se traduit par une relation de composition car la durée de vie de l'agence dépend du nombre d'employés
* Un employé est soit un agent commercial, soit un agent technique : Se traduit par une un héritage par référence depuis les classes filles vers la classe mère Employe car les filles ont les mêmes attributs mais des actions différentes
* Un agent technique gère le processus de contrôle (incluant l'entretien) mais un contrôle n'est lié qu'à un agent technique
  --> Association permettant de tracer de manière unique l'historique des techniciens gérant les processus
*  Agent commercial :
	* Un agent commercial peut éditer plusieurs facturations mais une facturation est éditée par un agent commercial
	* Un agent commercial peut gérer plusieurs validations finales mais une validation finale est gérée par un seul agent commercial
	* Un agent commercial peut gérer plusieurs contrats de location mais un contrat de location est géré par un seul agent commercial
	  	  --> Ces trois associations permettent de tracer de manière unique l'historique les actions d'un agent commmercial et de les associer à l'action réalisée

* Contrat de location
	* Un contrat de location est associé à une ou plusieurs factures mais une facture est associée à un seul contrat
	* Un contrat de location est associé à un seul véhicule à la fois mais un véhicule peut être associé à plusieurs contrats (non simultanément)
	* Un contrat de location donne suite à une validation finale et une validation finale est associée à un contrat de location
	  	  --> Ces trois associations permettent de faire le lien entre les différents objets, donc d'accéder à l'information d'un objet à un autre également pour des raisons d'historique et de traçabilité en cas de conflits ou simplement de management. 
              En associant les données, on pourra avoir l'ensemble des informations mais en gardant une structure au sein de différents objets.

* Contrôle
	* Un contrôle peut donner lieu a une facture  s'il y a des dégâts impliquant des réparations ou aucune facture
	* Un contrôle peut vérifier un et un seul contrat de location et un contrat de location est contrôlé une fois
	* Un contrôle peut donner suite à une réparation ou aucune réparation et une réparation est associée à un seul contrôle
		  	  --> Ces trois associations permettent de faire le lien entre les différents objets, donc d'accéder à l'information d'un objet à un autre également pour des raisons d'historique et de traçabilité en cas de conflits ou simplement de management. 
              En associant les données, on pourra avoir l'ensemble des informations mais en gardant une structure au sein de différents objets.
* Une société de réparation peut effectuer plusieurs réparations et plusieurs entretiens
* Une réparation est effectuée par une seule société de réparation
* Un entretien est effectué par une seule société de réparation et concerne un unique véhicule
* Un client est soit un particulier, soit un professionnel : Se traduit par un héritage par les classes filles particulier et professionnel pour pouvoir différencier les actions que les filles peuvent faire, mais rassembler les attributs communs au sein d'un même objet.
* Un particulier peut ajouter, modifier, valider une seule location et une location peut être ajoutée, modifiée, validée par plusieurs particuliers
* Un professionnel peut ajouter, modifier, valider plusieurs locations et une location peut être ajoutée, modifiée, validée par plusieurs professionnels

## Vues
* Liste des véhicules disponibles avec tous les attributs du véhicule : Requêtes sur la table véhicule et contrat de location
* Bilans financiers: 
	* Recettes produites par véhicule : Requêtes sur la table véhicule, contrat de location et entretien
	* Recettes produites par client : Requêtes sur les tables client particuliers (ou client professionnel) et facturation
	* Recettes produites par catégorie de véhicule : Requêtes sur la table véhicule, contrat de location, entretien
* Liste de l'ensemble des opérations (location, facture, contrôle, validation finale, procesus d'entretien) effectuées par un agent commercial ou technique : Requêtes sur la table agent commercial (ou agent technique), contrat de location, facturation, controle, entretien

## Liste des utilisateurs qui vont utiliser la base de données, leur rôle et leurs droits et fonctions
* Agents commerciaux
	* Rôles : pouvoir suivre les véhicules disponibles et en cours en location, gérer (ajouts, modifications, suppressions) les réservations
	* Droits et fonctions: consulter la liste des véhicules disponibles, ajouter, modifier, supprimer des locations, faire le paiement  des factures
* Agents techniques 
	* Rôles : surveiller quels sont les véhicules disponibles, en réparation, en entretien, suivre les processus de contrôle, établir les factures de réparation
	* Droits et fonctions : consulter la liste des véhicules disponibles, en réparation, en entretien, suivre les processus de contrôle, établir les factures de réparation
* Clients 
	* Rôles : effectuer des réservations en ligne, par téléphone ou en agence
	* Droits et fonctions : ajouter, modifier, supprimer une.des location.s,  consulter sa.ses location.s en cours

## Hypothèses faites sur le sujet
* Puisque les agents techniques et commerciaux n'occupent pas les mêmes fonctions, on considère qu'une agence est composée d'au moins deux employés, dont un agent technique et un commercial
* Les agents héritent de Employe car ils ont les mêmes attributs mais pas les même fonctions
* La catégorie, les options et l'ancienneté du véhicule font partie de l'objet Vehicule car cela simplifie le modèle et cela évite la surchage des références vers le même objet
* L'ancienneté d'un véhicule sera un chiffre entre 0 et 9, 9 étant le plus ancien
* Le contrat de location compose la location car leurs durées de vie sont liées
* La validation finale a un attribut realisee pour améliorer la traçabilité du processus de fin de location
