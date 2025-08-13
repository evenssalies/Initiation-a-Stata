/***
3.4 Tirage sans et avec remise, bootstrap
-----------------------------------------

L'objet de cette section est d'estimer un intervale de confiance pour la
moyenne d'un échantillon par la méthode du bootstrap avec Stata. Dans un
premier temps, nous rappelons les principes de tirage sans et avec remise dans 
les sondages (approche traditionnelle). 
 
Le bootstrap repose sur un re-échantillonnage (_re-sampling_) des observations,
soit créer des échantillons à partir de l'échantillon de départ. On suppose que
cet échantillon de départ est aléatoire. Les observations qui sont incluses dans
les nouveaux échantillons construits à partir de celui de départ, dépendent du 
mode de tirage. Avant d'aborder le bootstrap, nous faisons un petit détour par 
les tirages dans les enquêtes (les sondages) dans l'approche traditionnelle. 

### Petit détour par l'approche traditionnelle

Il y a deux grands modes de tirages : sans remise (_without replacement_) (TSR) 
et avec remise (_with replacement_) (TAR). Stata vous permet de tirer un 
échantillon dans une population selon ces deux modes de tirage, avec les 
commandes __`sample`__ et __`bsample`__, respectivement. Quel que soit le mode 
de tirage, deux probabilités comptent : 

- la probabilité qu'une unité 
d'observation appartienne à un échantillon particulier, et
- la probabilité de cet échantillon.

Pour simplifier la présentation, on supposera que les 
échantillons sont équiprobables. Notons que pour un mode de tirage donné, les 
échantillons sont équiprobables si la base de sondage $\mathcal{P}$ est de 
bonne qualité (identifiants des unités statistiques clairs, pas d'unité en 
double, ni manquante, etc.) 
 
La distribution d'échantillonnage de $\hat{Y}$ dépend du nombre d'échantillons 
possibles (on en tirait 1000 dans l'exercice précédent "Distribution Monte Carlo
de la moyenne"). Supposons qu'il n'y ait pas plus de $K$ échantillons distincts
$S_k$ de taille $n$ (la position des individus dans l'échantillon ne compte 
pas), à partir desquels on calcule les moyennes $\hat{Y}_{n,1},...,
\hat{Y}_{n,K}$, où $\hat{Y}_{n,k}$ est la moyenne dans l'échantillon $k$ de 
taille $n$. 

Définission $\sum^{k}$ comme la somme sur $k=1,\ldots,K$, $\sum^{i}$ comme la 
somme sur $i=1,\ldots,N$ et $\sum^{i\in S_k}$ comme la somme sur les $i$ 
appartenant à l'échantillon $S_k$. Alors, la "moyenne des 
moyennes", i.e. la moyenne des $\hat{Y}_{n,k}$ est : 
$$\hat{Y}_n\equiv\sum^{k} \hat{Y}_{n,k} \textrm{Pr}(S_k)$$
$$=\sum^{k}\frac{1}{n}\sum^{i\in S_k}Y_i \textrm{Pr}(S_k).$$

Les échantillons étant équiprobables, on a $\textrm{Pr}(S_k)=1/K$. La moyenne 
ci-dessus devient $$\frac{1}{K}\frac{1}{n}\sum^{k}\sum^{i\in S_k}Y_i=
\frac{1}{K}\frac{1}{n}\sum^{k}\sum^{i}Y_i 1_{S_k}(i).$$ On a plus
qu'à montrer que $E(\hat{Y}_n)$ est égal à $\bar{Y}$. Le résultat 
$E(\hat{Y}_n)=\bar{Y}$ est important. On n'y prête plus attention lorsque l'on 
calcule une moyenne arithmétique dans un échantillon. On oublie trop souvent 
que la valeur de cette statistique repose sur le mode de tirage. Ce résultat 
est plus facile à montrer dans le cas de l'approche modèle, quand les $Y_i$ 
sont aléatoires (cf. page 3). Dans le cas présent, $E(Y_i 1_{S_k}(i))= 
Y_i E(1_{S_k}(i))=Y_i\textrm{Pr}(i\in S_k)$.

### Tirage sans remise (TSR), `sample` (le sondage aléatoire simple)

La commande __`sample`__ fait un TSR. On peut montrer que dans un sondage 
aléatoire simple, la probabilité que l'unité d'observation $i$ soit tirée vaut 
$n/N$. Cette probabilité est appelée taux de sondage (_sampling rate_). On 
remarque que la probabilité qu'un individu appartienne à l'échantillon ne 
dépend pas de l'individu (probabilité dite constante). 

On a ce résultat trivial malgré le fait que les unités d'observation 
successivement tirées (sondées), le sont avec des probabilités qui, elles, sont
différentes. En effet, les $i\in\mathcal{P}$ ont la même probabilité d'être 
tirés au premier tour, $1/N$. En revanche, la $j$ème unité d'observation a plus
de chance d'être tirée (en moyenne) que la $(j-1)$ème, car elle est en 
"concurrence" avec moins d'unités qu'au tour précédent. Les probabilités pour 
les $n$ individus sont respectivement $1/N,1/(N-1),\ldots,1/(N-n+1)$. En 
supposant que l'on range les $n$ individus côte à côte, chacun des échantillons
de taille $n$ est une permutation parmis les $n!$ possibles. Avec $n=3$ par 
exemple, l'échantillon $\{i_j,i_k,i_l\}$ ($n=3$) est le même que 
$\{i_k,i_l,i_j\}$, $\{i_l,i_j,i_k\}$, etc. On a $3!=6$ échantillons égaux. 
Le nombre d'échantillons est alors égal à l'inverse de la probabilité d'un 
échantillon, c'est-à-dire la probabilité de tirer $n$ individus dans la 
population de taille $N$. Cette probabilité vaut :
$$\begin{array}{rl}
  & n!\frac{1}{N}\frac{1}{N-1}\cdots\frac{1}{N-n+1} \\
= & n!\frac{1}{N}\frac{1}{N-1}\cdots\frac{1}{N-n+1}\frac{(N-n)!}{(N-n)!} \\
= & \frac{n!(N-n)!}{N!}.
   \end{array}$$

Par conséquent, le nombre d'échantillons est simplement égal à 
$N!/(n!(N-n)!)\equiv C_N^n$. Entre parenthèses, le nombre d'échantillons 
serait $C_{N+n-1}^n$ dans un TAR. Calculons maintenant le nombre d'échantillons 
dans lesquels figure un individu $i$ quelconque. On trouve :
$$\frac{(N-1)!}{(n-1)!(N-n)!}.$$
 
__Exercice.__
1. Démontrer que le nombre d'échantillons dans lesquels figure un individu $i$,
quelconque, est $C_{N-1}^{n-1}$. 2. Sachant que le nombre total d'échantillons 
de taille $n$ parmi $N$ est $C_N^n$, vérifier que la probabilité que l'individu
$i$ soit tiré est $n/N$. _Démonstration similaire à la précédente (en cours)_
 
Revenons à la théorie et calculons $E(\hat{Y}_n)$ :
 $$\begin{array}{rcl}
  E(\hat{Y}_n) & = & \frac{1}{K}\frac{1}{n}\sum^{k}\sum^{i}Y_i E(1_{S_k}(i)) \\ 
  & = & \frac{1}{K}\frac{1}{n}\sum^{k}\sum^{i}Y_i\textrm{Pr}(i\in S_k) \\
  & = & \frac{1}{K}\frac{1}{n}\sum^{k}\sum^{i}Y_i(n/N) \\
  & = & \frac{1}{N}\sum^{i}Y_i \\
  & = & \bar{Y}.
   \end{array}$$

Le passage à la deuxième ligne utilise le résultat 
$E(1_{S_n}(i))=1\times\textrm{Pr}(i\in S_k)
+0\times\textrm{Pr}(i\notin S_k)$. On appelle Pr$(i\in S_k)$ une probabilité
d'inclusion d'ordre 1 (Ardilly et Tillé, 2003, p. 2 ; Ardilly, 2006, pp. 54, 
259).
 
Que se passe-t-il lorsque les individus ont des probabilités d'inclusion 
inégales ? C'est-à-dire quand certains types d'individus de la population sont 
sous-représentés (et d'autres surreprésentés) ? La moyenne est-elle toujours un 
bon estimateur ? Notons d'abord que la moyenne arithmétique peut s'écrire comme
un estimateur avec probabilités d'inclusion égales. En effet, $$\frac{1}{n} 
\sum^{i\in S_k}Y_i=\frac{1}{N}\sum^{i\in S_k}\frac{Y_i}{n/N}.$$ L'__estimateur 
de Horvitz-Thompson du total__ est un estimateur à probabilités d'inclusion
inégales (Ardilly, 2006, p. 133) : $$\hat{Y}_n=\frac{1}{N} 
\sum^{i\in S_n}\frac{Y_i}{\textrm{Pr}(i\in S_n)}=\frac{1}{N}\sum^{i} 
\frac{Y_i}{\textrm{Pr}(i\in S_n)}1_{S_n}(i).$$ 
 
La démonstration d'absence de biais n'est pas compliquée. Notons d'abord que 
$\sum^{i}\textrm{Pr}(i\in S_n)=n$ (ce qui est trivial quand les probabilités 
sont égales puisque $\sum^{i}\textrm{Pr}(i\in S_n)=N(n/N)=n$). Alors,
 $$\begin{array}{rcl}
 E(\hat{Y}_n) & = & \frac{1}{N}\sum^{i}\frac{Y_i}{P(i\in S_n)}E(1_{S_n}(i)) \\
  & = & \frac{1}{N}\sum^{i}\frac{Y_i}{P(i\in S_n)}P(i\in S_n) \\
  & = & \bar{Y}. \\
   \end{array}$$

__[Aller chercher `horvitzthompson.do`]__
   
Supposons par exemple $N=23$ et $n=4$. On a donc $C_{23}^4=8855$ échantillons 
distincts. Par ailleurs, il y a 1540 échantillons incluant $i$. Ainsi, la 
probabilité que $i$ appartienne à l'échantillon tiré est égale à $1540/8855$ 
qui, après simplification, vaut bien $4/23$, soit environ 17,4\%. L'application 
de la commande `sample` dans un petit exercice de simulation va nous permettre 
de vérifier cela. Nous allons utiliser `sample` avec les commandes `preserve` et
`restore` car `sample` ne retient que l'échantillon tiré (les unités qui ne sont
pas tirées sont détruites).
 
On va supposer une population de 23 unités pour une variable dont le
logarithme est normalement distribué (une variable log-normale), de paramètres 
5 et 1. On tirera 100 échantillons de taille 4 (c'est bien inférieur à 8855, 
mais ça devrait être suffisant pour vérifier les résultats précédents). On ne 
va pas faire apparaître les observations de chaque échantillon, mais les unités
d'observations tirées dans chacun. Celles-ci sont placées dans une matrice $J$ 
de dimension 4 lignes $\times$ 100 colonnes, que l'on affichera en fin de 
programme.
***/ 

* Notons qu'on ne met pas directement les 4-echantillons dans la matrice. On les
* met d'abord dans un 4-vecteur, que l'on insere ensuite dans la matrice.

cls
clear all
set obs 23
set seed 21041971
* Loi log-normale ln(Y) ~ N(5,1)
generate Y=exp(rnormal(5,1))
matrix define J=J(4,100,0)
*matrix list J  
* N'affiche pas ce qui se passe dans la boucle
quietly {
 forvalues I=1(1)100 {
* preserve, restore pour ne pas detruire la population de depart
  preserve
* Numeros des unites
   generate LINE=_n
* TSR de 4 observations
   sample 4, count
   mkmat LINE, matrix(V)
* Met le vecteur a partir de la ligne 1, colonne I
   mat J[1,`I']=V
  restore 
 }
}
* Option nonames pour sauver un peu de place
matrix list J, nonames
*

/***
Intéressons-nous à l'individu 14, par exemple. Il apparaît 21 fois, soit
21\% des échantillons, puisqu'on en a tiré 100. C'est légèrement au-dessus de
17,4\%.
  
### Tirage avec remise, `bsample`

Comme précédemment, on suppose que $Y_i$ n'est pas aléatoire, c'est le tirage
qui l'est. La détermination de la probabilité d'inclusion pourrait sembler plus
compliquée, du fait qu'un individu peut apparaître plusieurs fois dans
l'échantillon. On est renvoyé à la loi multinomiale. Si l'on note le vecteur
$(f_1,\ldots,f_N)$, où $f_i$ est le nombre de fois où l'individu $i$ est dans
l'échantillon de taille $n$, avec $\sum f_i=n$. Alors $(f_1,\ldots,f_N)$ suit
une loi multinomiale $M(n ; p_1,\ldots,p_N)$, avec $p_i=1/N$ (on suppose que
chaque unité est représenté une fois dans la population, situation de
probabilités égales). Dans ce cas, $E(f_i)=np_i=n/N$ (Tassi, \textit{ibid}, p.
19). Notons $\hat{Y}_n=n^{-1}\sum^{i}Y_if_i$, alors :

 $$\begin{array}{rcl}
  E(\hat{Y}_n) & = & \frac{1}{n}\sum^{i}Y_i E(f_i) \\ 
  & = & \frac{1}{n}\sum^{i}Y_i (n/N) \\
  & = & \frac{1}{N}\sum^{i}Y_i \\
  & = & \bar{Y}.
  \end{array}$$
 
Nous allons appliquer les méthodes de cette section sur un petit jeu de 
données. Le tableau suivant liste la capitalisation de 23 entreprises du web, 
les GAFA, les NATU (phénomène d'ubérisation associé à l'usage des technologies 
numériques), les BATX et d'autres entreprises importantes telles que Microsoft, 
Twitter (avant de devenir X), etc. Pour donner un ordre de grandeur, le PIB 
français de 2017 en dollars américains était de 2750 milliards, ce qui est 
inférieur à la capitalisation des quatre premiers géants du web (3199 mds). 
La somme des capitalisations d'Apple et Amazon était à peu près égale à celle 
des 40 entreprises du CAC40 réunies !
 
Nous avons utilisé des caractères gras pour les GAFAM, italiques pour les NATU 
et souligné les BATX. Nous avons également ajouté une variable de stratification
qui permet de regrouper -- un peu à la louche -- chaque entreprise en fonction 
de son secteur d'activité, afin de souligner l'hétérogénéité des entreprises du 
web. Cette variable sera utilisée plus tard. Nous pourrions rajouter une 
variable `pays d'origine', certains géants étant américains, d'autres chinois, 
etc.

Certaines strates n'ont qu'une observation, les strates 4, 7 et 8. Nous avons
obtenu ce résultat en tapant __`table STR`__ après avoir chargé les données.

__Graphique 3.2__. Capitalisation d'entreprises du web (en mds $ courants,
janvier 2018).
![](./statainitiation_3_capitalisation_data.png)
![](./statainitiation_3_capitalisation.png)

Les entreprises listées dans ce tableau constituent notre base de sondage, 
$\mathcal{P}=\{\textrm{Apple, Amazon},\ldots,\textrm{LinkedIn}\}$
($N\equiv 23$). Nous désirons estimer sans biais $\bar{Y}$, la capitalisation 
moyenne dans la population, à partir d'un échantillon de taille $n\equiv 4$.
Nous avons rentré les données du tableau directement à la main dans le
__`Data Editor`__ de Stata puis arrangé un peu le code :
***/

use	"http://www.evens-salies.com/statainitiation_3_capitalisation.dta", clear	
rename	(var*)(CAP STR TEMP)
encode	TEMP, generate(NOM)
drop	TEMP
order	NOM
sort	NOM

/*** 
On parle de ré-échantillonnage ou _resampling_ ! Pour que vous voyez bien ce 
qui se passe, je suppose que bien que la population comporte 23 entreprises, on
veut obtenir un 4-échantillon (TAR). Cet exemple est alors facile à extrapoler 
à des situations où $n$ et $N$ sont plus grands). Comme nous venons de le voir,
une entreprise a 17,4\% de chances environ d'être dans un échantillon avec TSR. 
Mais ce calcul se basse sur une connaissance de la taille de la population (23).
Dans le cas où je n'ai qu'un échantillon aléatoire, pour une super population,
et que la loi de la variable (en occurence __`CAP`__) m'est inconnue, alors je
ne sais rien \textit{a priori} de la distribution théorique de sa moyenne dans
l'échantillon aléatoire, ni de l'erreur standard ; la méthode bootstrap est 
approprié dans ce cas, même s'il n'est pas recommendé de l'appliquer à un 
échantillon si petit ($n\equiv 4$).

Soulignons à nouveau une distinction importante entre le bootstrap et la méthode
Monte Carlo, qui est que dans une simulation Monte Carlo (dans le Bootstrap) on
fait une (ne fait pas de) supposition sur la loi suivie par la variable 
aléatoire de la super population dont on souhaite calculer une statistique.

Nous allons voir la commande de ré-échantillonnage __`sample`__ avant d'utiliser
__`bsample`__. Le nombre de $n$-échantillons résultants d'un TAR dans une
population de taille $N$ est très grand, $N^n$. Le nombre d'échantillons 
distincts est donné par la formule $C_{N+n-1}^n. Le nombre d'échantillons 
distincts est donc $C_{2n-1}^n$, dans le cas où l'on re-échantillonne toutes les
observations de l'échantillon. C'est le cas $N=n$ (par ex., si $N\equiv 
n\equiv 4$, il y a 35 échantillons distincts possibles). Mais si $N\equiv 23, 
n\equiv 4$, le nombre d'échantillons distincts est donné par la formule 
$C_{N+n-1}^n=C_{26}^4=14950$. La commande __`bsample`__ s'utilise comme la
commande __`sample`__ :
***/

preserve
* TSR
* sample		4
* TAR
 bsample	4
 save		"statainitiation_3_bsample.dta", replace
 list		NOM
restore

/*** 
Vous pouvez exécuter ce programme plusieurs fois ; vous pouvez tomber sur un
4-échantillon avec une répétition _d'au moins une_ entreprise. La probabilité 
que cela arrive est faible, cependant.
 
__Exercice 2.__ Quelle est la probabilité que vous obteniez au moins deux fois 
la même entreprise (l'entreprise 1 par exemple) ?

Cette probabilité est le complément à 1 d'obtenir au plus une fois la même 
entreprise. C'est donc la probabilité qu'elle ne soit pas incluse dans 
l'échantillon ou qu'elle n'y soit qu'une fois. Ces deux événements étant 
incompatibles, on somme leur probabilités. Le nombre d'échantillons de taille 
$n$ sans l'individu 1 par exemple est égal à $(N-1)^n$. Quant au nombre 
d'échantillons où l'individu 1 n'est inclu qu'une fois, il est égal à 
$n(N-1)^{n-1}$. C'est le nombre de sous-échantillons sans l'unité 1, que l'on
recompose ensuite en mettant cet individu dans l'une des $n$ positions 
possibles. Enfin, le nombre total d'échantillons est $N^n$. La probabilité 
recherchée vaut donc $$1-\frac{(N-1)^n}{N^n}-\frac{n(N-1)^{n-1}}{N^n}.$$ Avec 
nos paramètres, cela donne environ 1,07\%.\bigskip

On peut aussi utiliser __`bsample`__ en tenant compte de l'information renvoyée
par la variable de stratification __`STR`__. L'intérêt de faire cela est qu'on
est sûr que toutes les strates seront représentées. Cependant, certaines 
strates n'ont qu'une unité dans la population (4, 7 et 8), alors que trois 
strates (1,2 et 3) en ont 15 à elles seules. Dans l'exemple qui suit, on 
produit cinq échantillons de deux TAR. On remarque que dans la strate 6, il y a
de fortes chances que l'échantillon renvoie la même unité d'échantillonnage 
dans la mesure où il n'y a que deux unités dans cette strate au départ. Alors
que dans la strate 1 par exemple, il y en a 5.
***/

preserve
* Les strates avec une seul entreprises, 4, 7 et 8, correspondent au noms
* encodes 4, 15 et 16
 bsample	2 if NOM!=4&NOM!=15&NOM!=16, strata(STR)
 save		"statainitiation_3_bsample.dta", replace
 list
restore

/*** 
Si on re-échantillonne toutes les observations, on tire une unité au hasard,
on la remet, on fait cela 23 fois. Nous avons tout de suite l'intuition que le
nombre d'échantillons bootstrap possibles est téoriquement énorme. Rien que le
nombre d'échantillons \underline{distincts} cro\^it très vite avec $n$, comme on
peut le voir pour $n=1,\ldots,10$ (on a des échantillons de taille 1 à 10, et on
re-échantillonne tout ) :
***/

cls
clear all
set	obs 10
gen SMALLN=.
gen BOOTNB=.
qui {
 forvalues I=1(1)10 {
  replace SMALLN=`I' in `I'
  replace BOOTNB=comb(2*`I'-1,`I') in `I'
 }
}
*
list

/***
L'accroissement est "exponentiel", de sorte qu'il est pratiquement impossible de
voir tous les échantillons possibles. Vu que les échantillons sont aléatoires,
la probabilité que certains ne soient pas tirés n'est pas nulle. Ce n'est que
dans le cas de $n$ très petit, que l'on est presque certain que tous les
échantillons possibles seront tirés. Par exemple, dans le cas $N=n=3$,
$\mathcal{S}=\{1,2,3\}$, on a les échantillons suivants :
 \{1,1,1\}, \{2,2,2\}, \{3,3,3\}, \{1,1,2\}, \{2,2,1\},
 \{1,1,3\}, \{3,3,1\}, \{2,2,3\}, \{3,3,2\}, \{1,2,3\}.

3.5 Protocole expérimental
--------------------------

Le protocole expérimental vient normalement juste après l'étape 
d'échantillonnage, mais avant l'étape d'inférence (estimation, test) sur le 
modèle statistique. Chez les statisticiens, la spécification fait elle aussi 
partie du protocole (_design_).

Il y a plusieurs types de protocoles expérimentaux (manières d'exposer des
individus à telle ou telle intervention), selon le contrôle que l'on a sur le
processus économique étudié. C'est ce que vous verrez l'an prochain notamment 
dans le cours Méthodes Statistiques de l'évaluation (MSE). L'exposition des 
individus à telle ou telle intervention ressemble à l'affectation de ces 
individus dans les groupes de traitement, comme dans les sciences biomédicales. 
On parle de __mécanisme d'affectation des traitements__ (Imbens et Rubin, 2015).

Dans la __section 1__, nous avions introduit un exemple tiré de l'article de 
Rubin (1977), dans lequel le traitement prenait deux états possibles pour des 
élèves de CM1 aux états-Unis. Il y a ce que l'on appelle la version active du
traitement (l'élève suit un nouveau programme de mathématique), et la version 
de contrôle (l'élève reste sur l'ancien programme). Le mécanisme le plus 
simple, est le mécanisme aléatoire contrôlé, aussi appelé randomisation, ou 
_randomized controlled trial_, ou tout simplement _experiment_. Dans le cas où
il n'y a aucune contrainte sur le nombre d'individus affectés dans l'un des 
groupes de traitement, on a ce que l'on appelle un mécanisme de Bernoulli.

Supposons un échantillon de taille $n$, et les deux programmes considérés par
Rubin : le programme 1 (le cours amélioré, A) et 2 (le cours comme avant, B).
On modélise le mécanisme à l'aide d'une variable, $D$, qui prend la valeur 1 si
l'individu est dans le programme 1, et 0 sinon. Quelle est la loi suivie par
$D$ ? Tout dépend du mécanisme d'affectation. Si on décide que le mécanisme est
un mécanisme de Bernoulli, on a tout simplement :
$$\textrm{Pr}(D=1)=\frac{1}{2}.$$

Le problème de ce mécanisme, est qu'on peut se retrouver avec tous les individus
dans un seul groupe. Du coup, on préfère généralement un
mécanisme pleinement randomisé (__completely randomized experiment__),
qui pioche $n_1$ élèves au hasard dans l'échantillon, et les affecte au
programme 1. La probabilité pour un élève de suivre les programme 1 est :
 $$\textrm{Pr}(D=1)=\frac{n_1}{n}.$$ La démonstration est exactement la
 même que celle pour le tirage aléatoire simple, selon lequel une unité
 d'observation avait $n/N$ chances de se retrouver dans l'échantillon.

__Exercice.__ Montrer que la probabilité qu'un élève soit exposé au programme 1 
est $n_1/n$.

Rubin (1977) a été plus loin en affectant les élèves sur la base d'une note 
obtenue avant de mettre en place le nouveau programme. Soit $X$ cette note, 
une variable aléatoire. On parle de variable de pré-traitement, ou de 
_baseline outcome_. Il s'agit d'une note entre 0 et 100, le fameux SAT 
américain, telle que lorsque vous avez 100, cela veut dire que 100\% des 
autres autres élèves que vous ont une note inférieure à la votre. Le 
mécanisme est un peu plus sophistiqué : $$\textrm{Pr}(D=1|X=x)= 
\frac{100}{100+x}.$$ Ainsi, pour chaque valeur $x$, par exemple, $x=50$, 
$\textrm{Pr}(D=1|X=50)=2/3$, soit 66\% de chance de suivre le nouveau 
programme. Pour $x=80$, $\textrm{Pr}(D=1|X=80)=5/9$, soit 55\% de chance de 
suivre le nouveau programme.

Le programme suivant affecte les élèves selon ce mécanisme. Nous ne
 retrouvons pas les affectations de Rubin (1977), qui ne détaille pas son
 mécanisme. La technique que nous utilisons est la suivante. Après avoir
 calculé la probabilité $100/(100+x)$ pour chaque $x$ (nous convertissons
 $X$, qui est une note sur 10 en SAT, en prenant $10\times X$), nous comparons
 cette probabilité au fractile d'une loi uniforme 0-1, d'espérance 1/2.
 Si la probabilité est supérieure à 1/2, on met l'élève dans le
 nouveau programme, sinon, dans le second. 
***/

use "http://www.evens-salies.com/rubin1977.dta", clear
rename INDI INDIV
label define GROUPL 0 "Programme 2" 1 "Programme 1"
label values GROUP GROUPL
label variable POSY "Note apres"
label variable PREX "Note avant"
egen NINDIV=count(INDIV), by(PREX POSY GROUP)	
* Plus lisible, avec "." au lieu de "1"				
*replace NINDIV=. if NINDIV==1
scatter POSY PREX, mlabel(NINDIV) mcolor(white) by(GROUP) ///
 mfcolor(white) msymbol(none) legend(off) scheme(s1mono) ///
 mlabgap(-1.5) xscale(noline) subtitle( , nobox) ///
 ylabel( , nogrid)
* Faisons comme si les individus n'avaient pas ete affectes
generate SAT=10*PREX
generate PROBD1=.
replace PROBD1=100/(100+SAT)
set seed 21041971
generate UNIFORM=runiform()
generate GROUPNEW=(PROBD1>UNIFORM)
order INDIV GROUP* PROBD1 UNIFORM SAT
br
