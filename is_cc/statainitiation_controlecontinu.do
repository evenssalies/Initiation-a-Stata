* Exercice xx
clear all
set obs 3
input int Y
2 ;
3 ;
1 ;

gsort 			-Y
generate		Z=Y
label define 	ZL 3 "Non-binaire" 2 "Binaire" 1 "Binaire"
label values	Z ZL

* Exercice xx
use			"http://www.evens-salies.com/switch_probit_example.dta", clear
tabulate	works migrant, cell
display		215/1694

logit		works migrant
* pente
* 	di log((3.96/14.54)/(27.26/54.24))
* constante
*	di log(14.54/54.24)

su 			works if migrant==1
su 			works if migrant==0
regress		works migrant
