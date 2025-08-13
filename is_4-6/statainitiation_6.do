\newpage
\begin{flushleft}
\textbf{5. Test}
\end{flushleft}

La m\'ethode du Maximum de Vraisemblance d\'ebouche naturellement sur le test
 du ratio de vraisemblance.\footnote{Il existe \'egalement un test du
 multiplicateur de Lagrange, que nous ne verrons pas dans cette section.} Nous
 nous int\'eressons principalement aux tests de specification. Les tests de
 diagnostic (normalit\'e, autocorr\'elation, ...) seront simplement discut\'es.
 L'application suivante vise \`a tester la nullit\'e du param\`etre de
 centralit\'e d'une variable normalement distribu\'ee.  

\large
\begin{flushleft}
\textbf{5.1 Test du ratio de vraissemblance \ttfamily lrtest\normalfont}
\end{flushleft}

Apr\`es avoir estim\'e un mod\`ele en maximisant la vraisemblance, on peut
 utiliser le test du ratio de vraisemblance. La statistique de test suit un
 $\chi^2$. La d\'emonstration est relativement facile.

\bigskip
\begin{center}
\textbf{[Exposer la th\'eorie]}
\end{center}
\bigskip
***/

cls
clear all
set obs 1000
set seed 3102019

* H0 (Y~N(0,sigma)) against H1 (Y~N(mu,sigma)), the test will be at the 5% level
* Data : N(0,1), the model under H0
generate Y=rnormal(0,1)
* Manual computation of the likelihood ratio test statistic -2(l0-l1)
summarize Y
display r(N)*(r(mean)/r(sd))^2

* Unrestricted model model M1, restricted model M0
mlexp (-ln({sigma})-(0.5/{sigma}^2)*Y^2)
estimate store M0
mlexp (-ln({sigma})-(0.5/{sigma}^2)*(Y-{mu})^2)
estimate store M1
lrtest M0 M1

/***
L'interpr\'etation des r\'esultats est la suivante. Nous trouvons 2,96 pour
 la valeur de la statistique (Stata calcule aussi la p-valeur du test, et trouve
 0,085, qui est donc la probabilit\'e qu'une variable suivant une loi du
 $\chi^2$ \`a 1 degr\'e de libert\'e soit plus grande que 2,96). En conclusion,
 au seuil de 5\%, 0,085 est trop grand, aussi Stata dit que M0 est contenu
 dans M1 (M0 est un sous-mod\`ele de M1). Par cons\'equent, je ne rejette pas
 H0 au seuil de 5\%. La vraisemblance avec M1 ($l_1$) ne sera pas plus grande
 que celle avec M0 ($l_0$) puisque M1 est le mod\`ele `faux', \'etant donn\'e 
 les observations disponibles, bien qu'il ne soit pas si mauvais (en effet, une
 p-valeur de 8,5\% n'est pas si mauvais). Si nous avions opt\'e pour un seuil
 de 10\%, nous aurions rejet\'e H0 en faveur de H1 (l mod\`ele non-contraint).

\newpage
\begin{flushleft}
\textbf{5.2 Test de Wald \ttfamily ttest\normalfont}
\end{flushleft}

La commande \ttfamily \textbf{ttest}\ \normalfont est tr\`es facile \`a utiliser
 sur une variable, pour tester une hypoth\`ese sur sa moyenne. Mais aussi sur
 l'\'egalit\'e des moyennes de deux variables. Ces tests, qui figurent dans tous
 les livres de statistiques, sont simplement d\'ecrits dans le petit
 dictionnaire de Nelson (2004, p. 95), qui s'av\`ere tr\`es utile lorsque l'on
 veut s'informer vite et bien sur des m\'ethodes
 statistiques.\footnote{\hspace{1.5pt} Nelson, D. 2004. \textit{The Penguin
 Dictionary of Statistics}. Penguin Books.} 

La famille des tests de Wald revient \`a imposer une contrainte lin\'eaire dans
 un mod\`ele de r\'egression. Lorsqu'il s'agit d'une hypoth\`ese simple, la
 statistique de test est celle de Student, et lorsqu'il s'agit d'une hypoth\`ese
 composite (au moins deux coefficients), c'est la statistique de Fisher. Nous
 allons nous pencher sur le test d'\'egalit\'e de moyennes, probl\`eme que
 l'on appelle de Bierens-Fisher. En g\'en\'eral, on ne teste pas l'\'egalit\'e
 des moyennes de deux sous-populations sans se poser la question de
 l\'egalit\'e des variances.
***/

use "http://www.evens-salies.com/urgence.dta", clear
table phstat phospyr
keep if phstat<=5 & phospy<=2
table phstat phospyr
generate HEALTH=6-phstat
generate GROUP=phospy
replace GROUP=0 if GROUP==2
by GROUP, sort: summarize HEALTH
ttest HEALTH, by(GROUP) unequal
ttest HEALTH, by(GROUP)
* A la main
summarize	HEALTH if GROUP==1
scalar		N1=r(N)
scalar		M1=r(mean)
scalar		V1=r(Var)
summarize	HEALTH if GROUP==0
scalar		N0=r(N)
scalar		M0=r(mean)
scalar		V0=r(Var)
scalar		STNUM=M1-M0
scalar		STDEN1=(1/N1+1/N0)^0.5
scalar		STDEN2=(((N1-1)*V1+(N0-1)*V0)/(N1+N0-2))^0.5
scalar		ST=STNUM/(STDEN1*STDEN2)
quietly {
 noisily display		"La statistique de test vaut " ST
 }
*

/***
* anova (ANOVA and treatment effects), Chi square test of independence
\newpage
\begin{flushleft}\textbf{5.3} \ttfamily oneway\ \normalfont
 (test d'\'egalit\'e de deux moyennes ou plus)
\end{flushleft}

En fait, \`a partir de trois moyennes (supposons que nous ayons trois groupes),
 on peut utiliser la commande \ttfamily \textbf{regress}\normalfont. Nous
 reverrons cela dans le cours de m\'ethodes statistiques d'\'evaluation de M2. 

Dans l'exemple pr\'ec\'edent, nous n'avons que deux groupes : soit la personne
 s'est rendue aux urgences, soit pas (rappelons qu'il s'agit de d\'eclarations).
 On retrouve la statistique $F$ du test de Wald en haut \`a droite de la
 r\'egression. \`A vous de voir quelle approche vous souhaitez utiliser !

Nous verrons ensuite un deuxi\`eme exemple d'application du tests de Wald dans le
 cas o\`u nous avons 3 groupes.

***/

oneway HEALTH GROUP, tabulate
regress HEALTH GROUP

* STAR Experiment (3 groupes), variable Free lunch
use "http://www.evens-salies.com/webstar.dta", clear
* 	ANOVA
keep sesk cltypek
drop if sesk==.
rename sesk FL
rename cltypek GROUP
replace	FL=2-FL
oneway FL GROUP, tabulate

* 	Regression
tabulate GROUP, generate(GROUP_)
regress FL GROUP_*

quietly log close