/*	statinitiation_1_tablesgraphs
	Evens Salies, 08-09/2018, 09/2019, 09/2020, 09/2021, 09/2022, 09/2024
		Tableaux et representations des donnees (population) */

clear		all
use		"http://www.evens-salies.com/statainitiation_1_corporatetaxrates.dta"
set			more off

/* C'est un panel, il faudrait le declarer ainsi (utiliser les retards, ...) */
rename		UNITE TEMP
encode		TEMP, generate(UNITE)
drop		TEMP
order		UNITE
xtset		UNITE ANNEE	// Rq : trie automatique au passage

describe
/*	Notes :
		- les noms des pays sont des chiffres, ce qui peut etre contraignant
		  pour effectuer certaines manipulations
		- 684 = 36*19, c'est bon ! On peut aussi browse le Data Editor
		- 8,02ko env. 3*4*684/1024 */
describe	, short		// Si l'on veut juste recuperer des infos
display		r(N)		// 	#obs
di			r(k)		// 	#var

/* Tableaux
	table 		*/
table		UNITE, content(freq) 	// freq est l'option par defaut
/* Note : Stata17+ : statistic au lieu de content */
table		ANNEE
table		UNITE ANNEE				// Des 1 partout, logique !

/*	Autres options possibles : sd (ecart-type corrige), se (erreur
	type), seb (loi binomiale), sep (loi de Poisson) si variable discrete */
table		TAUX						// Donne une idee des valeurs de TAUX
table		ANNEE, content(mean TAUX)	// Taux moyen par annee
table		ANNEE, content(sd TAUX)		// Ecart-type des taux par annee

/* 	tabulate 	*/
tabulate	TAUX						// Comme table mais freq. relat. et cum.


/* CODER categories de taux */


/* 	tabstat 	*/
tabstat		TAUX, statistics(mean sd) by (ANNEE)
table		ANNEE, content(mean TAUX sd TAUX)

/*  list */
list		UNITE if TAUX>33
list		UNITE ANNEE if TAUX>33
list		UNITE ANNEE if TAUX>33&ANNEE==2018

count 		if	TAUX>33
count 		if	TAUX<=0					// Taux negatifs ou nuls ?

/* summarize (statistiques avec ou sans details) */
summarize	TAUX
su			TAUX, d
su			TAUX if UNITE==12, d		// France


/*	ALLER VOIR "statainitiation_1_missing.do" */


/* Graphiques
 	xtline			*/
xtline		TAUX					// i(UNITE) t(ANNEE) de l'xtset par defaut
xtline		TAUX, i(ANNEE) t(UNITE)	// On permute i et t
xtline		TAUX, overlay i(UNITE) t(ANNEE)
/*	Note : 	illisible dans les deux cas, trop de pays ! */

/*	Graphique a partir de calcul sur les donnees
 	Etendue dans le temps dans un graphique, et moyenne des etendues dans la fe-
	 netre de resultats pour All., Esp., Fr., It., R.-U. sauf 2017. On veut la
	 moyenne des min et des max, et la diff. de ces moyennes 			 */
cls
keep if 	UNITE==1|UNITE==9|UNITE==12|UNITE==18|UNITE==30
tabstat		TAUX if ANNEE!=2017, statistics(min max range) by(ANNEE)
/*	Note: la ligne Total: min des min., max des max, la difference */

preserve
quietly{
 local			MIN=0
 local			MAX=0
 local			RANGE=0
 capture drop	RANGE
 generate		RANGE=.
 forvalues		I=2000(1)2018 {
  if			`I'!=2017 {
   su		TAUX if ANNEE==`I'
   local	MIN=r(min)+`MIN'
   local	MAX=r(max)+`MAX'
   local	RANGE=r(max)-r(min)+`RANGE'			// Pour la moy. des differences
   replace	RANGE=r(max)-r(min) if ANNEE==`I'	// Pour le graphique
   }
 }
 noisily: local NBA=2018-2000+1-1				// -1 car on avait vire 2017
 noisily: display ""
 noisily: display		"Moyenne des min : " `MIN'/`NBA' ///
	", des max : " `MAX'/`NBA' ", et de l'etendue : " `RANGE'/`NBA'
}
keep if		UNITE==1
drop		UNITE
drop if		ANNEE==2017
tsline		RANGE
su			RANGE			// Comme RANGE/NBA 
restore

/* Autres graphiques	*/
use			"http://www.evens-salies.com/rubin1977.dta", clear

describe
sort		INDI

/* Note pre-intervention des eleves qui suivront les programmes A ou B */
replace		PREX=PREX*10
by GROUP, sort: su PREX, d

/* 	stem (diagramme tige-feuille, 16-bit :) des notes post-intervention */
stem		POSY
stem		POSY, width(1)	// On voit encore plus de trous
/* Note : plus le width est petit, plus il y a de trous */

* 	histogram
histogram 		POSY, discrete

* 	Boite a moustache, avec un peu de comentaires sur le graphique
graph box 	POSY, over(GROUP) ///
			ytitle("Note a l'examen") ///
			title("Reponse au prg. de formation par grp. de traitement") ///
			subtitle("(72 eleves)") note("Source : Rubin (1977)")
	
/*	Camembert		*/
clear		all
set obs		1

input		HY NU RE FF
51.18 428.95 6.26 57.17

/*	Electricity generation (in TWh), per energy resources, 2005, France
	Site en 2018 : https://www.eia.gov/beta/international/ */
label variable	HY "Hydroelectricite"
label variable	NU "Nucleaire"
label variable	RE "Renouvelables"
label variable	FF "Fossiles"
graph pie		HY NU RE FF, plabel(_all percent, size(*.8) color(black)) ///
				legend(on) pie(_all, explode) ///
				note("Source : Energy Information Administration, 2005")
/*	Explications des options (pas obligatoires) :
	- _all percent :			tous les secteurs en %
	- size(*1.5) : 				fact. d'echelle des chiffres dans les secteurs
	- color(black/white/...) : 	couleur du texte
	- legend(on/off) : 			legende avec note(""), essayer legend(off)
	- explode : 				detache des secteurs pour meilleure lisibilite
	EDITER UN PEU LE GRAPHIQUE !!!!!!!!!!!!!!!!!!!! */

/* Transformation de variable time series (lags et difference) */
clear		all
use		"http://www.evens-salies.com/statainitiation_1_corporatetaxrates.dta"
rename		UNITE TEMP
encode		TEMP, generate(UNITE)
order		UNITE
xtset		UNITE ANNEE
* Calcul des taux de variation (l1.TAUX, d1.TAUX)
generate	TAUXD1=D1.TAUX
xtline		TAUXD1, overlay xscale(titlegap(3)) yscale(titlegap(3))
xtline		TAUXD1 if TEMP=="France"
xtset		UNITE ANNEE
generate	TAUXL1=L1.TAUX
scatter		TAUX TAUXL1
regress		TAUX TAUXL1

/* Fusionner une variable provenant de deux bases de donnees : deux enquetes 
	ont code la variable avec des nombres de categories different */
use		"http://www.evens-salies.com/BarometreduNumerique_2007-2017", clear
				//	Note : 336 variables, 24509 observations
generate		INDI=_n
label variable	INDI "id"
rename			annee ANNEE
label variable	ANNEE "Annee de l'enquete"
save			"filetemp", replace
keep			INDI ANNEE REVTOT*
order			INDI ANNEE REVTOT*
rename			REVTOT6 RM6	// REVTOT6 (2007-2009, 2015-2017), 6 categories	
label variable	RM6	"Revenu mensuel du foyer (en euros)"
label define	RM6L	1 "<900" 2 "900-1499" 3 "1500-2299"	4 "2300-3099" ///
						5 "3100+" 6 "Ne sait (repond) pas"	
label values	RM6 RM6L
rename			REVTOT7 RM7	// REVTOT7 (2010-2014), 7 cat, the 6th "4100+"
label variable	RM7 "Revenu mensuel du foyer (en euros)"
replace			RM7=5 if RM7==6 // La cat 4100+ va avec la 3100+
replace			RM7=6 if RM7==7
label values	RM7 RM6L	// Donne les memes etiquettes qu'a REVTOT6
rename			RM6 RM		// Il nous faut qu'une seule variable
replace			RM=RM7 if ANNEE>=2010&ANNEE<=2014
drop			RM7
merge 1:1		INDI using "filetemp.dta"
drop			REVTOT*
