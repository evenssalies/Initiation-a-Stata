quietly	log	using "statainitiation_4_5smcl.smcl", replace

/***
4. Spécification et Estimation
==============================

Dans la __section 3__, nous nous sommes intéressés à l'estimation de la 
moyenne, ainsi que de l'erreur-type, dont les formules sont exactes. Il 
s'agissait d'estimations ponctuelles dans le cas univarié. Dans ce cas, il est 
assez intuitif détudier la précision de la statistique estimant le paramètre 
de la loi d'une variable, le paramètre de la superpopulation !

Quand les fonctions des variables sont plus compliquées, que les lois suivies 
par les statistiques ne sont connues, ni exactement, ni pour un $n$ donné, mais 
seulement asymptotiquement, ou que la supposition d'indépendance ne tient pas, 
on peut avoir recours à d'autres méthodes d'estimation avec Stata.

L'estimation dépend largement de la nature des variables (dichotomique, 
discrète, continue), et de la __spécification__ du modèle. Dans le cas multivarié, 
la spécification concerne la forme des relations entre les variables 
(log-linéaire, autorégressive, système d'équations, etc.). 

__[Discuter de la nature des variables]__

Nous verrons la spécification des modèles en mêeme temps que des méthodes 
d'estimation dans les sous-section qui suivent. On se place dans le cadre du 
modèle d'échantillonnage.

4.1 Introduction
----------------
 
L'estimation peut porter sur le paramètre d'une loi. La méthode du __maximum de 
vraissemblance__ (MV) est appropriée dans ce cas. On peut aussi estimer un 
paramètre sans être obligé de supposer une loi, avec, par exemple, la méthode 
des __moindres carrés__, inventée par Gauss-Legendre. 

Nous verrons des problèmes d'estimation ponctuelle dans le cas multivarié, et 
d'estimation par intervalle de confiance, notamment l'estimation bootstrap 
d'un paramètre, qui fonctionne dans les cas univarié et multivarié. Il y a 
aussi la méthode des moments, qui est disponible grâce à la commande __`gmm`__ 
où `gmm' est l'abréviation de _general method of moments_. Nous ferons un petit 
exercice, afin de donner une intuition de la méthode, que vous verrez plus 
amplement dans d'autres cours, notamment l'an prochain.

Nous ne verrons pas l'approche bayésienne de l'estimation d'un paramètre. Avec 
cette approche, on s'enfonce un peu plus dans l'estimation paramétrique, avec 
des hypothèses _a priori_ sur ces paramètres. Par exemple, $\mu$, le moment 
centré d'ordre un d'une variable normale de paramètres $\mu$ et $\sigma^2$, est 
lui-même borné entre $0$ et $1$ selon la loi $U[0,1]$. On peut facilement 
produire des valeurs pour ce type de variable avec Stata, en suivant la 
méthode Monte Carlo comme on l'a déjà vu. Vous pouvez consulter le __Stata 
Bayesian Analysis Reference Manual__ si vous étiez amené.e.s à faire du 
bayésien !

4.2 Maximum de vraisemblance, __`ml`__
--------------------------------------

La commande __`ml`__ est puissante lorsqu'il s'agit d'obtenir un estimateur 
difficile à déduire à la main. La méthode consiste à trouver la forme de la 
statistique qui maximise une fonction des observations, la __fonction de 
vraisemblance__. La méthode est très efficace lorsque le modèle n'est pas 
linéaire par rapport aux paramètres. Un exemple emblématique est celui de 
la __loi logistique__. 

Considérons par exemple le cas d'une variable $Y$ dichotomique, qui suit non 
pas une loi de Bernoulli, mais une loi logistique à valeur dans $\{0,1\}$. Nous 
rentrons doucement dans le cadre multivarié, en supposant que $Pr(Y=1|X=x)$ est 
la fonction de répartition cumulée logistique : 
$$Pr(Y=1|X=x)=\frac{e^{\beta_1+\beta_2 x}}{1+e^{\beta1+\beta_2 x}}\equiv 
\Lambda(x,\mathbf{\beta}).$$

$\Lambda(x,\mathbf{\beta})$ ne comporte que deux paramètres, mais étant 
non-linéaire par rapport à ces derniers, les conditions de premier ordre sont 
compliquées. Comme on peut le voir, la probabilité que $Y$ se réalise est une 
fonction croissante de $x$ et tend vers 0 quand $x$ tend vers $-\infty$. Et, 
$ln(P/(1-P))=\beta_1+\beta_2 x$ est une fonction linéaire de 
$\mathbf{\beta}$. Le ratio $P/(1-P)$ s'appelle __ratio de chance__, et le 
logarithme (népérien) de ce ratio s'appelle __fonction logit__. Cette fonction 
intervient lors de la recherche de l'estimateur du MV.

Supposons un échantillon aléatoire. La loi jointe de $\mathbf{y}$ se note 
généralement $L(\mathbf{y}|\mathbf{\beta})$. L'écriture de la fonction de 
vraissemblance de léchantillon "renverse" le conditionnement, 
$L(\mathbf{\beta}|\mathbf{y})$ pour indiquer que c'est $\mathbf{\beta}$ qui 
varie, $\mathbf{y}$ est donné. Le problème est alors le suivant :
$$\hat{\mathbf{\beta}}=
argmax_{\mathbf{\beta}}\{L(\mathbf{\beta}|\mathbf{y}}\}.$$ Notons 
$Pr(Y_i=1|X_i=x_i)\equiv p_i(x_i)$. La vraissemblance s'écrit :
 $$L(\mathbf{\beta}|\mathbf{y}=
 \Pi_{i=1}^n p_i(x_i)^{y_i}(1-p_i(x_i))^{1-y_i}.$$
 
Faisons un petit détour par la loi de Bernoulli. Pour cela, supposons que $p_i$ 
ne varie pas avec $i$ ($\beta_1\equiv 0$ et $x_i\equiv 1\ \forall i$). Dans ce 
cas, on a $\Lambda(x,\mathbf{\beta})=e^{\beta_2}/(1+e^{\beta_2})\equiv p$. 
Notons que si je connais $\beta_2$, je connais $p$, est _vice-versa_. Que 
devient la vraissemblance dans ce cas ? 

Depuis Fisher, inventeur de la méthode, on s'intéresse à la log-vraissemblance, 
$ln(L(p|\mathbf{y}))$, que l'on note $l(p|\mathbf{y})$. Nous avons :
 $$l(p|\mathbf{y})=\sum_{i\le^n}(y_i ln(p)+(1-y_i)ln(1-p))$$
 $$=ln(p)n\bar{y}+ln(1-p)n(1-\bar{y}).$$ L'estimateur du MV est simple dans ce 
 cas : $\hat{p}=\bar{y}$.
 
On peut utiliser la commande __`ml`__, que l'on peut appliquer à l'estimation 
du paramètre d'une variable aléatoire qui suit une loi logistique, de Poisson, 
etc. On peut très bien utiliser la commande __`logit`__, mais aussi __`ml`__, 
ou encore utiliser __Mata__ pour aller encore plus dans les aspects techniques 
(nous avons fait un petit programme qui résout les équations non-linéaires 
induites par la maximisation de la vraisemblance).
***/

cls
clear	all
use		"http://www.stata-press.com/data/r13/repair", clear

* repair : niveau de reparation de la voiture
* foreign : est-ce que le vehicule est etranger
set more off

* L'estimation du logit avec Y {0,1} et X {1,2,3}
keep		foreign repair

* Option cell pour les frequences relatives
tabulate	foreign repair, cell

logit		foreign	repair if repair!=1

logit		foreign	repair, or
margins		, dydx(repair) at(repair==2)

* Probabilite d'un resultat positif
predict		FOREIGNP, pr
sort		repair FOREIGNP

/***
On peut reestimer le logit avec la troisieme valeur de la variable 
__`repair`__ en groupe de base
***/

* baselevels affiche le grp de base
logit foreign ib3.repair, or baselevels

* C'est equivalent a saturer le modele
tabulate repair, generate(repair_d)

* Option odd ratio
logit foreign repair_d1 repair_d2, or

* La commande ml passe par l'execution d'un programme
program MYLOGIT
 version 13
 args lnf THETA
 quietly: replace `lnf' = -ln(1+exp(-`THETA')) if $ML_y1==1
 quietly: replace `lnf' = -`THETA' - ln(1+exp(-`THETA')) if $ML_y1==0
end
ml model lf MYLOGIT (foreign = repair)
ml maximize

/***
Nous allons maintenant résoudre le systeme de deux equations non-lineaires 
en $\beta_1$ et $\beta_2$ dans __Mata__.
***/

clear	all
use		"http://www.stata-press.com/data/r13/repair", clear
set more off
keep		foreign repair
logit		foreign	repair
predict		FOREIGNP, pr

table foreign FOREIGNP if repair==1, nototals //, cellwidth(10) in Stata 13
table foreign FOREIGNP if repair==2, nototals
table foreign FOREIGNP if repair==3, nototals

* MATA
mata:
 void function myfun2(real colvector x, real colvector values)
  {
  values[1] = 	-10*exp(x[1]+x[2])/(1+exp(x[1]+x[2])) - ///
				30*exp(x[1]+2*x[2])/(1+exp(x[1]+2*x[2])) - ///
				18*exp(x[1]+3*x[2])/(1+exp(x[1]+3*x[2])) + 12 
  values[2] = 	-10*exp(x[1]+x[2])/(1+exp(x[1]+x[2])) - ///
				60*exp(x[1]+2*x[2])/(1+exp(x[1]+2*x[2])) - ///
				54*exp(x[1]+3*x[2])/(1+exp(x[1]+3*x[2])) + 33 
  }
 S = solvenl_init()
 solvenl_init_evaluator(S, &myfun2())
 solvenl_init_type(S, "zero")
 solvenl_init_technique(S, "newton")
 solvenl_init_numeq(S, 2)
 solvenl_init_startingvals(S, J(2,1,0))
 solvenl_init_iter_log(S, "on")
 x = solvenl_solve(S)
x
end
 
/***
Notons que nous pourrions estimer le modèle Probit de la même manière, ainsi
que d'autres modèles à variable dépendante qualitative, tels que le modèle de 
Poisson, ou une généralisation de la fonction logistique, avec le modèle 
multinomial.
 
4.2 Moindres carrés, __`regress`__
----------------------------------

Dans le cas univarié, la méthode des moindres carrés (MC) permet de trouver une 
estimation du moment centré d'ordre 1 d'une variable qui minimise sa variance : 
$$\mu^{MC}\equiv argmin_{\mu}n^{-1}\sum_i(y_i-\mu)^2.$$ 
On la retrouve en économétrie où la moyenne est en fait l'espérance 
conditionnelle à une ou plusieurs autre variables, $\mu\equiv 
E(Y_i|X_1,X_2,\ldots,X_K)=\beta_1 X_1+\cdots\beta_K X_K.$

La commande __`regress`__ de __Stata__ gère ces deux situations sans problème. 
Dans le premier cas, il suffit de faire une régression de $Y$ sur une 
constante, en tapant tout simplement __`regress Y`__. Dans le second cas, une 
régression sur les différentes variables, par exemple $X_1$ et $X_2$ : 
__`regress Y X1 X2 ... X3`__

Les justifications de la méthode sont dans tous les livres d'économétrie, dont 
les deux plus fameux (Wooldridge, 2010, et Greene, 2014). Ses inconvénients 
sont aussi dans ces livres, ainsi que dans ceux sur l'__apprentissage 
automatique__. On peut sans difficulté utiliser __Stata__ pour calculer les 
coefficients d'un modèle en manipulant les matrices.
***/

cls
use	"http://www.evens-salies.com/rubin1977.dta", clear
rename 		(GROUP POSY PREX)(D Y X)
regress 	Y D X

generate 	ONE=1
mkmat 		ONE D X, matrix(X)
mkmat 		Y, matrix(Y)
matrix 		B=invsym(X'*X)*X'*Y
matrix list B

/***
Dans le cas du modèle linéaire simple, il y a un lien fort avec le coefficient 
de corrélation de pearson, le fameux $\rho$. Les résultats de __`regress`__ne 
renvoient pas les coefficients de correlation de Spearman, tetrachorique (dans 
le cas de deux variables dichotomiques) car, par définition, la regression est 
pour des variables continues. La statistique $R^2$ affichée, après avoir 
exécuté la commande, est le coefficient de Pearson au carré.

4.3 Estimation bootstrap, __`bootstrap`__
-----------------------------------------

Le bootstrap est au départ une méthode d'inférence. Avant de voir un exemple 
sur des données d'observation, examinons le cas simpliste d'un échantillon 
aléatoire ayant la même taille que la population, parce que la population est 
de petite taille par exemple ($N=3$, $n\equiv N$). Nous allons introduire la 
commande __`bootstrap`__ dans ce cas. Nous allons produire 1000 échantillons 
bootstrap, sachant très bien qu'il n'y en a que 10 échantillons distincts.
 
En effet, à partir de $\mathcal{S}=\{1,2,3\}$, on a les échantillons suivants : 
$\{1,1,1\}$, $\{2,2,2\}$, $\{3,3,3\}$, $\{1,1,2\}$, $\{2,2,1\}$, $\{1,1,3\}$, 
$\{3,3,1\}$, $\{2,2,3\}$, $\{3,3,2\}$, $\{1,2,3\}$. Supposons que les valeurs 
de la variable aléatoire soient $y_1=2$, $y_2=1$ et $y_3=3$. Il y a sept 
sommes, et donc sept moyennes différentes.

Ces 10 échantillons donnent les moyennes suivantes : $\frac{2+2+2}{3}=2$, 
$\frac{1+1+1}{3}=1$, $\ldots$, $\frac{2+2+3}{3}=7/3$ ou $\frac{3+3+1}{3}=7/3$, 
$\frac{3+3+2}{3}=8/3$. Vous pourrez vérifier qu'il y a sept moyennes 
différentes. Pour connaître la proportion de chaque moyenne, il faut revenir au 
nombre déchantillons possibles : $3^3=27$. Les différentes moyennes avec leur 
fréquence relative théorique entre parenthèses, sont les suivantes : 
$3/3=1 (1/27)$ (l'échantillon $\{2,2,2\}$), $4/3=1,33\ldots (3/27)$ (les 
échantillons $\{1,2,2\}$, $\{2,1,2\}$, $\{2,2,1\}$), $5/3=1,66\ldots (6/27)$ 
(les échantillons $\{1,1,2\}$, $\{1,2,1\}$, $\{2,1,1\}$, $\{2,2,3\}$, 
$\{2,3,2\}$, $\{3,2,2\}$), ..., $9/3=3 (1/27)$ (l'échantillon $\{3,3,3\}$).

Mais on peut aussi tout simplement ajouter les sept sommes différentes que 
nous avons trouvées, ce qui donne 42, puis diviser cette somme par 7 et par 3. 
Le résulat vaut 2.

***/

set seed	21041971
clear all
set	obs 	3
input int Y
2
1
3
*cls
list
generate	MEAN=.
bootstrap	MEAN=r(mean), ///
 size(3) reps(1000) saving(bootstrap123, replace) mse: summarize Y

* Look at the file content
use 			"C:\Users\evens\Documents\bootstrap123.dta", clear 
generate 		ONE=1
collapse (sum) 	ONE, by(MEAN)
summarize		ONE
generate 		ONEP=100*ONE/r(sum)
browse

/***
La commande __`bootstrap`__ a pour argument le nom de la variable dans laquelle 
on va mettre la statistique qui nous intéresse. Ici, c'est la variable 
__`MEAN`__. Cette variable contiendra une statistique post-commande, 
__`r(mean)`__ calculée par __`summarize`__.

Il y a 1000 TAR, et les 1000 moyennes sont placées dans le fichier de données 
__bootstrap123.dta__ dans votre dossier de travail. Après la commande 
__`bootstrap`__, le programme calcule la fréquence relative de chaque moyenne.
 
La commande calcule un intervalle de confiance bootstrap de la moyenne, à 
partir d'une erreur standard. La question est de savoir laquelle. 

Prenons un exemple de 23 capitalisations boursières dans le secteur mondial 
du numérique. Chacune des 23 capitalisations est la réalisation d'une variable 
aléatoire dont on ne connait pas la loi sous-jacente. Dans ce cas, le 
__bootstrap non-paramétrique__ peut être utilisé, en appliquant un 
re-échantillonnage basé sur toutes les observations. Si $n=23$ est la taille 
de l'échantillon, on crée un certains nombre d'échantillon bootstrap de $23$ 
observations chacun ; le nombre d'échantillons possibles (non-distincts) est 
$23^{23}$, c'est énorme !
 
Le programme suivant calcule l'intervalle de confiance de la moyenne des 
capitalisations. Nous allons nous contenter de tirer 100 échantillons. Vous 
pouvez ensuite essayer de voir quel est le résultat obtenu avec 500. Plutôt 
que de placer les fréquences relatives des différentes moyennes dans la feuille 
de données, on va faire un histogramme de ces moyennes avec la commande 
__`hist MEAN`__.
***/

use	"http://www.evens-salies.com/statainitiation_3_capitalisation.dta", clear	
rename		(var*)(CAP STR TEMP)
encode		TEMP, generate(NOM)
drop		TEMP
set seed	21041971
bootstrap	MEAN=r(mean), size(23) reps(1000) ///
 saving(bootstrap_capitalisation, replace) nowarn mse: summarize CAP

preserve
 use		"bootstrap_capitalisation.dta", clear
 hist		MEAN
restore
 
/***
Nous n'avons pas utilisé l'information capturée par la variable de 
stratification. Si l'on pense que la moyenne varie d'une strate à l'autre, de 
sorte que $Y_{is}=\mu_s+U_i$ est le modèle pertinant, avec par exemple 
$U_i\sim i.i.d.$ (la valeur de $Y_{is}$ est déterminée par un PGD inconnu).

On peut combiner __`regress`__ avec l'option __`bootstrap`__ pour l'estimation 
de l'erreur-type du coefficient d'un modèle de régression. Dans l'exemple 
ci-dessous, le coefficient est unique, c'est la constante dans une modèle de 
régression (il n'y a pas de variable explicative autre que la constante). On 
sait que dans ce cas, l'estimateur de la constante est la capitalisation 
moyenne.
***/

use	"http://www.evens-salies.com/statainitiation_3_capitalisation.dta", clear	
rename			(var*)(CAP STR TEMP)
encode			TEMP, generate(NOM)
drop			TEMP
order			NOM
sort			NOM
save			"statainitiation_3_capitalisation_final.dta", replace
set seed		21041971

regress			CAP, vce(bootstrap)	// Dans ce cas, s.e. sert a construire IC

matrix list 	e(b)
matrix list 	e(V)			// S^2/23
matrix define	B=J(1,1,0)
matrix define	V=J(1,1,0)
matrix define	B[1,1]=e(b)
matrix define	V[1,1]=e(V)
local 			B=B[1,1]
local			SE=V[1,1]^.5
local			ICL=`B'-invnormal(0.975)*`SE'
di				`ICL'

/***
On peut vérifier avec __`summarize`__ CAP que l'unique coefficient estimé est 
bien la moyenne de la variable. L'avantage de __`regress`__ est que nous avons 
au passage une estimation d'un intervalle de confiance pour la moyenne. Dans le 
cas d'un re-échantillonnage, l'estimateur bootstrap de l'erreur standard, qui 
vaut 62.11 dans mon cas, sert à calculer l'intervalle de confiance au seuil de
5 %, comme on peut le vérifier : 
$$254.95\pm 1,96\times 62,11 \Leftrightarrow 254.95\pm 121,75 \Leftrightarrow
 [133,20 ; 376,70].$$
  
Vous verrez des méthodes plus compliquées cette année ou l'an prochain. Je 
pense par exemple à la méthode des moments généralisés, avec la commande 
__`gmm`__. Je vous conseille de revoir cette méthode dans le cas univarié, le 
cas "simple" par opposition à "généralisé" qui est le cadre dans lequel cette 
commande a été créée). 
 
Il y a un estimateur connu en économétrie qui s'appuie dessus. C'est celui 
d'Arellano et Bond, pour l'estimation des coefficients d'un modèle dynamique 
sur données de panel. Des informations sur l'application de la méthode dans le 
cas de petits échantillons sont disponibles dans Drukker (2010).
***/

/***
Bibliographie
=============

Drukker, D.M. 2010. An introduction to GMM estimation using Stata (slides). 
In German Stata Users' Group.
***/ 

quietly log close

/* Exécuter depuis la fenêtre de résultat

markdoc "statainitiation_4_5smcl.smcl", export(docx) replace

*/
