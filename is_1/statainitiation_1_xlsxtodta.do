/*		Evens SALIES, v1. 09/2019, v2. 09/2020, 09/2021, 09/2022, 09/2024
		Je remercie Adam SEBTI pour la commande reshape
 	"statainitiation_1_xlsxtodta.do", disponible a http://www.evens-salies.com/
	Convertit la feuille d'un doc. Excel .xlsx en fichier de donnees Stata .dta
	Illustration : taux d'impot sur les societes. Source : OECD tax database,
	http://www.oecd.org/tax/tax-policy/tax-database.htm#C_CorporateCapital */ 

set more 		off
macro drop		_all
import excel 	using "http://www.evens-salies.com/2018_TauxStatutaireOCDE.xlsx", clear

/* Vire les 6 dernieres lignes d'emblee */
drop			if _n>=_N-5

/* pays -> var0, annees -> var1, ... */
rename			* var(#), addnumber(0) r	// Nb. de renommages dans r(n)

/* Convertir les valeurs string en nombre (la commande destring) */
local			COLN=r(n)-1					// Nb. annees
local			LAST="var"+"`COLN'"
destring		var1-`LAST', replace
local			ANNEED=var1[1]				// Recupere la premiere annee */
drop			in 1

/* 4 chiffres en tout, 2 apres la virgule, justifie a droite (par def.) */
format 			var1-var`COLN' %4.2f

/* Restructurer les donnees wide (tableau) en long (panel) */
rename			var0 PAYS
reshape			long var, i(PAYS) j(ANNEE)

/*	Mettre les bonnes valeurs des annees */
replace			ANNEE=ANNEE+`ANNEED'-1

/*	Importer des variables suppl. Je veux les noms de pays en français, mais la
	plupart sont en anglais. Solution : 4 FR -> 4 EN, 36 EN -> 36 FR  */
	
replace		PAYS="Germany" if PAYS=="Allemagne"
replace		PAYS="Spain" if PAYS=="Espagne"
replace		PAYS="Italy" if PAYS=="Italie"
replace		PAYS="United Kingdom" if PAYS=="Royaume-Uni"
replace		PAYS="South Korea" if PAYS=="Korea"
replace		PAYS="Slovakia" if PAYS=="Slovak Republic"

sort		PAYS ANNEE
rename		PAYS english

merge m:1	english using ///
			"http://www.evens-salies.com/countries.dta", /// 
				keepusing(francais alpha2 monnaie)
/*  */
drop if		_merge==2
drop		_merge english

/* Arrange, etiquette les variables, gagne un peu de place et sauve */
rename		francais PAYS

ghj

order		PAYS ANNEE

order		alpha2, last
rename			(var monnaie)(TAUX MONNAIE)
label variable	TAUX "Taux d'imposition des societes (en %)"
label variable	ANNEE "Annee"
label variable	PAYS "Pays"
label variable	MONNAIE "Code monnaie"
label variable	alpha2 "Code iso2"
compress
save		"statainitiation_1_corporatetaxrates", replace
