DROP TABLE IF EXISTS Faktura;
CREATE TABLE "Faktura" (
  "identyfikator" INTEGER PRIMARY KEY NOT NULL ,
  "Osoba_id_osoby" INTEGER  NOT NULL,
  "id_faktury" INTEGER UNSIGNED NULL,
  "Wartosc netto" FLOAT NULL,
  "Wartosc brutto" FLOAT NULL,
  "Cena za kg" FLOAT NULL,
  "Podatek" FLOAT NULL,
  "Data zakupu" DATE NULL,
  "Data zaplaty" DATE NULL,
  "Zaplacono"  BOOL NULL,
  "id_zwierzecia" INTEGER UNSIGNED NULL,
  "Wazne" INTEGER UNSIGNED NULL
);

DROP TABLE IF EXISTS Kategoria_bydla;
CREATE TABLE Kategoria_bydla (
  id_kategorii INTEGER UNSIGNED NOT NULL PRIMARY KEY,
  Nazwa CHAR(20) NULL,
  Wazne INTEGER UNSIGNED NULL);

DROP TABLE IF EXISTS Osoba;
CREATE TABLE Osoba (
  id_osoby INTEGER UNSIGNED NOT NULL PRIMARY KEY,
  Imie CHAR(40) NULL,
  Nazwisko CHAR(40) NULL,
  Adres CHAR(200) NULL,
  NIP CHAR(11) NULL,
  PESEL CHAR(11) NULL,
  Seria i numer dowodu CHAR(30) NULL,
  Wazne INTEGER UNSIGNED NULL
);

DROP TABLE IF EXISTS Plik;
CREATE TABLE Plik (
  id_pliku INTEGER UNSIGNED NOT NULL PRIMARY KEY,
  Ubojnia_id_ubojni INTEGER UNSIGNED NOT NULL,
  Nazwa CHAR(30) NULL,
  Data utworzenia DATE NULL,
  Zakonczony BOOL NULL,
  Weksportowany BOOL NULL,
  Inne TEXT NULL,
  Wazne INTEGER UNSIGNED NULL
  
);

DROP TABLE IF EXISTS Przedzial_wiekowy;
CREATE TABLE Przedzial_wiekowy (
  id_przedzialu INTEGER UNSIGNED NOT NULL PRIMARY KEY,
  Opis CHAR(5) NULL,
  Wazne INTEGER UNSIGNED NULL

);

DROP TABLE IF EXISTS Rasa;
CREATE TABLE Rasa (
  id_rasy CHAR(2) NOT NULL PRIMARY KEY,
  Nazwa CHAR(20) NULL,
  Wazne INTEGER UNSIGNED NULL

);

DROP TABLE IF EXISTS Uboj;
CREATE TABLE Uboj (
  id_uboju INTEGER UNSIGNED NOT NULL PRIMARY KEY,
  Ubojnia_id_ubojni INTEGER UNSIGNED NOT NULL,
  Data DATE NULL,
  Nr_zezni INT NULL,
  Nr_Weterynaryjny  INT NULL,
  Data_wydania_decyzji_wet DATE NULL,
  Szczegoly  TEXT NULL,
  Wazne INTEGER UNSIGNED NULL
);

DROP TABLE IF EXISTS Ubojnia;
CREATE TABLE Ubojnia (
  id_ubojni INTEGER UNSIGNED NOT NULL PRIMARY KEY,
  Nazwa CHAR(100) NULL,
  PESEL CHAR(11) NULL,
  REGON CHAR(11) NULL,
  Adres CHAR(160) NULL,
  Inne TEXT NULL,
  Wazne INTEGER UNSIGNED NULL
);

DROP TABLE IF EXISTS Zakup;
CREATE TABLE Zakup (
  identyfikator INTEGER UNSIGNED NOT NULL PRIMARY KEY,
  Faktura_identyfikator INTEGER UNSIGNED NOT NULL,
  Zwirze_id_zwierzecia INTEGER UNSIGNED NOT NULL,
  id_zakupu INTEGER UNSIGNED NULL,
  Wazne INTEGER UNSIGNED NULL 
);

DROP TABLE IF EXISTS Zwierze;
CREATE TABLE Zwierze (
  id_zwierzecia INTEGER UNSIGNED NOT NULL PRIMARY KEY,
  Uboj_id_uboju INTEGER UNSIGNED NULL,
  Plik_id_pliku INTEGER UNSIGNED NULL,
  Rasa_id_rasy CHAR(2) NOT NULL,
  Kategoria_bydla_id_kategorii INTEGER UNSIGNED NOT NULL,
  Przedzial_wiekowy_id_przedzialu INTEGER UNSIGNED NOT NULL,
  Identyfikator CHAR(20) NULL,
  "Numer parti uboju" INT NULL,
  "Data przyjecia do" rzezni DATE NULL,
 "Data urodzenia" DATE NULL,
  "Numer stada" INTEGER UNSIGNED NULL,
  "Numer Rzeni" INTEGER UNSIGNED NULL,
  "Masa Ciala" FLOAT NULL,
  Podpis BOOL NULL,
  Wazne INTEGER UNSIGNED NULL
);


