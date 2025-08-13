* statainitiation_0
*	Evens Salies,  09/2018, 09/2019, 09/2020, 09/2021, 09/2024

clear				all
import 			delimited "statainitiation_0_vin.csv", clear

browse

rename				prix P
rename				chais Q

describe
summarize

label variable		P "prix (FF/hl)"
label variable		Q "quantité (hl)"

scatter				P Q

generate			R=P*Q/1000
label variable		R "recette (k FF)"

scatter				R P
scatter				R Q
scatter				R Q, xlabel(0(5000)40000) ylabel(0(5000)20000)

graph matrix		P R Q

* Je n'ai pas toujours besoin de savoir ou Stata sauve les fichiers que je
*	cree avec (donnees, graphiques), mais au cas ou je veux savoir, la commande
*	pwd me renseigne.
pwd

* Je peux changer de chemin :
cd					"C:\Users\evens\Documents"

* Sauve les donnees
save				"statainitiation_0_vin.dta", replace

* Sauve les graphiques (le graphique .gph est en memoire meme si on l'a ferme)
graph save 			"statainitiation_0_graphmatrix.gph", replace

* Attention, pour la commande suivante le graphique .gph doit etre ouvert
graph export 		"statainitiation_0_graphmatrix.png", replace

