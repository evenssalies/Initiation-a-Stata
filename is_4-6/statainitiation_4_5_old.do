quietly	log	using "statainitiation_4smcl.smcl", replace

/***
4. Méthodes d'estimation
========================

L'estimation dépend largement de la nature des variables (dichotomique, 
 discrète, continue), et de la spécification du modèle, c'est-à-dire de la 
 forme des relations entre ces variables (log-linéaire, autorégressive, 
 système d'équations, etc.). C'est la raison pour laquelle nous allons voir la 
 spécification des modèles en même temps que les méthodes d'estimation dans 
 cette section.

On se place dans le cadre du mod\`ele d'\'echantillonnage.

4.1 Introduction : des méthodes d'estimation
--------------------------------------------

Dans la __Section 3__, nous nous sommes intéressés à l'estimation de la moyenne 
 d'une variable aléatoire, et de sa précision, l'erreur type. Les formules sont
 exactes : $\bar{X}$, $V(\bar{X})=\sigma^2/N$. C'est le cas univarié,  
 les estimations sont ponctuelles, la variable continue. L'estimation de 
 l'erreur type dans ce cas, $\sigma/\sqrt{N}$, dépend du paramètre de la loi de
 la variable, $V(X_i)=\sigma^2$, dans un modèle d'échantillonnage.
 
Quand les fonctions des variables sont plus compliquées, que les statistiques
 ne sont pas aussi naturelles que $\bar{X}$, que la supposition d'indépendance
 des $X_i$ ne tient pas, on peut avoir recours à d'autres estimateurs que la
 moyenne, et d'autres méthodes d'estimation.

L'estimation peut porter sur le paramètre d'une loi. La __méthode du maximum
 de vraissemblance__ (MV) est appropriée dans ce cas. On peut aussi estimer un
 paramètre sans être obligé de supposer une loi, avec, par exemple, la
 méthode des moindres carrés, inventée par Gauss.
  
Nous verrons des problèmes d'estimation ponctuelle dans le cas multivarié,
 et d'estimation par intervalle de confiance, notamment l'__estimation 
 bootstrap__ des coefficients d'une modèle de régression, que l'on a déjà vue 
 pour le cas univarié.
 
 Il y a aussi la __méthode des moments__, qui est disponible grâce à la commande
 __`gmm`__, où "gmm" est l'abréviation de _General Method of Moments_. Nous 
 ferons un petit exercice, afin de donner une intuition de la méthode, que vous
 verrez plus amplement dans d'autres cours, notamment l'an prochain.

Nous ne verrons pas l'approche bayésienne de l'estimation des paramètres d'un
 modèle. Avec cette approche, profondément paramétrique, avec 
 des hypothèses _a priori_ sur ces paramètres. Il faudrait comprendre d'abord
 l'approche dans le cas univarié. Très brièvement, selon cette approche, le
 paramètre $\mu$ d'une variable normale de paramètres $\mu$ et $\sigma^2$, est
 lui-même borné entre $a$ et $b$ selon la loi _a priori_ $U[a,b]$. On peut 
 facilement produire des valeurs pour ce type de variable avec la m\'ethode 
 Monte Carlo de Stata, que l'on a vue dans la __Section 2__. C'est plus facile que de
 faire le calcul analytique. Vous pouvez consulter le 
__`Stata Bayesian Analysis Reference Manual`__
 
4.2 Maximum de vraisemblance, __`ml`__
--------------------------------

La commande \ttfamily \textbf{ml}\normalfont\ est puissante lorsqu'il s'agit
 d'estimer un param\`etre difficilement calculable \`a la main. La m\'ethode
 consiste \`a trouver la forme de la statistique qui maximise une fonction des
 observations, la \fbox{fonction de vraisemblance}. Un exemple embl\'ematique
 est celui de la \fbox{loi logistique}. La m\'ethode est tr\`es efficace lorsque
 le mod\`ele n'est pas lin\'eaire. 
Consid\'erons par exemple le cas d'une variable $Y$ dichotomique, qui suit non
 pas une loi de Bernoulli, mais une loi logistique \`a 
 valeur dans $\{0,1\}$. Nous rentrons doucement dans le cadre multivari\'e, en
 supposant que $\textnormal{Pr}(Y=1|X=x)$ est la fonction de r\'epartition
 cumul\'ee logistique : 
 $$\textnormal{Pr}(Y=1|X=x)=\frac{e^{\beta x}}{1+e^{\beta x}}.$$
 $F(x,\beta)$ ne comporte qu'un param\`etre, mais \'etant non-lin\'eaire, la
 vraisemblance sera aussi compliqu\'ee que si nous avions consid\'er\'e
 $Y\sim N(\cdot,\cdot)$. Comme on peut le voir, la probabilit\'e
 que $Y$ se r\'ealise est une fonction croissante de $x$ et tend vers 0 quand
 $x$ tend vers $-\infty$. Et, $\textnormal{ln}(P/(1-P))=\beta x$ est une 
 fonction lin\'eaire de $\beta$. Le ratio $P/(1-P)$ s'appelle 
 \fbox{ratio de chance}, et le logarithme (n\'ep\'erien) de ce ratio s'appelle
 \fbox{fonction logit}. Cette fonction intervient lors de la recherche de
 l'estimateur du MV.

Supposons un \'echantillon al\'eatoire. La loi jointe de {\boldmath$y$} se note
 g\'en\'eralement $L(${\boldmath$y$}$|\beta)$. L'\'ecriture de la fonction de
 vraissemblance de l'\'echantillon ``renverse'' le conditionnement, 
 $L(\beta|\textit{\textbf{y}})$ pour indiquer que c'est $\beta$ qui varie,
 $\textit{\textbf{y}}$ est donn\'e. Le probl\`eme est alors le suivant :
 $$\hat{\beta}=\textnormal{argmax}_{\beta}\{L(\beta|\textit{\textbf{y}})\}.$$
 Notons $P(Y_i=1|X_i=x_i)\equiv p_i(x_i)$. 
 La vraissemblance s'\'ecrit :
 $$L(\beta|\textit{\textbf{y}})=
 \Pi_{i=1}^n p_i(x_i)^{y_i}(1-p_i(x_i))^{1-y_i}.$$
 
Faisons un petit d\'etour par la loi de Bernoulli. Pour cela, supposons que
 $p_i$ ne varie pas avec $i$ ($x_i\equiv 1\ \forall i$ par exemple).
 Dans ce cas, on peut \'ecrire $e^{\beta x_i}/(1+e^{\beta x_i})=
 e^\beta/(1+e^\beta)\equiv p$. Autrement dit, si je connais $\beta$, je connais
 $p$, est \textit{vice-versa}. Que devient la vraissemblance dans ce cas ? 

Depuis Fisher, inventeur de la 
 m\'ethode, on s'int\'eresse \`a la log-vraissemblance, 
 $\textnormal{ln}(L(p|\textit{\textbf{y}}))$, que l'on note 
 $l(p|\textit{\textbf{y}}))$. Nous avons :
 $$\begin{array}{rcl}
 l(p|\textit{\textbf{y}}) & = & 
 \sum_{i=1}^n (y_i\textnormal{ln}(p)+(1-y_i)\textnormal{ln}(1-p) \\
 & = &  \textnormal{ln}(p)n\bar{y}+\textnormal{ln}(1-p)n(1-\bar{y}). \\
 \end{array}$$
 L'estimateur du MV est simple dans ce cas, $\hat{p}=\bar{y}$.
 
On peut utiliser la commande \textbf{ml}, que l'on peut appliquer \`a
 l'estimation du param\`etre d'une variable al\'eatoire qui suit une loi
 logistique, de Poisson. On peut tr\`es bien utiliser la commande
 \ttfamily \textbf{logit}\normalfont, mais aussi \ttfamily \textbf{ml} 
 \normalfont, ou encore utiliser \ttfamily \textbf{mata}\ \normalfont pour
 aller encore plus dans les aspects techniques (nous avons fait un petit
 programme qui r\'esout les \'equations non-lin\'eaires induites par la
 maximisation de la vraisemblance).
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
logit		foreign	repair
logit		foreign	repair, or
margins		, dydx(repair) at(repair==2)
* Probabilite d'un resultat positif
predict		FOREIGNP, pr
sort		repair FOREIGNP

/***
On peut reestimer le logit avec la troisieme valeur de la variable 
 \textbf{repair} en groupe de base
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
Nous allons maintenant r\'esoudre le systeme de deux equations non-lineaires
 en $\beta_1$ et $\beta_2$ dans \ttfamily \textbf{MATA}.\normalfont
***/

table foreign FOREIGNP if repair==1 // , cellwidth(10)
table foreign FOREIGNP if repair==2 // , cellwidth(10)
table foreign FOREIGNP if repair==3 // , cellwidth(10)
* MATA
mata
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
* Affiche la solution
 x
 end
 
/***
Notons que nous pourrions estimer le mod\`ele Probit de la m\^eme mani\`ere,
 ainsi que d'autres mod\`eles \`a variable d\'ependante qualitative, tels que
 le mod\`ele de Poisson, ou une g\'en\'eralisation de la fonction logistique,
 avec le mod\`ele multinomial.
 
\newpage\large
\begin{flushleft}
\textbf{4.2 Moindres carr\'es, \ttfamily regress\normalfont}
\end{flushleft}

Dans le cas univari\'e, la m\'ethode des moindres carr\'es (MC) permet de
 trouver une estimation du moment centr\'e d'ordre un d'une variable qui
 minimise sa variance :
 $$\mu^{MC}\equiv argmin_{\mu}n^{-1}\sum_i(y_i-\mu)^2.$$
 On la retrouve en \'econom\'etrie o\`u la moyenne est en fait l'esp\'erance
 conditionnelle \`a une ou plusieurs autre variables, $\theta\equiv 
 E(Y_i|X_1,X_2,\ldots,X_K)=\beta_1X_1+\cdots\beta_KX_K.$

La commande \ttfamily regress\ \normalfont de Stata g\`ere ces deux situations
 sans probl\`eme. Dans le premier cas, il suffit de faire une r\'egression des
 de $Y$ sur une constante, en tapant tout simplement \ttfamily 
 \textbf{regress Y}.\ \normalfont Dans le second cas, une r\'egression sur les
 diff\'erentes variables, par exemple $X_1$ et $X_2$ : 

 \bigskip
 \ttfamily \textbf{regress Y X1 X2} $\cdots$ X3,\normalfont
 \bigskip

Les justifications de la m\'ethode sont dans tous les livres d'\'econom\'etrie,
 dont les deux plus fameux (Wooldridge, 2010, et Greene, 2014). On peut sans
 difficult\'e, utiliser Stata pour calculer les coefficients d'un mod\`ele
 en manipulant les matrices.
***/

use	"http://www.evens-salies.com/rubin1977.dta", clear
rename (GROUP POSY PREX)(D Y X)
regress Y D
generate ONE=1
mkmat ONE D, matrix(X)
mkmat Y, matrix(Y)
matrix B=invsym(X'*X)*X'*Y
matrix list B

/***
Dans le cas du mod\`ele lin\'eaire simple, il y a un lien fort avec le
 coefficient de corr\'elation de pearson dans le cas de variables continues.
 Les r\'esultats ne renvoient pas les coefficients de correlation de Spearman,
 tetrachorique (dans le cas de deux variables dichotomiques) car, par
 d\'efinition, la regression est pour des variables continues. La statistique
 $R^2$ affich\'ee, apr\`es avoir ex\'ecut\'e la commande, est le coefficient
 de Pearson au carr\'e.

\newpage\large
\begin{flushleft}
\textbf{4.3 Estimation bootstrap}
\end{flushleft}

Le bootstrap, que nous avions vu dans la \textbf{section 3} est au d\'epart une
 m\'ethode d'inf\'erence. Revenons \`a l'exemple des capitalisations de cette
 section. Chacune des 23 capitalisations est la r\'ealisation d'une variable
 al\'eatoire dont on ne conna\^it pas la loi sous-jacente. Dans ce cas,
 le \fbox{bootstrap non-param\'etrique} peut \^etre utilis\'e, en appliquant
 un re-\'echantillonnage bas\'e sur toutes les observations. Si $n=23$ est la
 taille de l'\'echantillon, on cr\'ee un certains nombre d'\'echantillon
 bootstrap de $23$ observations chacun. Rappelons que le nombre d'\'echantillons
 bootstrap \underline{distincts} augmente tr\`es vite avec $n$.

Avant de continuer avec ces donn\'ees concr\`etes, examinons le cas simpliste
 $N=n=3$. Nous allons introduire la commande \textbf{\ttfamily bootstrap.\ 
 \normalfont} dans ce cas. Nous allons produire 1000 \'echantillons bootstrap,
 sachant tr\`es bien qu'il n'y en a que 10 de 
 distincts. En effet, \`a partir de $\mathcal{S}=\{1,2,3\}$, on a les
 \'echantillons suivants : \{1,1,1\}, \{2,2,2\}, \{3,3,3\}, \{1,1,2\}, 
 \{2,2,1\}, \{1,1,3\}, \{3,3,1\}, \{2,2,3\}, \{3,3,2\}, \{1,2,3\}. Supposons que
 les valeurs de la variable al\'eatoire soient $y_1=2$, $y_2=1$ et $y_3=3$.
Il y a sept sommes, et donc sept moyennes diff\'erents. Ces 10 \'echantillons
 donnent les moyennes suivantes : $\frac{2+2+2}{3}=2$, $\frac{1+1+1}{3}=1$,
 $\ldots$, $\frac{3+3+1}{3}=7/3$, $\frac{2+1+3}{3}=2$. Vous pourrez v\'erifier 
 qu'il y a sept moyennes diff\'erentes. Pour conna\^itre la proportion de chaque
 moyenne, il faut revenir au nombre d'\'echantillons possibles : $3^3=27$. Les
 diff\'erentes moyennes avec leur fr\'equence relative th\'eorique entre
 parenth\`eses, sont les suivantes :
 $3/3=1 (1/27)$ (l'\'echantillon \{1,1,1\}), $4/3=1,33\ldots (3/27)$ (les 
 \'echantillons \{1,2,2\}, \{2,1,2\}, \{2,2,1\}), $5/3=1,66\ldots (6/27)$ (les
 \'echantillons \{1,1,2\}, \{1,2,1\}, \{2,1,1\}, \{2,2,3\}, \{2,3,2\}, 
 \{3,2,2\}), ..., $9/3=3 (1/27)$ (l'\'echantillon \{3,3,3\}).

***/

set seed	21041971
clear all
set	obs 	3
input int Y
2
1
3
cls
list
generate	MEAN=.
bootstrap	MEAN=r(mean), ///
 size(3) reps(1000) saving(bootstrap123, replace) nowarn: summarize Y

* Look at the file content
use 			"C:\Users\evens\Documents\bootstrap123.dta", clear 
generate 		ONE=1
collapse (sum) 	ONE, by(MEAN)
summarize		ONE
generate 		ONEP=100*ONE/r(sum)
browse

/***
La commande \ttfamily \textbf{bootstrap}\ \normalfont a pour argument le nom
 de la variable dans laquelle on va mettre la statistique qui nous int\'eresse.
 Ici, c'est la variable \ttfamily \textbf{MEAN}.\ \normalfont Cette variable
 contiendra une statistique post-commande, \ttfamily \textbf{r(mean)},\ 
 \normalfont calcul\'ee par \ttfamily \textbf{summarize}.\ \normalfont
 Il y a 1000 TAR, et les 1000 moyennes sont plac\'ees dans le fichier de
 donn\'ees \ttfamily \textbf{bootstrap123.dta}\ \normalfont dans votre dossier
 de travail (taper \ttfamily \textbf{pwd}\ \normalfont dans la fen\^etre
 de commande pour savoir quel est ce dossier). Apr\`es la commande
 \ttfamily \textbf{bootstrap},\ \normalfont le programme calcule la fr\'equence
 relative de chaque moyenne. La commande calcule un intervalle de confiance
 bootstrap de la moyenne, \`a partir de l'erreur standard bootstrap. 
 
Le programme suivant calcule cet intervalle de confiance sur les donn\'ees
 de capitalisation en r\'e-\'echantillonnant les 23 observations. Il y a trop
 d'\'echantillons possibles (non-distincts) : $23^{23}$. Nous allons nous
 contenter d'en tirer 100. Vous pouvez ensuite essayer de voir quel est le
 r\'esultat obtenu avec 500 r\'eplications. Plut\^ot que de placer les
 fr\'equences relatives des diff\'erentes moyennes dans la feuille de donn\'ees,
 on va faire un histogramme de ces moyennes, avec la commande \ttfamily 
 \textbf{hist MEAN}.\normalfont
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
Nous n'avons pas utilis\'e l'information captur\'ee par la variable de
 stratification. Si l'on pense que la moyenne varie d'une strate \`a 
 l'autre, de sorte que $Y_{is}=\mu_s+U_i$ est le mod\`ele pertinant,
 avec par exemple $U_i\sim i.i.d.$ (la valeur de $Y_{is}$ est d\'etermin\'ee
 par un PGD inconnu).

On peut combiner \ttfamily \textbf{regress}\ \normalfont avec l'option \ttfamily 
 \textbf{bootstrap}\ \normalfont pour l'estimation de l'\'erreur type du
 coefficient d'un mod\`ele de r\'egression. Dans l'exemple ci-dessous, le
 coefficient est unique, c'est la constante dans une mod\`ele de r\'egression
 (il n'y a pas de variable explicative autre que la constante). On sait que dans
 ce cas, l'estimateur de la constante est $\hat{Y}$ de la \textbf{section 3}.
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
On peut v\'erifier avec \ttfamily \textbf{summarize CAP}\ \normalfont que
 l'unique coefficient estim\'e est bien la moyenne de la variable. L'avantage
 de \ttfamily \textbf{regress}\ \normalfont est que nous avons au passage une
 estimation d'un intervalle de confiance pour la moyenne. Dans le cas d'un
 re-\'echantillonnage, l'estimateur bootstrap de l'erreur standard, qui vaut
 57.97 dans mon cas, sert \`a calculer l'intervalle de confiance au seuil de
 5\%, comme on peut le v\'erifier :
 $$254.95\pm 1,96\times 57,97 \Leftrightarrow 254.95\pm 113,62 \Leftrightarrow
 [141,33 ; 368,57].$$
  
Vous verrez des m\'ethodes plus compliqu\'ees cett ann\'ee ou l'an prochain. Je
 pense par exemple \`a la m\'ethode des moments g\'en\'eralis\'es, avec la
 commande \ttfamily \textbf{gmm}\normalfont. Je vous conseille de revoir cette
 m\'ethode dans le cas univari\'e, le cas ``simple'' par opposition \`a 
 ``g\'en\'eralis\'e'' qui est le cadre dans lequel cette commande a \'et\'e
 cr\'e\'ee). Il y a un estimateur connu en \'econom\'etrie qui s'appuie dessus.
 C'est celui d'Arellano et Bond, pour l'estimation des coefficients d'un
 mod\`ele dynamique sur donn\'ees de panel. Des informations sur l'application
 de la m\'ethode dans le cas de petits \'echantillons sont disponibles dans
 Drukker (2010).\footnote{\hspace{1.5pt} Drukker, D.M. 2010. An introduction to
 GMM estimation using Stata (slides). In German Stata Users' Group.}
***/

/***
Bibliographie
=============
***/

quietly log close

/* Exécuter depuis la fenêtre de résultat

markdoc "statainitiation_4smcl.smcl", export(docx) replace

*/