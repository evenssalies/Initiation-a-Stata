* Evens SALIES, v1 08/2020, 09/2021, 09/2022, 09/2023
*
* local, global, scalar
*	Distinguer les variables de la fenetre de commande de celles du .do file
*	Sources et pour aller plus loin :
*	 - [U], chapitre Programming Stata, Macros (section 18.3, v. Stata 13)
*	 - https://blog.stata.com/2015/10/27/programing-an-estimation-command- ...
*	   in-stata-where-to-store-your-stuff/
*	 - [P], macro (p. 262, v. Stata 13)


/* Discussion avec une Ã©tudiante */
cls

* Afficher du texte
di		"A"
di		"2*2^8 = 512"

* Calculer, afficher
di		2*2^8

* Stocker, calculer, afficher
scalar	A=2*2^8
di		A

local 	A=2*2^8
di 		`A'				

di		"`A'"			// Les guillemets doubles " " ne servent à rien
di		`"A"'			// Les guillemets simples ` ' ne servent à rien

local 	A=2*2^8
di 		"2*2^8 = " `A'

local 	A="2*2^8"
di 		"`A' = " `A'	// Trés optimisé !

/* STOP */
s

* Executer prg1 dans la fenetre Command
*	prg1
clear all
macro drop _all
local 	I=1
display `I'
capture display	I	// capture n'est pas oblige, mais evite le message d'erreur
* 		I n'existe pas, `I' oui
* Taper
macro list

* Executer prg2 ici [remarque : selectionner les lignes 24 a 29 et Ctrl + D]
*	prg2
macro list
macro drop _all
*		Drop qui n'efface pas les `local' de la fenetre Command
local 		I=1
local		++I
display		`I'

* Executer prg3 dans la fenetre Command
*	prg3
display `I'
*		Le I de la fenetre Command vaut 1, pas 2

* Commentaire :
*	local est une commande locale ! Les variables locales sont perdues quand on
*	 quitte le .do file.
*	La fenetre Command est la fenetre de session interactive.
*	C'est l'etage 0 de Stata. Les programmes dans les fichiers .do et .ado sont
*	aux niveaux 1, 2, etc. Les variables de la feuille de donnees, les matrices,
*	les variables creees avec les commandes global et scalar sont changeables a
*   n'importe quel niveau. Ce sont des "variables globales", contrairement a 
*   celles creees avec local.

* Executer prg4 ici
*	prg4
global		J=1
display		$J
*		Executer la ligne 49 ici et dans la fenetre Command
global		J=$J+1
display		$J
global		K "c d"
display		"$K"
macro list	J K

* Executer prg5 ici
*	prg5
scalar		L=1
scalar		L=L+1
display		L
scalar		M="L+1"
display		M
*		Pas besoin de guillemets simples, mais le pb. de scalar si L est aussi
*		une variable, alors vaut mieux display scalar(L). Par exemple :
set obs 	2
generate	L=3

* Executer ceci dans la fenetre Command (apprendre a manipuler display)
display 	"global: " $J " et " "$K" ", scalar: " L
display		scalar(L)

* Cas particuliers d'usage de local et global
* Executer prg6 ici
*	prg6
cls
clear all
macro drop _all
* Un euro dans E
local		E=6.557 
* "1 euro = 6.557" dans I
local		I "1 euro = `E'"
* Print le contenu de I (I est une chaine)
display		"`I'" 
*		Comme pour global, on met des guillemets car c'est du texte

* Une variante (concatenation) : "1 euro = "+"`E'", mais attention au signe "="
*  (local I = ...) et au "+" qui concatene des string 
local		E=6.557 
local		I = "1 euro = "+"`E'"
display		"`I'"

* Ce qu'il ne faut pas faire ici (deja discute avant)
* La lettre I
display		"I" 
* Le contenu de I est une chaine, pas un nombre
display		`I'
* Des guillemets simples autour en trop
display		`"`I'"'

* Une commande Stata dans une variable locale ; ex. : la commande display
local		CMD "display" 
local		I "<- c'est la commande display"
cls
`CMD' 		"`I'" 

* Une variable dans une variable locale
*	(penser a ouvrir le Data Editor)
* Executer prg7
*	prg7
cls
clear all
macro drop	_all
set obs		10
generate	Y1=1
generate	Y2=Y1+1
local		VAR "Y3"
*		Le nom de la variable
generate	`VAR'=Y1+1

* Concatener une suite de nombres avec local
cls
set more off
macro drop _all
forvalues	F=1/10 {
 local		G = "`G'"+"`F'"
 display	_newline(1) "`G'"		// Une string
 local		H=2*`G'
 display	`H'						// Un nombre (double avec retenue)
}
