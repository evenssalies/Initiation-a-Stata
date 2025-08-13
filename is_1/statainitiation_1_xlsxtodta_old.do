**	Evens SALIES, v1. 05/09/2019, v2. 06/09/2020
*		Je remercie Adam SEBTI pour la commande reshape
* 	"statainitiation_1_xlsxtodta.do", disponible a http://www.evens-salies.com/
*
*	Convertit la feuille d'un doc. Excel .xlsx en fichier de donnees Stata .dta
*	Illustration : taux d'impot sur les societes. Source : OECD tax database,
*		http://www.oecd.org/tax/tax-policy/tax-database.htm#C_CorporateCapital
*	
** 

set more off				// Execute le prg sans interruption 
clear		all
import		excel "http://www.evens-salies.com/2018_TauxStatutaireOCDE.xlsx"
cd			"C:\Users\evens\Documents\"			// Dossier de travail Stata

describe					// Noms des colonnes/variables, A, B, ..., T
drop		in 1			// Vire ligne des annees
drop		if _n>=_N-5		// Vire les 5 dernieres lignes
destring	B-T, replace	// Convertit les strings en valeurs
describe	, short			// Pour recuperer le nb. de pays et d'annees
local		T=r(k)-1	// `-1' car la variable A est noms des pays
local		I=r(N)		// Nombre d'unites d'observations (pays)
						
* Note : la commande xpose plus loin supprimera les noms des pays, variable A
* Créer un panel à partir de "A", qui sera fusionné avec celui des taux d'IS
preserve
 keep		A					// La variable A est une cle (string)
 * sort		A					// Pas la paine, pays deja tries
 
 * Parametres pour empiler les donnees
 local		T=`T'+1				// expand T, ... fait T-1 copies, j'en veux T
								// 	donc ajoute 1 a T
 expand 	`T', generate(COPY)	// Cree T copies
 local		T=`T'-1				// Redonne a T sa bonne valeur
 drop if	COPY==0				// Vire les obs. de depart
 drop		COPY
 rename		A UNITE
 generate	ANNEE=0				// Commence par remplir les annees avec 0
 local		N=`T'*`I'
 forvalues	OBS=1(1)`N' {
  replace	ANNEE=mod(`OBS'-1,`T') in `OBS' //  Ajoute le nombre de l'année
 }
 replace	ANNEE=ANNEE+2000	// Annee de depart du panel supposee connue !!!
 generate	CLE=_n				// Clé de fusion
 save		"filetemp.dta", replace
restore

* Transpose pour mettre les années en ligne avant de les empiler
xpose		, clear	// Rq : les noms des pays/variables v1 ... v36
drop		in 1	// Vire la 1ère ligne (c'etait la variable A)

* Empile les annees et colle le fichier des codes et des annees
stack		v*, into(TAUX)
drop		_stack
generate	CLE=_n

* Fusionne le panel de la variable TAUX avec celui de UNITE-ANNEE  
merge 1:1	CLE using "filetemp.dta"
drop		CLE _merge
order		UNITE ANNEE
save		"statainitiation_1_corporatetaxrates.dta", replace
