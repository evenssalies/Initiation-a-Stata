/* version 13.1, 09/2019, 09/2020, 09/2021, 09/2022
 Differences entre table, tabulate, tabstat, et valeurs manquantes */

clear 		all
cd			"C:\Users\evens\Documents"	// Mon chemin
set			obs 7

input 		str1 U int A int Y
"a" 1 1
"a" 2 6
"b" 1 6
"b" 2 .
" " 1 1
"b" 3 4
"c" 1 .

save		"tableau.dta", replace
br
cls

/* table
	Frequences	*/
table		U							// missing est inutile car U est une
										// string, un blanc n'est pas un missing
table		U, missing					// La preuve
table		U, row

table		Y, missing					// les Y manquants sont ignores
table		U, content(n Y) row			// La preuve

/*	Autres statistiques : enfin, l'option m sert a quelque chose */
table		U, content(mean Y n Y) row		// row somme les moy. si poss. 
table		U, content(mean Y n Y) m row	// m montre avec "." qu'il n'y a
											// rien a calculer
table		U, content(sd Y) m				// A cause du n-1 dans s^2, le
											// calcul est impossible pour U3

/* tabulate		*/
cls
tabulate	Y
tabulate	Y, m
display		r(N)				// tabulate stocke le # de non-missing

/* tabstat 		*/
cls
tabstat		Y, statistics(mean n) by(U)

/* Reamarques
	Equivalence entre tabstat et table ... */
tabstat		Y, statistics(mean n) by(U)
table		U, content(mean Y n Y) m row

/*	tabulate : par frequences decrosisantes */
tabulate	Y, sort
