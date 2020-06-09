DROP TABLE IF EXISTS Vehicule CASCADE;
DROP TABLE IF EXISTS Options CASCADE;
DROP TABLE IF EXISTS Agence CASCADE;
DROP TABLE IF EXISTS Employe CASCADE;
DROP TABLE IF EXISTS Agent_commercial CASCADE;
DROP TABLE IF EXISTS Agent_technique CASCADE;
DROP TABLE IF EXISTS Societe_reparation CASCADE;
DROP TABLE IF EXISTS Particulier CASCADE;
DROP TABLE IF EXISTS Professionnel CASCADE;
DROP TABLE IF EXISTS Location CASCADE;
DROP TABLE IF EXISTS Contrat_location CASCADE;
DROP TABLE IF EXISTS Facturation CASCADE;
DROP TABLE IF EXISTS Validation_finale CASCADE;
DROP TABLE IF EXISTS Entretien CASCADE;
DROP TABLE IF EXISTS Controle CASCADE;
DROP TABLE IF EXISTS Reparation CASCADE;

-- Créations des tables

CREATE TABLE Vehicule(	
	immat NUMERIC PRIMARY KEY,
	marque VARCHAR(30) NOT NULL,
	categorie VARCHAR CHECK (categorie IN ('citadine','p_berline','m_berline','g_berline','4x4 SUV','break','familiale','pickup','utilitaire')) NOT NULL,
	modele VARCHAR(30) NOT NULL,
	carburant VARCHAR CHECK (carburant IN ('SP95', 'SP98', 'Diesel', 'Electrique', 'Ecocarburant')) NOT NULL,
	options JSON NOT NULL,
	etat VARCHAR(200) NOT NULL, -- L'état doit être qualifié par au moins un adjectif
	km_parcourus DECIMAL NOT NULL,
	nv_carburant INT NOT NULL, -- Niveau en pourcentage
	anciennete NUMERIC CHECK (anciennete >= 0 AND anciennete <= 9) NOT NULL,
	freq_entretien NUMERIC NOT NULL -- Fréquence d'entretien en mois
);

CREATE TABLE Agence(	
    id_agence NUMERIC PRIMARY KEY,
	nom_agence VARCHAR(30) UNIQUE NOT NULL,
	adress VARCHAR(30) NOT NULL
);

CREATE TABLE Employe(
	id_employe NUMERIC PRIMARY KEY,
	nom_employe VARCHAR(30) NOT NULL,
	prenom_employe VARCHAR(30) NOT NULL,
	age NUMERIC NOT NULL,
	email VARCHAR(30) UNIQUE NOT NULL, -- Toutes les adresses email doivent être distinctes
	adresse JSON NOT NULL,
	agence NUMERIC NOT NULL,
	FOREIGN KEY (agence) REFERENCES Agence(id_agence)
);

CREATE TABLE Agent_commercial(
	employe_commercial NUMERIC PRIMARY KEY,
	FOREIGN KEY (employe_commercial) REFERENCES Employe(id_employe)
);

CREATE TABLE Agent_technique(
	employe_technique NUMERIC PRIMARY KEY,
	FOREIGN KEY (employe_technique) REFERENCES Employe(id_employe)
);

CREATE TABLE Societe_reparation(
	id_societe NUMERIC PRIMARY KEY,
	nom_societe VARCHAR(30) UNIQUE NOT NULL,
	adresse VARCHAR(30) NOT NULL
);

CREATE TABLE Particulier(
	id_particulier NUMERIC PRIMARY KEY,
	nom VARCHAR(30) NOT NULL,
	prenom VARCHAR(30) NOT NULL,
	age NUMERIC NOT NULL,
	telephone NUMERIC UNIQUE NOT NULL,
	copie_permis JSON NOT NULL
);

CREATE TABLE Professionnel(
	id_professionnel NUMERIC PRIMARY KEY,
	nom VARCHAR(30) NOT NULL,
	prenom VARCHAR(30) NOT NULL,
	age NUMERIC NOT NULL,
	telephone NUMERIC UNIQUE NOT NULL,
	copie_permis JSON NOT NULL,
	num_entreprise NUMERIC UNIQUE NOT NULL,
	nom_entreprise VARCHAR(30) NOT NULL,
	conducteurs JSON NOT NULL --La liste des conducteurs est forcémment non nulle car à minima, le client sera parmis les conducteurs
);

CREATE TABLE Location(
	id_location NUMERIC PRIMARY KEY,
	moyen VARCHAR CHECK (moyen IN ('en ligne', 'telephone', 'agence')) NOT NULL,
	client_particulier NUMERIC,
	client_professionnel NUMERIC, 
	FOREIGN KEY (client_particulier) REFERENCES Particulier(id_particulier),
	FOREIGN KEY (client_professionnel) REFERENCES Professionnel(id_professionnel),
	CHECK (	(client_particulier IS NOT NULL AND client_professionnel IS NULL) OR 
	        (client_particulier IS NULL AND client_professionnel IS NOT NULL)) -- La location est faite par un particulier ou un professionnel
);

CREATE TABLE Contrat_location(
	id_contrat NUMERIC PRIMARY KEY,
	location NUMERIC NOT NULL,
	vehicule NUMERIC NOT NULL,
	km_parcourus_debut_location DECIMAL NOT NULL,
	nv_carburant_debut_location NUMERIC NOT NULL,
	seuil_km NUMERIC NOT NULL,
	prix_carburant_seuil DECIMAL NOT NULL,
	date_debut DATE,
	date_fin_prevue DATE,
	agent_commercial NUMERIC NOT NULL,
	FOREIGN KEY (location) REFERENCES Location(id_location),
	FOREIGN KEY (vehicule) REFERENCES Vehicule(immat),
	FOREIGN KEY (agent_commercial) REFERENCES Agent_commercial(employe_commercial)
);

CREATE TABLE Facturation(
	id_facturation NUMERIC PRIMARY KEY,
	payee BOOLEAN NOT NULL,
	montant DECIMAL NOT NULL,
	date DATE,
	moyen_reglement VARCHAR CHECK (moyen_reglement IN ('espece', 'credit', 'debit')) NOT NULL,
	contrat_location NUMERIC NOT NULL,
	FOREIGN KEY (contrat_location) REFERENCES Contrat_location(id_contrat)
);

CREATE TABLE Validation_finale(
    realisee BOOLEAN NOT NULL,
    contrat_location NUMERIC NOT NULL,
    agent_commercial NUMERIC NOT NULL,
    FOREIGN KEY (contrat_location) REFERENCES Contrat_location(id_contrat),
	FOREIGN KEY (agent_commercial) REFERENCES Agent_commercial(employe_commercial)
);

CREATE TABLE Entretien(
    id_entretien NUMERIC PRIMARY KEY,
    date DATE,
    vehicule NUMERIC NOT NULL,
    societe_reparation NUMERIC NOT NULL,
    FOREIGN KEY (vehicule) REFERENCES Vehicule(immat),
    FOREIGN KEY (societe_reparation) REFERENCES Societe_reparation(id_societe)
);

CREATE TABLE Controle(
    id_controle NUMERIC PRIMARY KEY,
    date_fin_location DATE,
    degats_fin_location VARCHAR(200) NOT NULL,
    km_parcourus_fin_location DECIMAL NOT NULL,
    nv_carburant_fin_location DECIMAL NOT NULL,
    contrat_location NUMERIC NOT NULL,
    agent_technique NUMERIC NOT NULL,
    FOREIGN KEY (contrat_location) REFERENCES Contrat_location(id_contrat),
    FOREIGN KEY (agent_technique) REFERENCES Agent_technique(employe_technique)
);

CREATE TABLE Reparation(
    controle NUMERIC NOT NULL,
    facturation NUMERIC NOT NULL,
    nb_jours_immobilisation NUMERIC NOT NULL,
    FOREIGN KEY (controle) REFERENCES Controle(id_controle),
    FOREIGN KEY (facturation) REFERENCES Facturation(id_facturation)
);


-- Insertions des données

INSERT INTO Vehicule VALUES (0, 'Peugeot', 'citadine', '206', 'SP95', '{"gps": true, "ac": true, "sport": false, "bluemotion": false, "easypark": false}', 'Bon état', 10000, '50', '0', '12');
INSERT INTO Vehicule VALUES (1, 'Renault', '4x4 SUV', 'Kadjar', 'SP98', '{"gps": true, "ac": true, "sport": false, "bluemotion": false, "easypark": false}', 'Mauvais état', 20000, '60', '5', '6');
INSERT INTO Vehicule VALUES (2, 'Citroen', 'citadine', 'C3', 'SP95', '{"gps": false, "ac": true, "sport": false, "bluemotion": false, "easypark": false}', 'Bon état', 30000, '100', '3', '12');
INSERT INTO Vehicule VALUES (3, 'Mercedes-Benz', 'citadine', 'Classe A', 'Ecocarburant', '{"gps": true, "ac": true, "sport": true, "bluemotion": true, "easypark": true}', 'Bon état', 40000, '80', '2', '12');
INSERT INTO Vehicule VALUES (4, 'Audi', 'familiale', 'A6', 'SP95', '{"gps": true, "ac": true, "sport": false, "bluemotion": true, "easypark": true}', 'Bon état', 50000, '90', '3', '24');
INSERT INTO Vehicule VALUES (5, 'Tesla', 'familiale', 'Tesla-3', 'Electrique', '{"gps": true, "ac": true, "sport": true, "bluemotion": true, "easypark": true}', 'Bon état', 1000, '100', '4', '18');

INSERT INTO Agence VALUES (0, 'EasyRental', '150 rue Boileau 69006 Lyon');

INSERT INTO Employe VALUES (0, 'Dupont', 'Michel', 45, 'michel.dupont@easyrental.com', '{"numero": 1, "rue": "rue du Bois", "cp": 69001, "ville": "Lyon"}', 0);
INSERT INTO Employe VALUES (1, 'Dupond', 'Thibault', 50, 'thibault.dupond@easyrental.com', '{"numero": 2, "rue": "rue Boileau", "cp": 69002, "ville": "Lyon"}', 0);
INSERT INTO Employe VALUES (2, 'Dupons', 'Grégoire', 40, 'gregoire.dupons@easyrental.com', '{"numero": 3, "rue": "rue Juliette Récamier", "cp": 69003, "ville": "Lyon"}', 0);
INSERT INTO Employe VALUES (3, 'Martin', 'Antoine', 45, 'antoine.martin@easyrental.com', '{"numero": 4, "rue": "rue Jean Moulin", "cp": 69004, "ville": "Lyon"}', 0);
INSERT INTO Employe VALUES (4, 'Durand', 'Isabelle', 35, 'isabelle.durand@easyrental.com', '{"numero": 5, "rue": "rue de Gaulle", "cp": 69005, "ville": "Lyon"}', 0);
INSERT INTO Employe VALUES (5, 'Dubois', 'Sophie', 45, 'sophie.duboist@easyrental.com', '{"numero": 6, "rue": "rue Ney", "cp": 69006, "ville": "Lyon"}', 0);

INSERT INTO Agent_commercial VALUES (0);
INSERT INTO Agent_commercial VALUES (1);
INSERT INTO Agent_commercial VALUES (2);

INSERT INTO Agent_technique VALUES (3);
INSERT INTO Agent_technique VALUES (4);
INSERT INTO Agent_technique VALUES (5);

INSERT INTO Societe_reparation VALUES (0, 'EasyRepair', '200 rue Ney 69006 Lyon');

INSERT INTO Particulier VALUES (0, 'Alice', 'Martin', 27, 0123456789, '{"permis": "B", "annee_obtention": 2000}');
INSERT INTO Particulier VALUES (1, 'Pauline', 'Petit', 40, 1234567890, '{"permis": "B", "annee_obtention": 2010}');
INSERT INTO Particulier VALUES (2, 'Stephane', 'Grand', 50, 2345678901, '{"permis": "B remorque", "annee_obtention": 1985}');

INSERT INTO Professionnel VALUES (0, 'Bernard', 'Bole', 50, 3456789012, '{"permis": "B", "annee_obtention": 1990}', '0123456789', 'Entreprise1', '{"conducteurs": ["Bole", "Durant"]}');
INSERT INTO Professionnel VALUES (1, 'Bertand', 'Zabiaux', 35, 4567890123, '{"permis": "B", "annee_obtention": 2001}', '9876543210', 'Entreprise2', '{"conducteurs": ["Zabiaux", "Chapuis", "Gillet"]}');
INSERT INTO Professionnel VALUES (2, 'Benedicte', 'Latour', 40, 5678901234, '{"permis": "B", "annee_obtention": 1996}', '8765432109', 'Entreprise3', '{"conducteurs": ["Latour"]}');

INSERT INTO Location VALUES (0, 'en ligne', 0, NULL);
INSERT INTO Location VALUES (1, 'agence', 1, NULL);
INSERT INTO Location VALUES (2, 'en ligne', 2, NULL);
INSERT INTO Location VALUES (3, 'telephone', NULL, 0);
INSERT INTO Location VALUES (4, 'en ligne', NULL, 1);
INSERT INTO Location VALUES (5, 'en ligne', NULL, 2);

INSERT INTO Contrat_location VALUES (0, 0, 0, 10000, 50, 500, 1.623, TO_DATE('20200110','YYYYMMDD'), TO_DATE('20200120','YYYYMMDD'), 0);
INSERT INTO Contrat_location VALUES (1, 1, 1, 20000, 60, 500, 1.624, TO_DATE('20200111','YYYYMMDD'), TO_DATE('20200120','YYYYMMDD'), 0);
INSERT INTO Contrat_location VALUES (2, 2, 2, 30000, 100, 1000, 1.625, TO_DATE('20200210','YYYYMMDD'), TO_DATE('20200225','YYYYMMDD'), 1);
INSERT INTO Contrat_location VALUES (3, 3, 3, 40000, 90, 1000, 1.626, TO_DATE('20200210','YYYYMMDD'), TO_DATE('20200226','YYYYMMDD'), 1);
INSERT INTO Contrat_location VALUES (4, 4, 4, 1000, 100, 1000, 1.627, TO_DATE('20200310','YYYYMMDD'), TO_DATE('20200715','YYYYMMDD'), 2);

INSERT INTO Facturation VALUES (0, true, 100, TO_DATE('20200120','YYYYMMDD'), 'credit', 0);
INSERT INTO Facturation VALUES (1, true, 200, TO_DATE('20200120','YYYYMMDD'), 'espece', 1);
INSERT INTO Facturation VALUES (2, true, 300, TO_DATE('20200225','YYYYMMDD'), 'debit', 2);
INSERT INTO Facturation VALUES (3, false, 400, TO_DATE('20200226','YYYYMMDD'), 'credit', 3);
INSERT INTO Facturation VALUES (4, false, 500, TO_DATE('20200315','YYYYMMDD'), 'credit', 4);

INSERT INTO Validation_finale VALUES (true, 0, 0);
INSERT INTO Validation_finale VALUES (true, 1, 0);
INSERT INTO Validation_finale VALUES (true, 2, 1);
INSERT INTO Validation_finale VALUES (false, 3, 1);
INSERT INTO Validation_finale VALUES (false, 4, 2);

INSERT INTO Entretien VALUES (0, TO_DATE('20180516','YYYYMMDD'), 0, 0);
INSERT INTO Entretien VALUES (1, TO_DATE('20190617','YYYYMMDD'), 1, 0);
INSERT INTO Entretien VALUES (2, TO_DATE('20200115','YYYYMMDD'), 2, 0);
INSERT INTO Entretien VALUES (3, TO_DATE('20180516','YYYYMMDD'), 3, 0);

INSERT INTO Controle VALUES (0, TO_DATE('20200120','YYYYMMDD'), 'Aucun dégât', 10100, 60, 0, 3);
INSERT INTO Controle VALUES (1, TO_DATE('20200120','YYYYMMDD'), 'Portière droite écorchée', 20200, 70, 1, 4);
INSERT INTO Controle VALUES (2, TO_DATE('20200225','YYYYMMDD'), 'Aucun dégât', 30500, 60, 2, 5);

INSERT INTO Reparation VALUES (1, 1, 1);



-- Gestion de droits

-- CREATE USER un_agent_commercial;
-- CREATE USER un_agent_technique;
-- CREATE User un_client;

-- GRANT ALL PRIVILEGES ON Contrat_location TO un_agent_commercial;
-- GRANT ALL PRIVILEGES ON Validation_finale TO un_agent_commercial;
-- GRANT ALL PRIVILEGES ON Facturation TO un_agent_commercial;
-- GRANT ALL PRIVILEGES ON Location TO un_agent_commercial;
-- GRANT ALL PRIVILEGES ON Vehicule TO un_agent_commercial;
-- GRANT ALL PRIVILEGES ON Agence TO un_agent_commercial;
-- GRANT ALL PRIVILEGES ON Employe TO un_agent_commercial;
-- GRANT ALL PRIVILEGES ON Agent_technique TO un_agent_commercial;
-- GRANT ALL PRIVILEGES ON Agent_commercial TO un_agent_commercial;
-- GRANT ALL PRIVILEGES ON Location TO un_agent_commercial;
-- GRANT ALL PRIVILEGES ON Particulier TO un_agent_commercial;
-- GRANT ALL PRIVILEGES ON Professionnel TO un_agent_commercial;

-- GRANT ALL PRIVILEGES ON Controle TO un_agent_technique;
-- GRANT ALL PRIVILEGES ON Societe_reparation TO un_agent_technique;
-- GRANT ALL PRIVILEGES ON Reparation TO un_agent_technique;
-- GRANT ALL PRIVILEGES ON Entretien TO un_agent_technique;

-- GRANT ALL PRIVILEGES ON Location TO un_client;

-- GRANT SELECT ON Vehicule TO un_agent_technique;

-- GRANT SELECT ON vue_check_nb_employes TO un_agent_commercial;
-- GRANT SELECT ON vue_check_id_employe TO un_agent_commercial;
-- GRANT SELECT ON vue_vehicules_disponibles TO un_agent_commercial, un_agent_technique;
-- GRANT SELECT ON vue_recettes_vehicule TO un_agent_commercial, un_agent_technique;
-- GRANT SELECT ON vue_recettes_categorie_vehicule TO un_agent_commercial, un_agent_technique;
-- GRANT SELECT ON vue_actions_agent_commercial TO un_agent_commercial, un_agent_technique;
-- GRANT SELECT ON vue_actions_agent_technique TO un_agent_commercial, un_agent_technique;
-- GRANT SELECT ON vue_recettes_client_particulier TO un_agent_commercial, un_agent_technique;
-- GRANT SELECT ON vue_recettes_client_professionnel TO un_agent_commercial, un_agent_technique;


-- Vues de vérification des contraintes

-- Vue à destination des administrateurs afin de vérifier qu'une agence a bien au moins 2 employés
CREATE VIEW vue_check_nb_employes AS
SELECT COUNT(E.id_employe)
FROM Employe E, Agence A 
WHERE E.agence = A.id_agence;

-- Vue à destination des administrateurs :
-- Si le nombre d'agents commerciaux et techniques est égal au nombre d'employes et qu'il n'y a pas de doublon, alors les contraintes sont vérifiées
CREATE VIEW vue_check_id_employe AS
SELECT E.id_employe
FROM Employe E, Agent_commercial ac, Agent_technique at
WHERE (E.id_employe = ac.employe_commercial AND E.id_employe != at.employe_technique) OR (E.id_employe != ac.employe_commercial AND E.id_employe = at.employe_technique)
GROUP BY E.id_employe;


-- Vues pour les besoins de l'agence

-- Vue des véhicules disponibles
CREATE VIEW vue_vehicules_disponibles AS
SELECT * FROM Vehicule v
INNER JOIN Contrat_location cl ON cl.vehicule = v.immat
WHERE NOW() > cl.date_fin_prevue;

-- Vue des recettes produites par véhicule
CREATE VIEW vue_recettes_vehicule AS
SELECT v.marque, v.categorie, v.modele, SUM(f.montant) AS Recette FROM Vehicule v
INNER JOIN Contrat_location cl ON cl.vehicule = v.immat
INNER JOIN Facturation f ON f.contrat_location = cl.id_contrat
GROUP BY v.marque, v.categorie, v.modele
ORDER BY SUM(f.montant);

-- Vue des recettes produites par catégorie de véhicule
CREATE VIEW vue_recettes_categorie_vehicule AS
SELECT  v.categorie, SUM(f.montant) AS Recette FROM Vehicule v
INNER JOIN Contrat_location cl ON cl.vehicule = v.immat
INNER JOIN Facturation f ON f.contrat_location = cl.id_contrat
GROUP BY v.categorie
ORDER BY SUM(f.montant);

-- Vue des recettes produites par client particulier
CREATE VIEW vue_recettes_client_particulier AS
SELECT p.id_particulier, SUM(f.montant) AS Recette FROM Particulier p
INNER JOIN Location l ON l.client_particulier = p.id_particulier
INNER JOIN Contrat_location cl ON cl.location = l.id_location
INNER JOIN Facturation f ON f.contrat_location = cl.id_contrat
GROUP BY p.id_particulier
ORDER BY SUM(f.montant);

-- Vue des recettes produites par client particulier
CREATE VIEW vue_recettes_client_professionnel AS
SELECT p.id_professionnel, SUM(f.montant) AS Recette FROM Professionnel p
INNER JOIN Location l ON l.client_professionnel = p.id_professionnel
INNER JOIN Contrat_location cl ON cl.location = l.id_location
INNER JOIN Facturation f ON f.contrat_location = cl.id_contrat
GROUP BY p.id_professionnel
ORDER BY SUM(f.montant);

-- Vue des actions réalisées par un agent_commercial
CREATE VIEW vue_actions_agent_commercial AS
SELECT e.id_employe, e.nom_employe, e.prenom_employe, cl.id_contrat FROM Agent_commercial ac
INNER JOIN Contrat_location cl ON cl.agent_commercial = ac.employe_commercial
INNER JOIN Employe e ON e.id_employe = ac.employe_commercial;

-- Vue des actions réalisées par un agent_technique
CREATE VIEW vue_actions_agent_technique AS
SELECT e.id_employe, e.nom_employe, e.prenom_employe, c.id_controle FROM Agent_technique at
INNER JOIN Controle c ON c.agent_technique = at.employe_technique
INNER JOIN Employe e ON e.id_employe =at.employe_technique;

--Vue des véhicules option sport disponibles
CREATE VIEW vue_vehicules_sport_disponibles AS
--SELECT * FROM Vehicule v
--INNER JOIN Contrat_location cl ON cl.vehicule = v.immat
--WHERE NOW() > cl.date_fin_prevue;
--SELECT v.modele, options->>'sport' FROM Vehicule v, JSON_ARRAY_ELEMENTS(v.options) options;
Select options->>'sport'
from Vehicule v, json_array_elements(v.options->'options') options;
--where options->>'sport' = 'true';



