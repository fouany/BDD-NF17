DROP TABLE IF EXISTS Vehicule CASCADE;
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
	options VARCHAR CHECK (options IN ('gps', 'ac', 'sport', 'bluemotion', 'easypark')) NOT NULL,
	etat VARCHAR(200) NOT NULL, -- L'état doit être qualifié par au moins un adjectif
	km_parcourus DECIMAL NOT NULL,
	nv_carburant DECIMAL NOT NULL,
	anciennete NUMERIC CHECK (anciennete >= 0 AND anciennete <= 9) NOT NULL,
	freq_entretien NUMERIC NOT NULL -- Fréquence d'entretien en mois
);

CREATE TABLE Agence(	
    id_agence NUMERIC PRIMARY KEY,
	nom_agence VARCHAR(30) UNIQUE NOT NULL
	--nb_employe NUMERIC CHECK (nb_employe >= 2) NOT NULL
);

-- Vérifier qu'une agence a bien au moins 2 employes
--CREATE VIEW Nb_employes(agence) AS
--SELECT COUNT(E.id_employe) 
--FROM Employe E, Agence A
--WHERE E.agence = A.id_agence;

CREATE TABLE Employe(
	id_employe NUMERIC PRIMARY KEY,
	nom_employe VARCHAR(30) NOT NULL,
	prenom_employe VARCHAR(30) NOT NULL,
	age NUMERIC NOT NULL,
	email VARCHAR(30) UNIQUE NOT NULL, -- Toutes les adresses email doivent être distinctes
	adresse VARCHAR(100) NOT NULL,
	agence NUMERIC NOT NULL,
	FOREIGN KEY (agence) REFERENCES Agence(id_agence),
	-- CHECK id_employe
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
	nom_societe VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE Particulier(
	id_particulier NUMERIC PRIMARY KEY,
	nom VARCHAR(30) NOT NULL,
	prenom VARCHAR(30) NOT NULL,
	age NUMERIC NOT NULL,
	telephone NUMERIC UNIQUE NOT NULL,
	copie_permis VARCHAR(200) NOT NULL
);

CREATE TABLE Professionnel(
	id_professionnel NUMERIC PRIMARY KEY,
	nom VARCHAR(30) NOT NULL,
	prenom VARCHAR(30) NOT NULL,
	age NUMERIC NOT NULL,
	telephone NUMERIC UNIQUE NOT NULL,
	copie_permis VARCHAR(200) NOT NULL,
	num_entreprise NUMERIC UNIQUE NOT NULL,
	nom_entreprise VARCHAR(30) NOT NULL,
	conducteurs VARCHAR(30) NOT NULL --La liste des conducteurs est forcémment non nulle car à minima, le client sera parmis les conducteurs
);

CREATE TABLE Location(
	id_location NUMERIC PRIMARY KEY,
	moyen VARCHAR CHECK (moyen IN ('en ligne', 'telephone', 'agence')) NOT NULL,
	client NUMERIC NOT NULL
	-- FOREIGN KEY client REFERENCES Particulier(id_particulier) ??!!
);

CREATE TABLE Contrat_location(
	id_contrat NUMERIC PRIMARY KEY,
	km_parcourus_debut_location DECIMAL NOT NULL,
	nv_carburant_debut_lcoation NUMERIC NOT NULL,
	seuil_km NUMERIC NOT NULL,
	prix_carburant_seuil DECIMAL NOT NULL,
	date_debut DATE,
	date_fin_prevue DATE,
	location NUMERIC NOT NULL,
	vehicule NUMERIC NOT NULL,
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
	agent_commercial NUMERIC NOT NULL,
	FOREIGN KEY (contrat_location) REFERENCES Contrat_location(id_contrat),
	FOREIGN KEY (agent_commercial) REFERENCES Agent_commercial(employe_commercial)
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
    nb_jours_immobilisation NUMERIC NOT NULL,
    controle NUMERIC NOT NULL,
    facturation NUMERIC NOT NULL,
    FOREIGN KEY (controle) REFERENCES Controle(id_controle),
    FOREIGN KEY (facturation) REFERENCES Facturation(id_facturation)
);

--SQL contraintes de cardinalité pas exprimées



-- Insertions des données
--INSERT INTO Vehicule VALUES (0123456789, 'Peugeot', 'citadine', '206', 'SP95', 'gps',  )
--Changer options vehicule dans table supplémentaire?
INSERT INTO Agence VALUES()

