# Note De Clarification

## Liste des objets présents dans la base et leur propriétés
* Agence : nom de l'agence, nombre d'employés
* Employe : identifiant de l'employé, nom, prénom, âge, email, adresse
* Agent technique : hérite des attributs de "Employe"
* Agent commercial : hérite des attributs de "Employe"
* Controle : date de fin de location, degats de fin de location, kilomètres parcourus en fin de location, niveau de carburant en fin de location
* Facturation : payee ou non payee, montant, date, moyen de règlement (espèce, carte de crédit, carte de débit)
* Societe de réparation : identifiant de la société, nom de la société
* Reparation : nombre de jours d'immobilisation du véhicule
* Vehicule : numéro d'immatriculation, marque, type (citadine, p_berline, m_berline, g_berline, 4x4 SUV, break, familiale, pickup, utilitaire), modèle, carburant (SP, SP95, SP98, Diesel, Electrique, Ecocarburant), options (gps, ac, sport, bluemotion, easypark), état, kilomètres parcourus, niveau du carburant, indice d'anncienneté (entre 0 et 9), fréquence d'entretien en semaines
* Entretien : date de réalisation de l'entretien
* Client : nom du client, prénom, adresse, âge, téléphone, copie du permis
* Particulier : hérite des attributs de "Client"
* Professionnel : hérite des attributs de "Client", nom de l'entreprise, identifiant de l'entreprise, liste des conducteurs
* Location : identifiant de location, moyen de réalisation de la location (en ligne, téléphone, agence)
* Contrat de location : dégâts apparents en début de location, kilomètres parcourus en début de location, niveau de carburant en début de location, seuil de kilométrage, prix du carburant après le seuil, date de début du contrat, date prévue de fin du contrat
* Validation finale : est effectuée par un agent commercial

## Liste des contraintes associées à ces objets 
* Une agence est composée d'au moins 2 employés
* Un employé est soit un agent commercial, soit un agent technique
* Un agent technique gère le processus de contrôle (incluant l'entretien) mais un contrôle n'est lié qu'à un agent technique
* Une location est composée d'un contrat de location et un cont
*  Agent commercial :
	* Un agent commercial peut éditer plusieurs facturations mais une facturation est éditée par un agent commercial
	* Un agent commercial peut gérer plusieurs validations finales mais une validation finale est gérée par un seul agent commercial
	* Un agent commercial peut gérer plusieurs contrats de location mais un contrat de location est géré par un seul agent commercial
* Contrat de location
	* Un contrat de location est associé à une ou plusieurs factures mais une facture est associée à un seul contrat
	* Un contrat de location est associé à un seul véhicule à la fois mais un véhicule peut être associé à plusieurs contrats (non simultanément)
	* Un contrat de location donne suite à une validation finale et une validation finale est associée à un contrat de location
* Contrôle
	* Un contrôle peut donner lieu a une facture  s'il y a des dégâts impliquant des réparations ou aucune facture
	* Un contrôle peut vérifier un et un seul contrat de location et un contrat de location est contrôlé une fois
	* Un contrôle peut donner suite à une réparation ou aucune réparation et une réparation est associée à un seul contrôle
* Une société de réparation peut effectuer plusieurs réparations et plusieurs entretiens
* Une réparation est effectuée par une seule société de réparation
* Un entretien est effectué par une seule société de réparation et concerne un unique véhicule
* Un client est soit un particulier, soit un professionnel
* Un particulier peut ajouter, modifier, valider une seule location et une location peut être ajoutée, modifiée, validée par plusieurs particuliers
* Un professionnel peut ajouter, modifier, valider plusieurs locations et une location peut être ajoutée, modifiée, validée par plusieurs professionnels

## Vues
* Liste des véhicules disponibles avec toutes les attributs du véhicule
* Bilans financiers: 
	* Recettes produites par véhicule
	* Recettes produites par client
	* Recettes produites par catégorie de véhicule
* Liste de l'ensemble des opérations (location, facture, contrôle, validation finale, procesus d'entretien) effectuées par un agent commercial ou technique

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
