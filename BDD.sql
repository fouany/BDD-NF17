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


CREATE TABLE Vehicule(	
	immat NUMERIC PRIMARY KEY,
	marque VARCHAR(30) NOT NULL,
	categorie VARCHAR CHECK (categorie IN ('citadine','p_berline','m_berline','g_berline','4x4 SUV','break','familiale','pickup','utilitaire')) NOT NULL,
	modele VARCHAR(30) NOT NULL,
	carburant VARCHAR CHECK (carburant IN ('SP95', 'SP98', 'Diesel', 'Electrique', 'Ecocarburant')) NOT NULL,
	options VARCHAR CHECK (options IN ('gps','ac', 'sport', 'bluemotion', 'easypark')) NOT NULL,
	etat VARCHAR(200) NOT NULL, -- L'état doit être qualifié par au moins un adjectif
	km_parcourus DECIMAL NOT NULL,
	nv_carburant DECIMAL NOT NULL,
	anciennete NUMERIC CHECK (anciennete >= 0 AND anciennete <= 9) NOT NULL,
	freq_entretien NUMERIC NOT NULL -- Fréquence d'entretien en mois
);

CREATE TABLE Agence(	
	nom_agence VARCHAR(30) PRIMARY KEY, -- Le nom de l'agence étant unique, on peut le considérer comme clé primaire
	nb_employe NUMERIC CHECK (nb_employe >= 2) NOT NULL
);

CREATE TABLE Employe(
	id_employe NUMERIC PRIMARY KEY,
	nom_employe VARCHAR(30) NOT NULL,
	prenom_employe VARCHAR(30) NOT NULL,
	age NUMERIC NOT NULL,
	email VARCHAR(30) UNIQUE NOT NULL, -- Toutes les adresses email doivent être distinctes
	adresse VARCHAR(100) NOT NULL,
	agence VARCHAR(30) NOT NULL,
	FOREIGN KEY (agence) REFERENCES Agence(nom_agence)
);

CREATE TABLE Agent_commercial(
	employe_commercial NUMERIC PRIMARY KEY,
	FOREIGN KEY (employe_commercial) REFERENCES Employe(id_employe) -- AJOUTER CHECK
);

CREATE TABLE Agent_technique(
	employe_technique NUMERIC PRIMARY KEY,
	FOREIGN KEY (employe_technique) REFERENCES Employe(id_employe) -- AJOUTER CHECK
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


--SQL contraintes de cardinalité pas exprimées