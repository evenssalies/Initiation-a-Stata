sort			TAUX
generate		TAUXCAT=recode(TAUX, 10,20,30,40,50)
tabulate		TAUXCAT
label define 	TAUXCATLABEL 10  "]0,10]" 20 "]10,20]" 30 "]20,30]" ///
							 40 "]30,40]" 50 "]40,50]"
label values	TAUXCAT TAUXCATLABEL
label variable	TAUXCAT "Intervalle de classe du taux d'imposition"
tabulate		TAUXCAT
hist 			TAUXCAT, xlabel(10  "0" 20 "10" 30 "20" 40 "30" ///
								50 "40" 60 "50") width(10) percent
