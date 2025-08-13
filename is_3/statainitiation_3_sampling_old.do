**
* statainitiation_3
* \usepackage[utf8]{inputenc}
* \usepackage[T1]{fontenc}
* \usepackage[latin1]{inputenc}

/***
\UseRawInputEncoding
\usepackage{eucal}
\begin{document}
***/

cd				"C:\Users\evens\Documents"
quietly log		using statainitiation_3_sampling, replace

/***
\large
\begin{flushleft}
\textbf{3. \'Echantillonnage, distribution d'\'echantillonnage, estimation}
\end{flushleft}

\begin{center}
 \fbox{
  \begin{minipage}{12cm}
   \begin{center}
    \small Cette section pr\'esente des techniques d'\'echantillonnage avec 
	Stata, qui sont utilis\'ees pour les sondages, ou l'estimation. Les notions
	importantes ici sont celles de tirage sans ou avec remise, \'echantillon 
	al\'eatoire, \'echantillon \textit{bootstrap}, pond\'eration \`a la 
	Horvitz-Thompson, etc. Cette section souligne aussi les liens entre ces 
	notions et celles de population et superpopulation.\normalsize
   \end{center}
  \end{minipage}
  }
\end{center}
  
\bigskip
Dans la \textbf{section 2}, nous avons pr\'esent\'e des variables al\'eatoires 
 suivant des lois connues. Nous n'avions pas d\'efini l'unit\'e statistique ou 
 \fbox{unit\'e d'observation} d'une population (\textit{item}, 
 \textit{statistical unit}, \textit{individual}), i.e. l'individu (objet ou 
 sujet) auquel chaque variable se rapportait. Car, il n'y avait pas de 
 ``population'', au sens o\`u l'on entend d'habitude ce terme. Nous avions un
 \fbox{mod\`ele d'\'echantillonnage}, i.e. $N$ variables al\'eatoires $Y_1,
 \ldots, Y_N$. Chaque valeur $y_i$ est produite par un m\'ecanisme dit 
 \fbox{processus g\'en\'erateur des donn\'ees} (PGD, \textit{Data Generating 
 Process}). Un exemple de PGD : $Y\sim N(\mu,\sigma^2)$. C'est \fbox{l'approche 
 mod\`ele} du concept d'\'echantillon al\'eatoire, selon laquelle la population 
 $\{1,\ldots,N\}$ est un ``echantillon al\'eatoire'' tir\'e (avec remise) dans 
 une \fbox{superpopulation}.\footnote{\hspace{1.5pt} Ardilly, P., 2006, 
 \textit{Les techniques de sondage}, Technip ; voir p. 669.} Par exemple, la
 moyenne g\'en\'erale de chaque \'etudiant du M1 EE peut se mod\'eliser de 
 mani\`ere semi-param\'etrique (sans supposer de loi pr\'ecise) : $E(Y_i)=\mu$ 
 et $V(Y_i)=\sigma^2$, i.e. $Y_i\sim\textnormal{i.i.d.}\ i=1,\ldots,10$. Par
 abus de language, on appelle $(Y_1,\ldots,Y_{10})$ un \fbox{\'echantillon 
 al\'eatoire (\textit{random sample})} (alors qu'il serait pr\'ef\'erable de 
 r\'eserver ce terme aux \fbox{unit\'es d'\'echantillonnage} ou (\textit{sample 
 units} $\{1,\ldots,10\}$). Chaque $Y_i$ est tir\'e avec remise, ce que 
 sous-entend le ``i.d.'' de ``i.i.d.'' dans la notation pr\'ec\'edente (on 
 n'a qu'une superpopulation dans ce cas), et tous les \'echantillons sont 
 \'equiprobables. Deux sources d'al\'eas (deux lois) peuvent se superposer : le
 mode de tirage et la nature al\'eatoire des $Y_i$. On peut \'ecarter le mode de
 tirage de l'analyse en \'ecrivant $n$ plut\^ot que $N$ dans ce qui pr\'ec\`ede 
 (la taille de la super population n'intervient pas). Dans l'approche mod\`ele,
 le probl\`eme est d'estimer sans biais les param\`etres de la 
 superpopulation \`a partir des valeurs observ\'ees de l'\'echantillon 
 (\'echantillon $\rightarrow$ superpopulation). 
 
L'autre approche fonde la nature al\'eatoire de l'\'echantillon dans le 
 \fbox{mode de tirage}. L'\'echantillon est tir\'e dans la population 
 (population $\rightarrow$ \'echantillon). Comme avant, le probl\`eme est
 d'estimer sans biais des param\`etres, ceux de la superpopulation. L'unit\'e
 d'observation $i$ est g\'en\'eralement discr\`ete ; chaque $i$ poss\`ede un
 identifiant (par exemple, le num\'ero SIREN si l'individu est une entreprise).
 La population d'int\'er\^et $\{1,\ldots,N\}$ est not\'ee $\mathcal{P}$, avec
 $N$ le nombre d'unit\'es d'observation distinctes. Pour Newbold et
 \textit{alii} (2007), \textit{a population is the complete set of all items
 (statistical units, individuals) that interest an investigator} 
 (p. 80).\footnote{\hspace{1.5pt} Newbold, P., Carlson, W.L., Betty, T., 2007. 
 Statistics for Business and Economics. Pearson Prentice Hall, New Jersey,
 984 p.} En gros, la population, c'est nous qui la d\'efinissons. L'ensemble
 $\mathcal{P}$ est aussi la \fbox{base de sondage}. On parle 
 d'\'echantillonnage en population de taille finie, car $\mathcal{P}$ est 
 d\'enombrable (Card$(\mathcal{P})=N<\infty$). On se focalise sur la
 probabilit\'e d'inclusion d'un individu dans un \'echantillon. Un
 \fbox{\'echantillon} est un sous-ensemble de $\mathcal{P}$. En notant cet 
 \'echantillon $\mathcal{S}$, on peut \'ecrire $\mathcal{S}\subset\mathcal{P}$.
 Toutes les unit\'es d'observation peuvent \^etre dans l'\'echantillon.
 Autrement dit, on peut avoir $\mathcal{S}=\mathcal{P}$ (mode de tirage
 trivial), mais $Y_i$ est observ\'e avec erreur 
($Y_i^\prime=Y_i+\varepsilon_i$), qui est \`a nouveau l'approche mod\`ele. 
 Enfin, soulignons que l'on distingue unit\'e d'observation (\textit{unit
 of interest}) et \fbox{unit\'e d'\'echantillonnage (\textit{sample unit})}. 
 C'est \fbox{l'approche traditionnelle}. Elle peut para\^itre plus simple car
 on ne pr\'esupose absolument rien sur les $Y_i$ (Ardilly, 2006, p. 555). On y a
 recours plut\^ot dans les situations o\`u l'on veut \'eviter un recenssement 
 trop long et co\^uteux.
 
L'approche mod\`ele a une certaine pr\'ef\'erence en \'econom\'etrie. Surtout
 quand $\mathcal{P}$ n'est pas d\'enombrable. En effet, 
 l'unit\'e d'observation peut \^etre un indice continu, une unit\'e d'espace ou
 de temps. Par exemple, supposons que la variable qui nous int\'eresse soit le 
 cours du CAC40 \`a 9h00 du matin (la valeur de quotation d'ouverture). Quelle 
 est la population dans ce cas ? 9h00, de chaque jours d'un mois donn\'e, 
 janvier par exemple ?, ou de tous les mois de l'ann\'ee ? Et si c'est le
 trading \`a haute fr\'equence qui m'int\'eresse, dois-je faire un relev\'e par
 heure, par minutes, toutes les secondes, ou les microsecondes ? L'\'echantillon
 comprendrait des dizaines de miliards d'observations.\footnote{\hspace{1.5pt} 
 360 jours, fois 8 heures de quotation par jour, fois 60 minutes par heure,
 fois 60 secondes par minute, fois 1000 microsecondes par seconde, etc.}
 Est-ce une population de taille suffisante ? Quel est l'int\'er\^et de
 d\'efinir une population faite d'une quantit\'e d\'enombrable d'unit\'es
 d'observations ? C'est le probl\`eme auquel sont confront\'ees les \'etudes
 sur s\'eries temporelles. Certaines ``populations'' sont th\'eoriquement 
 \underline{infinies}. Ou, au contraire, de tr\`es petite taille, comme dans
 l'exemple des 10 notes. D'autres exemples : supposons que les unit\'es 
 d'observation soient des cr\'eneaux horaires, des r\'egions de l'espace, des
 coordonn\'ees GPS, les mots prononc\'es sur des r\'eseaux sociaux. On s'en sort
 mieux avec l'approche mod\`ele.\footnote{\hspace{1.5pt} Tassi, P., 2004, 
 \textit{M\'ethodes Statistiques}, Economica, 3e \'edition, pp. 58--59.}
 On se focalise sur l'\'echantillon al\'eatoire, et on essaie d'identifier les 
 param\`etres de la superpopulation, qu'on appelle g\'en\'eralement un
 mod\`ele.\bigskip 

\newpage
\begin{center}
\textbf{Qu'est-ce que l'approche fr\'equentiste ?}
\fbox{
 \begin{minipage}{12cm}
 Il y a deux grandes approches de l'inf\'erence en statistique : fr\'equentiste
 et bay\'esienne. Ce cours adopte la premi\`ere, qui est aussi appel\'ee
 classique.
 
 \hspace{13pt} On consid\`ere un mod\`ele d'\'echantillonnage : on a une
 distribution de probabilit\'e $F$ pour une variable r\'eelle $Y$. Supposons que
 le param\`etre d'int\'er\^et soit le premier moment de $Y$, i.e. son
 esp\'erance math\'ematique : $E_F(Y)$. Rappelons que c'est la valeur que nous
 devrions obtenir, en moyenne, pour une nouvelle observation, un tirage. Cette
 valeur est inconnue dans la mesure o\`u $F$ n'est elle-m\^eme que partiellement
 connue. On a $n$ observations de $Y$, que l'on note par le vecteur 
 {\boldmath$y$}$\ \equiv(y_1,\ldots,y_n)$. Les $y_i$ sont des r\'ealisations de
 variables al\'eatoires i.i.d. $Y_i\sim Y$. On note 
 {\boldmath$Y$}$\ \equiv(Y_1,\ldots,Y_n)$. Une estimation naturelle de $E_F(Y)$
 est obtenue en calculant la moyenne $(y_1+\cdots+y_n)/n$, not\'ee
 $t(${\boldmath$y$}$)$.

 \hspace{13pt} C'est ici qu'intervient le concept de `fr\'equence'. La valeur de
 la statistique, $t(${\boldmath$y$}$)$, est la r\'ealisation de 
 $t(${\boldmath$Y$}$)$, dont l'esp\'erance $E_F(t(${\boldmath$Y$}$))$ ne vaut
 pas forc\'ement $E_F(Y)$, d'o\`u un biais possible. Plus pr\'ecis\'ement, comme
 pour les observations individuelles $Y_i$, nous avons {\boldmath$Y$}$^{(k)}$,
 et donc $t(${\boldmath$Y$}$^{(k)})$, d'o\`u la m\'ethode consistant \`a
 prendre l'esp\'erance $E_F(t(${\boldmath$Y$}$))$. Nous pouvons alors calculer
 le biais de la mani\`ere suivante : $$E_F(t(\mathbf{Y}))-E_F(Y).$$
 \'Evidemment, dans le cas pr\'esent, $t(${\boldmath$Y$}$)$ est sans biais (voir
 la d\'emonstration \`a la page suivante).

 Le principe cl\'e de l'approche fr\'equentiste est de substituer $t(${\boldmath$y$}$)$ \`a
 $t(${\boldmath$Y$}$)$. Consid\'erons une mesure de pr\'ecision de $\bar{y}$.
 Prenons par exemple l'erreur standard de $t(${\boldmath$Y$}$)$, qui vaut 
 $(V_F(Y)/n)^{1/2}$. Le probl\`eme est qu'on ne conna\^it pas $V_F(Y)$. En
 revanche, on conna\^it une estimation sans biais, $\sum(y_i-\bar{y})^2/(n-1)$.
 C'est ce que Efron et Hastie (2015) appellent le \textit{plug-in principle}.
 La correction $n/(n-1)$ n'est pas le sujet ici. Le sujet est que l'on remplace 
 $V_F(Y)$ par un estimateur fonction de {\boldmath$y$} et $t(${\boldmath$y$}$)$,
 parce qu'on a remplac\'e $E_F(Y)$ par  $\sum y_i/n$. La pr\'ecision de
 $t(${\boldmath$y$}$)$ est la pr\'ecision probabiliste de l'estimateur 
 $t(${\boldmath$Y$}$)$
 \end{minipage}
}
\end{center}

\newpage 
Les param\`etres de la population, ou de la superpopulation, sont le plus
 souvent des indicateurs de centralit\'e (la moyenne arithm\'etique par exemple)
 et de dispersion de la variable d'int\'er\^et, g\'en\'eralement la moyenne et
 la variance. Supposons le \underline{mod\`ele} $E(Y_i)\equiv\mu$ et 
 $V(Y_i)\equiv\sigma^2$. La statistique $\hat{Y}\equiv n^{-1}\sum_iY_i$ est
 sans biais, au sens suivant :
 $$E(\hat{Y}_n)=E(\sum_iY_i/n)=(1/n)\sum_iE(Y_i)=(1/n)\sum_i\mu=(1/n)n\mu=\mu.$$
 Mais est-elle pr\'ecise ? C'est ce que nous verrons plus loin. 

 Revenons \`a l'\underline{approche traditionnelle} ? La moyenne dans la
 population est la fonction (Ardilly et Till\'e, 2003)\footnote{\hspace{1.5pt}
 Ardilly, P., Till\'e, Y. (2003). \textit{Exercices corrig\'es de m\'ethodes de
 sondage}. Ellipses.} $$f(Y_1,\ldots,Y_N)=\frac{\sum_iY_i}{N}\equiv\bar{Y}.$$ Si 
 Card($\mathcal{S})\equiv n<N$, on a affaire \`a un \fbox{sondage} (le cas $n=N$
 est le \fbox{recensement}). Le probl\`eme est de trouver le mode de tirage 
 garantissant qu'en moyenne, $\hat{Y}$ soit proche de $\bar{Y}$ ci-dessus.
 La \fbox{repr\'esentativit\'e} de la population compte \'egalement, mais ce
 sujet d\'epasse le cadre de cette section. Nous pouvons n\'eanmoins r\'esumer 
 l'id\'ee en disant que l'\'echantillonnage peut aussi se faire selon un ou 
 plusieurs crit\`eres (Ardilly, 2006, p. 94) afin de repr\'esenter la
 population de mani\`ere \'equilibr\'ee, en \'ehantillonnant par \fbox{strate}, 
 par exemple.

 $\hat{Y}$ est une \fbox{statistique} dans les deux approches. C'est une
 variable al\'eatoire. Supposons qu'apr\`es avoir choisi un mode de tirage,
 l'on  puisse tirer autant de $n$-\'echantillons que l'on veuille. On 
 pourrait tracer la \fbox{distribution d'\'echantillonnage} de $\hat{Y}$, 
 i.e. une distribution des valeurs de $\hat{Y}$. G\'en\'eralement, la
 distribution est dispers\'ee autour de la valeur centrale $\mu$ (dans
 l'approche mod\`ele) et $\bar{Y}$ (l'autre approche), les valeurs que nous
 obtiendrions si nous pr\'elevions un grand nombre d'\'echantillons. Plus les
 moyennes d'\'echantillons sont `proches' de ces valeurs, plus la pr\'ecision
 de $\hat{Y}$ est grande. \`A chaque \'echantillon correspond un $\hat{Y}$, qui
 d\'epend de $n$ (fini) et du mode de tirage. Avec l'approche traditionnelle,
 le fait que le mode de tirage soit avec ou sans remise affecte la distribution
 d'\'echantillonnage.\footnote{\hspace{1.5pt} Notons au passage que ``fini'' ne
 veut pas dire petit. Si la population a une taille de
 1\hspace{1.5pt}000\hspace{1.5pt}000 d'individus ou plus, un \'echantillon fini
 de taille 10\hspace{1.5pt}000, c'est relativement petit ($1/100^e$), mais grand
 dans l'absolu, suffisamment grand pour obtenir des statistiques pr\'ecises.
 L'enqu\^ete Budget des Familles est un exemple. En revanche, si vous avez une
 population de taille 1\hspace{1.5pt}000, un \'echantillon fini de taille 100
 p\`ese ``10 fois plus que'' pr\'ec\'edemment ($1/10^e$), mais 100 c'est
 ``petit'' pour obtenir des statistiques pr\'ecises.} En r\'esum\'e, dans
 l'approche traditionnelle, dans laquelle les $Y_i$ ne sont pas consid\'er\'es
 al\'eatoires, la distribution de $\hat{Y}$ d\'epend du mode de tirage
 (TSR ou TAR), donc de $n$ et $N$. En revanche, dans le mod\`ele
 d'\'echantillonnage, elle d\'epend de $n$ et de la loi suivie par $Y_i$
 (le mode de tirage est un TAR).
 
 Voyons ce que l'on entend par ``pr\'ecision''.
 
\large
\begin{flushleft}
\textbf{3.1 Pr\'ecision de la moyenne dans le mod\`ele d'\'echantillonnage}
\end{flushleft}

Comment mesure-t-on g\'en\'eralement la pr\'ecision de la moyenne -- dans la
 th\'eorie fr\'equentiste ? Par l'\fbox{erreur type} $\sqrt{V(\hat{Y})}$. Or,
 $$V(\hat{Y})=V(\sum_iY_i/n)=(1/n)^2\sum_iV(Y_i)=(1/n)^2n\sigma^2=\sigma^2/n.$$
 L'erreur-type d\'epend donc de l'\'ecart-type $\sigma$ de la variable $Y$ et
 de $n$ : $\sqrt{\sigma^2/n}=\sigma/\sqrt{n}$. L'estimateur de $\sigma^2$
 g\'en\'eralement employ\'e est 
 $$\frac{1}{n-1}\sum_{i=1}^n(Y_i-\hat{Y})^2\equiv\hat{\sigma}_c^2.$$
 La pr\'ecision est donc $$\frac{\hat{\sigma}_c}{\sqrt{n}}=
 \left(\frac{1}{n(n-1)}\sum_{i=1}^n(Y_i-\hat{Y})^2\right)^{1/2}.$$ Il suffit
 ensuite de remplacer les $Y_i$ par les valeurs observ\'ees de notre unique
 \'echantillon, et $\hat{Y}$ par la moyenne de l'\'echantillon
 (\textit{plug-in}).

 Voyons un exemple avec $n=3$ pour faire simple : $y_1=6$, $y_2=2$ et $y_3=8$. 
***/

cls
clear 	all
set 	obs	3
input 	long var1
6
2
8
sum 	var1
* On calcule nous-meme l'erreur-type
di 		r(sd)/sqrt(r(N))
* Pareil avec la commande ci de Stata
ci 		var1

/***
La commande \ttfamily summarize var1\ \normalfont renvoie l'\'ecart-type de
 la variable \ttfamily var1.\normalfont Il suffit de diviser l'\'ecart-type par
 $\sqrt{3}$ pour avoir l'erreur-type. La commande \ttfamily ci var1\
 \normalfont fournit l'erreur-type directement, et un intervalle de confiance
 non-asymptotique \`a 95\%. Afin de construire l'intervalle, nous avons besoin 
 non pas du fractile d'une N(0,1), mais d'une Student du fait de la taille de
 l'\'echantillon. Il y a 97,5\% de chances qu'une variable al\'eatoire
 distribu\'ee selon un loi de Student \`a 2 degr\'es de libert\'e prenne une
 valeur plus petit que 4,302 environ. Nous pouvons obtenir cette valeur avec
 \ttfamily di invttail(2,0.025) :\normalfont
***/

display invttail(2,0.025)
/***
 La borne inf\'erieure de l'intervalle est bien environ \'egale \`a
 $5,333-4,302\times 1,763$.\bigskip
 
Une \underline{simulation Monte Carlo} va nous permettre d'avoir une id\'ee plus
 claire de ce que l'on entend par ``pr\'ecision''. Le bootstrap, que nous
 verrons en fin de section, nous donnera un point de vue
 \underline{fr\'equentiste}.
 
\begin{flushleft}
\textbf{Exercice}.\ \\ 1. D\'emontrer que $\hat{\sigma}_c^2/n$ est un
 estimateur sans biais de $\sigma^2/n$.\\ 2. Peut-on en d\'eduire que
 $\hat{\sigma}_c/\sqrt{n}$ est un estimateur sans biais de $\sigma/\sqrt{n}$ ?\\
 3. Quelle m\'ethode pourrions-nous utiliser pour calculer
 $E(\hat{\sigma}_c/\sqrt{n})$ ?
\end{flushleft}

\begin{flushright}
 \begin{minipage}{12cm}
  \small\textbf{\textit{Remarque}} La question 2 vise \`a attirer l'attention
  sur le fait que montrer que $\hat{\sigma}_c^2/n$ est une estimateur sans biais
  de $\sigma^2/n$ n'implique pas que $\hat{\sigma}_c/\sqrt{n}$ est un estimateur
  sans biais de l'erreur-type $\sigma/\sqrt{n}$. En effet, de 
  $E(\hat{\sigma}_c^2/n)=\sigma^2/n$ on peut
  d\'eduire $\sqrt{E(\hat{\sigma}_c^2/n)}=\sigma/\sqrt{n}$. Tandis que 
  $E(\hat{\sigma}_c/\sqrt{n})=E(\sqrt{\hat{\sigma}_c^2/n})$, est l'esp\'erance
  de la racine de la statistique sans biais. Or, d'apr\`es l'in\'egalit\'e de Jensen,
  si $E(\hat{\sigma}_c^2)<\infty$, alors $\sqrt{E(\hat{\sigma}_c^2/n)}\le 
  E(\sqrt{\hat{\sigma}_c^2/n})$. Par cons\'equent, l'estimateur propos\'e est
  plus petit, en moyenne, que $\hat{\sigma}_c/\sqrt{n}$.\normalsize 
 \end{minipage}
\end{flushright}
  
Cette approximation n'est pas si grave, car ces mesures tendent
 tr\`es vite vers z\'ero. En effet, la loi faible des grands nombres (LFGN, 
 par la suite) garantit que -- sous certaines conditions -- la pr\'ecision de la 
 moyenne augmente assez vite quand $n$ augmente. Combien faut-il d'observations
 pour que la pr\'ecision double ? On peut r\'epondre \`a cette question en 
 utilisant la m\'ethode Monte Carlo vue dans la \textbf{Section 2}.
***/

clear all
set seed 21041971
set more off
* Taille de la (super)population
set	obs	10000
* Nombre de tirages dans la (super)population
set matsize 1000
* Loi de Y
generate Y=rnormal(100,10)

* Vecteur de tirage initialise a 0
generate RANK=0

matrix V1=J(1,1000,0)
forvalues I=1(1)1000 {
 quietly replace RANK=runiform()
 sort RANK
 quietly summarize Y in 1/80
 matrix define V1[1,`I']=r(mean)
}
drop Y RANK

* Trasforme le vecteur des 1000 statistiques en variable
matrix V2=V1' 
svmat V2, names(MEAN_)
* Vire les missing au passage
keep if	MEAN_1!=.

* Recupere les centiles extremes (1 et 99)
summarize MEAN_1, d
display	"r(p1) = " r(p1) " , r(p99) = " r(p99)

* Distribution de probabilit\'e
twoway hist	MEAN, bin(20) gap(10) fraction ///
			title("Distribution Monte Carlo de la moyenne") ///
			xline(`r(p1)' `r(p99)') xscale(noline) ///
			xtitle("Moyenne t(x)") ytitle("Pr(t(X) = t(x))") ///
			scheme(s1mono)

/**/
graph export "statainitiation_3_distributionofthemean.png", width(400) replace
/**/

/***
\newpage
\begin{center}
\small\textbf{Graphique 3.1}. Distribution Monte Carlo de la moyenne\normalsize
\end{center}
\includegraphics{statainitiation_3_distributionofthemean.png}
\bigskip

Plus l'\'echantillon est grand, plus la dispersion Monte Carlo autour de la
 moyenne, $\sigma/\sqrt{n}$ tend vers z\'ero. Les deux barres verticales rouges 
 d\'elimitent un intervalle de confiance \`a 98\%.
 L'intervalle de fluctuation asymptotique est $100\pm 2,326\times10/\sqrt{80}$,
 qui vaut [97,39 ; 102,6], o\`u 2,326 est obtenu par \ttfamily
 \textbf{invnormal(.99)}\normalfont. On peut voir que si on quadruple la taille
 de l'\'echantillon (remplacer \textbf{\ttfamily quietly summarize Y in 1/80\
 \normalfont} par \textbf{\ttfamily quietly summarize Y in 1/320 \normalfont},
 \underline{la pr\'ecision double}, c'est-\`a-dire, la longueur de l'intervalle 
 qui contient 98\% des moyennes est divis\'ee par 2 ; l'intervalle passe
 d'environ [97,4 ; 102,8] \`a [98,8 ; 101,4]. En effet, $102,8-97,4$ est environ
 \'egal \`a 5,4 et $101,4-98,8$ est environ \'egal \`a 2,6. Or,
 $5,2/2,6\approx 2$, la pr\'ecision double !).

Ce r\'esultat aurait pu \^etre obtenu analytiquement, puisqu'en th\'eorie,
 si $n$ et $n^\prime>n$ sont deux tailles d'\'echantillons, alors le ratio des
 erreurs types vaut :
 $$\frac{ \frac{\sigma}{\sqrt{n^\prime}}}{\frac{\sigma}{\sqrt{n}}}=
 \sqrt{\frac{n}{n^\prime}},$$
 qui vaut 1/2 si $n^\prime=4n$.
 
\newpage\large
\begin{flushleft}
\textbf{3.2 Tirage sans et avec remise, bootstrap}
\end{flushleft}

\begin{center}
 \fbox{
  \begin{minipage}{13cm}
   \begin{center}
    L'objet de cette section est d'estimer un intervale de confiance pour
	la moyenne d'un \'echantillon par la m\'ethode du bootstrap avec Stata.
	Dans un premier temps, nous rappelons les principes de tirage sans et avec
    remise dans les sondages (approche traditionnelle). 
   \end{center}
  \end{minipage}
  }
\end{center}
 
Le \fbox{bootstrap} repose sur un  
 \fbox{re-\'echantillonnage (\textit{re-sampling})} des observations : 
 cr\'eer des \'echantillons \`a partir de l'\'echantillon de 
 d\'epart. Cet \'echantillon de d\'epart est al\'eatoire. Les observations qui
 sont incluses dans les nouveaux \'echantillons construits \`a partir de
 celui de d\'epart, d\'ependent du mode de tirage. Avant d'aborder le bootstrap,
 nous faisons un petit d\'etour par les tirages dans les enqu\^etes
 (les sondages) dans l'approche traditionnelle. 
 
Il y a deux modes de tirages :
 \fbox{sans remise (\textit{without replacement})} (TSR) et 
 \fbox{avec remise (\textit{with replacement})} (TAR). Stata vous
 permet de tirer un \'echantillon dans une population selon ces deux modes de
 tirage, avec les commandes \ttfamily \textbf{sample}\ \normalfont et 
 \ttfamily \textbf{bsample}\normalfont, respectivement. Quel que soit le mode de
 tirage, deux probabilit\'es comptent : la probabilit\'e qu'une unit\'e
 d'observation appartienne \`a un \'echantillon particulier et la probabilit\'e
 de cet \'echantillon. Pour simplifier la pr\'esentation, on supposera que les 
 \'echantillons sont \'equiprobables.\footnote{\hspace{1.5pt} Notons que pour un
 mode de tirage donn\'e, les \'echantillons sont \'equiprobables si la base de 
 sondage est de bonne qualit\'e (identifiants des unit\'es statistiques clairs, 
 pas d'unit\'e en double, ni manquante, etc.).} 
 
La distribution d'\'echantillonnage de $\hat{Y}$ d\'epend du nombre
 d'\'echantillons possibles. Supposons qu'il n'y ait pas plus de $K$
 \'echantillons distincts $S_k$ de taille $n$ (la position des individus dans
 l'\'echantillon ne compte pas), \`a partir desquels on calcule les moyennes 
 $\hat{Y}_{n,1},\ldots,\hat{Y}_{n,K}$, o\`u $\hat{Y}_{n,k}$ est la moyenne dans
 l'\'echantillon $k$ de taille $n$. La moyenne des moyennes, i.e. la moyenne des
 $\hat{Y}_{n,k}$ est :
 $$\sum_{k=1}^{K}\hat{Y}_{n,k}\textnormal{Pr}(S_k).$$
 Les \'echantillons \'etant \'equiprobables, on a Pr$(S_k)=1/K$. $\hat{Y}_{n,k}$
 peut s\'ecrire $\hat{Y}_n$ et $S_k$ devient $S_n$ (les \'echantillons \'etant
 \'equiprobables, l'indice $k$ n'est plus pertinent). La moyenne ci-dessus
 devient $\sum_{k=1}^{K}\hat{Y}_{n,k}(1/K)=\hat{Y}_n$. Quant \`a
 $\hat{Y}_n$, elle vaut pr\'ecis\'ement :
 $$\hat{Y}_n=\frac{1}{n}\sum_{i\in S_n}Y_i=\frac{1}{n}\sum_{i=1}^{N}
 Y_i 1\hspace{-2.42pt}\textnormal{I}_{S_n}(i).$$ On a plus qu'\`a montrer que
 $E(\hat{Y}_n)$ est \'egal \`a $\bar{Y}$.
 
\large
\begin{flushleft}
\textbf{3.2.1 Tirage sans remise, \ttfamily sample\ \normalfont (le sondage
 al\'eatoire silmple)}
\end{flushleft}

La commande \ttfamily \textbf{sample}\ \normalfont fait un TSR. On peut montrer
 que dans un sondage al\'eatoire simple, la probabilit\'e que l'unit\'e
 d'observation $i$ soit tir\'ee vaut $n/N$. Cette probabilit\'e est appel\'ee
 \fbox{taux de sondage (\textit{sampling rate})}. On remarque que la
 probabilit\'e qu'un individu appartienne \`a l'\'echantillon ne d\'epend pas de
 l'individu (probabilit\'e dite constante). 

On a ce r\'esultat trivial malgr\'e le fait que les unit\'es d'observation
 successivement tir\'ees (sond\'ees), le sont avec des probabilit\'es qui,
 elles, sont diff\'erentes. En effet, les $i\in\mathcal{P}$ ont la m\^eme 
 probabilit\'e d'\^etre tir\'e au premier tour, $1/N$. En revanche, la $j$\`eme
 unit\'e d'observation a plus de chance d'\^etre tir\'ee (en moyenne) que
 la $(j-1)$\`eme, car elle est en ``concurrence'' avec moins d'unit\'es qu'au 
 tout pr\'ec\'edent. Les probabilit\'es pour les $n$ individus sont 
 respectivement $1/N,1/(N-1),\ldots,1/(N-n+1)$. En supposant que l'on range les
 $n$ individus c\^ote \`a c\^ote, chacun des \'echantillons de taille $n$ est
 une permutation parmis les $n!$ possibles.\footnote{\hspace{1.5pt} Avec $n=3$
 par exemple, l'\'echantillon $\{i_j,i_k,i_l\}$ ($n=3$) est le m\^eme que
 $\{i_k,i_l,i_j\}$, $\{i_l,i_j,i_k\}$, etc. On a $3!=6$ \'echantillons \'egaux.}
 Le nombre d'\'echantillons est alors \'egal \`a l'inverse de la probabilit\'e 
 d'\underline{un} \'echantillon, c'est-\`a-dire la probabilit\'e de tirer $n$ 
 individus dans la population de taille $N$. Cette probabilit\'e vaut :
 $$\begin{array}{rl}
  = & n!\frac{1}{N}\frac{1}{N-1}\cdots\frac{1}{N-n+1} \\
  = & n!\frac{1}{N}\frac{1}{N-1}\cdots\frac{1}{N-n+1}\frac{(N-n)!}{(N-n)!} \\
  = & \frac{n!(N-n)!}{N!}. \\
   \end{array}$$

Par cons\'equent, le nombre d'\'echantillons est simplement \'egal \`a 
 $N!/(n!(N-n)!)\equiv C_N^n$. Entre parenth\`eses, le nombre d'\'echantillons
 serait $C_{N+n-1}^n$ dans un TAR. 

Calculons maintenant le nombre d'\'echantillons dans lesquels figure un
 individu $i$ quelconque. On trouve $(N-1)!/((n-1)!(N-n)!)$.
 
\begin{flushleft}
\textbf{Exercice}.\ \\ 1. D\'emontrer que le nombre d'\'echantillons dans
 lesquels figure un individu $i$, quelconque, est $C_{N-1}^{n-1}$.\\ 2.
 Sachant que le nombre total d'\'echantillons de taille $n$ parmi $N$ est
 $C_N^n$, v\'erifier que la probabilit\'e que l'individu $i$ soit tir\'e est
 $n/N$.\bigskip
\end{flushleft}

Supposons par exemple $N=23$ et $n=4$. On a donc $C_{23}^4=8855$ \'echantillons
 distincts. Par ailleurs, il y a 1540 \'echantillons incluant $i$. Ainsi, la
 probabilit\'e que $i$ appartienne \`a l'\'echantillon tir\'e est \'egale \`a
 $1540/8855$ qui, apr\`es simplification, vaut bien $4/23$, soit environ 17,4\%.
 L'application de la commande \ttfamily \textbf{sample}\ \normalfont dans un
 petit exercice de simulation va nous permettre de v\'erifier cela. Nous
 allons utiliser \ttfamily \textbf{sample}\ \normalfont avec les commandes
 \ttfamily \textbf{preserve}\ \normalfont et \ttfamily
 \textbf{restore}\ \normalfont car \ttfamily \textbf{sample}\ \normalfont
 ne retient que l'\'echantillon tir\'e (les unit\'es qui ne sont pas tir\'ees
 sont d\'etruites).
 
On va supposer une population de 23 unit\'es pour une variable dont le
 logarithme est normalement distribu\'e (une variable log-normale), de
 param\`etres 5 et 1. On tirera 100 \'echantillons de taille 4 (c'est bien
 inf\'erieur \`a 8855, mais \c ca devrait \^etre suffisant pour v\'erifier les
 r\'esultats pr\'ec\'edents). On ne va pas faire appara\^itre les observations
 de chaque \'echantillon, mais les unit\'es d'observations tir\'ees dans chacun.
 Celles-ci sont plac\'ees dans une matrice $J$ de dimension 4 lignes-100
 colonnes, que l'on affichera en fin de programme.
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
Int\'eressons-nous \`a l'individu 14, par exemple. Il appara\^it 17 fois, soit
 17\% des \'echantillons, puisqu'on en a tir\'e 100. C'est proche de 17,4\%.
 Revenons \`a la th\'eorie et calculons $E(\hat{Y}_n)$ :
 $$\begin{array}{rcl}
  E(\hat{Y}_n) & = & \frac{1}{n}\sum_{i=1}^N Y_i 
  E(1\hspace{-2.42pt}\textnormal{I}_{S_n}(i)) \\ 
  & = & \frac{1}{n}\sum_{i=1}^N Y_i\textnormal{Pr}(i\in S_n) \\
  & = & \frac{1}{n}\sum_{i=1}^N Y_i (n/N) \\
  & = & \frac{1}{N}\sum_{i=1}^N Y_i \\
  & = & \bar{Y}.
   \end{array}$$

Le passage \`a la deuxi\`eme ligne utilise le r\'esultat 
 $E(1\hspace{-2.42pt}\textnormal{I}_{S_n}(i))=1\times\textnormal{Pr}(i\in S_n)
 +0\times\textnormal{Pr}(i\notin S_n)$.\footnote{\hspace{1.5pt} On appelle 
 Pr$(i\in S_n)$ une probabilit\'e d'inclusion d'ordre 1 (Ardilly et Till\'e, 
 2003, p. 2 ; Ardilly, 2006, pp. 54, 259).} Le r\'esultat 
 $E(\hat{Y}_n)=\bar{Y}$ est
 important, auquel on ne pr\^ete plus attention lorsque l'on calcule une moyenne
 arithm\'etique dans un \'echantillon. On oublie trop souvent que la valeur de
 cette statistique repose sur le mode de tirage. Ce r\'esultat est plus facile
 \`a montrer dans le cas de l'approche mod\`ele, quand les $Y_i$ sont
 al\'eatoires (cf. \textbf{haut de la page 4}). 
 
Que se passe-t-il lorsque les individus ont des probabilit\'es d'inclusion
 in\'egales ? C'est-\`a-dire quand certains types d'individus de la population 
 sont sous-repr\'esent\'es (ou les autres surrep\'esent\'es) ? La moyenne 
 est-elle toujours un bon estimateur ? Oui, mais \`a condition d'utiliser 
 l'\fbox{estimateur de Horvitz-Thompson} : 
 $$\hat{Y}_n=\frac{1}{N}\sum_{i\in\mathcal{S}_n}\frac{Y_i}{\textnormal{Pr}(i\in S_n)}=
 \frac{1}{N}\sum_{i=1}^N\frac{Y_i}{\textnormal{Pr}(i\in S_n)}
 \mbox{1\hspace{-0.25em}l}_{S_n}(i).$$ Notons que 
 $\sum_i\textnormal{Pr}(i\in S_n)=n$ (ce qui est trivial quand les 
 probabilit\'es sont \'egales puisque 
 $\sum_i\textnormal{Pr}(i\in S_n)=N(n/N)=n$). La d\'emonstration d'absence de
 biais n'est pas compliqu\'ee :
 $$\begin{array}{rcl}
 E(\hat{Y}_n) & = & \frac{1}{N}\sum_{i=1}^N\frac{Y_i}{\textnormal{Pr}(i\in S_n)}
  E(1\hspace{-2.4pt}\textnormal{I}_{S_n}(i)) \\
  & = & \frac{1}{N}\sum_{i=1}^N\frac{Y_i}{\textnormal{Pr}(i\in S_n)}\textnormal{Pr}(i\in S_n) \\
  & = & \bar{Y}. \\
   \end{array}$$

\newpage\large
\begin{flushleft}
\textbf{3.2.2 Tirage avec remise, \ttfamily bsample\normalfont}
\end{flushleft}

Comme pr\'ec\'edemment, on suppose que $Y_i$ n'est pas al\'eatoire, c'est le
 tirage qui l'est. La d\'etermination de la probabilit\'e d'inclusion pourrait
 sembler plus compliqu\'ee, du fait qu'un individu peut appara\^itre plusieurs
 fois dans l'\'echantillon. On est renvoy\'e \`a la loi multinomiale.
 Si l'on note le vecteur $(f_1,\ldots,f_N)$, o\`u $f_i$ est le nombre de fois 
 o\`u l'individu $i$ est dans l'\'echantillon de taille $n$, avec $\sum f_i=n$.
 Alors $(f_1,\ldots,f_N)$ suit une loi multinomiale $M(n ; p_1,\ldots,p_N)$,
 avec $p_i=1/N$ (on suppose que chaque unit\'e est repr\'esent\'e une fois dans
 la population, situation de probabilit\'es \'egales). Dans ce cas, 
 $E(f_i)=np_i=n/N$ (Tassi, \textit{ibid}, p. 19). Notons 
 $\hat{Y}_n=n^{-1}\sum_i^NY_if_i$, alors :
 $$\begin{array}{rcl}
  E(\hat{Y}_n) & = & \frac{1}{n}\sum_{i=1}^N Y_i E(f_i) \\ 
  & = & \frac{1}{n}\sum_{i=1}^N Y_i (n/N) \\
  & = & \frac{1}{N}\sum_{i=1}^N Y_i \\
  & = & \bar{Y}.
  \end{array}$$
 
Nous allons appliquer les m\'ethodes de cette section sur un petit jeu de
 donn\'ees. Le tableau suivant liste la capitalisation de 23 entreprises du web,
 les GAFA, les NATU (ph\'enom\`ene d'Ub\'erisation associ\'e \`a l'usage des
 technologies num\'eriques), les BATX et d'autres entreprises importantes telles
 que Microsoft, Twitter, etc. Pour donner un ordre de grandeur, le PIB
 fran\c cais de 2017 en dollars am\'ericains \'etait de 2750 milliards, ce qui
 est inf\'erieur \`a la capitalisation des quatre premiers g\'eants du web 
 (3199 milliards). La somme des capitalisations d'Apple et Amazon est \`a peu
 pr\`es \'egale \`a celle des 40 entreprises du CAC40 r\'eunies !
 
Nous avons utilis\'e des caract\`eres gras pour les GAFAM, italiques pour les
 NATU et soulign\'e les BATX. Nous avons \'egalement ajout\'e une variable de
 stratification qui permet de regrouper -- un peu \`a la louche -- chaque 
 entreprise en fonction de son secteur d'activit\'e, afin de souligner 
 l'h\'et\'erog\'en\'eit\'e des entreprises du web. Cette variable sera 
 utilis\'ee plus tard. Nous pourrions rajouter une variable `pays d'origine', 
 certains g\'eants \'etant am\'ericains, d'autres chinois, etc.
 
Certaines strates n'ont qu'une observation, les strates 4, 7 et 8. Nous avons
 obtneu ce r\'esultat en tapant \ttfamily \textbf{table STR}\normalfont\ 
 apr\`es avoir charg\'e les donn\'ees.
%
 \input{statainitiation_3_capitalisation}
%

%
 \includegraphics{statainitiation_3_capitalisation.png}
%

\newpage\noindent
Les entreprises list\'ees dans ce tableau constituent notre base de sondage,
 $\mathcal{P}=\{\textnormal{Apple, Amazon},\ldots,\textnormal{LinkedIn}\}$
 ($N\equiv23$). Nous d\'esirons estimer sans biais $\bar{Y}$, la
 capitalisation moyenne dans la population, \`a partir d'un \'echantillon de
 taille $n=4$.

Nous avons rentr\'e les donn\'ees du tableau directement \`a la main dans le
 \textbf{\ttfamily Data Editor\ \normalfont} de Stata puis arrang\'e un peu le 
 code :
***/

use	"http://www.evens-salies.com/statainitiation_3_capitalisation.dta", clear	
rename	(var*)(CAP STR TEMP)
encode	TEMP, generate(NOM)
drop	TEMP
order	NOM
sort	NOM

/*** 
On parle de \fbox{r\'e-\'echantillonnage} ou \textit{resampling} ! Pour que vous
 voyez bien ce qui se passe, je suppose que bien que la population comporte 23
 entreprises, je on ne peut obtenir qu'un 4-\'echantillon (avec remise). Cet
 exemple est alors facile \`a extrapoler \`a des situations o\`u $n$ et $N$ sont
 plus grands). Comme nous venons de le voir, une entreprise a 17,4\% de chances
 environ d'\^etre dans l'\'echantillon bootstrap. La loi de la variable
 \ttfamily \textbf{CAP}\ \normalfont dans la population m'\'etant inconnue, je
 ne sais rien \textit{a priori} de la distribution th\'eorique de sa moyenne
 dans l'\'echantillon al\'eatoire, ni de l'erreur standard. La m\'ethode
 bootstrap est appropri\'e dans ce cas, m\^eme s'il n'est pas recommend\'e de
 l'appliquer \`a un \'echantillon si petit. Notons donc une distinction entre le
 bootstrap et la m\'ethode Monte Carlo, qui est que dans une simulation Monte
 Carlo (dans le Bootstrap) on fait (ne fait pas) de supposition sur la loi
 suivie par la variable al\'eatoire de la population dont on souhaite calculer
 une statistique.

Nous allons voir la commande de r\'e-\'echantillonnage \ttfamily
 \textbf{bsample}\ \normalfont avant d'utiliser 
 \ttfamily \textbf{bootstrap}\normalfont. Le nombre de $n$-\'echantillons 
 dans un TAR est tr\`es grand, $N^n$. Le nombre d'\'echantillons distincts est
 $C_{2n-1}^n$ dans le cas o\`u l'on re-\'echantillonne toutes les observations.
 C'est le cas $N=n$ (par exemple, si $N=n=4$, il y aurait 35 \'echantillons
 distincts possibles). Mais si $N=23, n=4$, le nombre d'\'echantillons distincts
 est donn\'e par la formule $C_{N+n-1}^n=C_{26}^4=14950$. La commande 
 \ttfamily \textbf{bsample}\ \normalfont s'utilise comme la commande 
 \ttfamily \textbf{sample}\ \normalfont :
***/

preserve
 bsample	4
 save		"statainitiation_3_bsample.dta", replace
 list		NOM
restore

/*** 
Vous pouvez ex\'ecuter ce programme plusieurs fois ; vous pouvez tomber sur un
 4-\'echantillon avec une r\'ep\'etition \underline{d'au moins une} entreprise.
 La probabilit\'e que cela arrive est cependant faible.
 
\begin{flushleft}
\textbf{Exercice}.\ \\ Quelle est la probabilit\'e que vous obteniez au moins
 deux fois la m\^eme entreprise ?\bigskip
\end{flushleft}

Cette probabilit\'e est le compl\'ement \`a 1 d'obtenir au plus une fois la
 m\^eme entreprise. C'est donc la probabilit\'e qu'elle ne soit pas incluse
 dans l'\'echantillon ou qu'elle n'y soit qu'une fois. Ces deux \'ev\'enements
 \'etant incompatibles, il faut sommer leur probabilit\'es. Le nombre 
 d'\'echantillons de taille $n$ sans l'individu 1 par exemple est \'egal \`a
 $(N-1)^n$. Quant au nombre d'\'echantillons o\`u l'individu 1 n'est inclu
 qu'une fois, il est \'egal \`a $n(N-1)^{n-1}$. C'est le nombre de 
 sous-\'echantillons sans l'unit\'e 1, que l'on recompose ensuite en mettant cet
 individu dans l'une des $n$ positions possibles. Enfin, le nombre total 
 d'\'echantillons est $N^n$.
 La probabilit\'e recherch\'ee vaut donc  
 $$1-\frac{(N-1)^n}{N^n}-\frac{n(N-1)^{n-1}}{N^n}.$$ Avec nos param\`etres, 
 cela donne environ 1,07\%.\bigskip

On peut aussi utiliser \ttfamily \textbf{bsample}\ \normalfont en tenant compte
 de l'information renvoy\'ee par la variable de stratification 
 \ttfamily \textbf{STR}.\ \normalfont L'int\'er\^et de faire cela est qu'on est
 s\^ur que toutes les strates seront repr\'esent\'ees. Cependant, certaines
 strates n'ont qu'une unit\'e dans la population (4, 7 et 8), alors que
 trois strates (1,2 et 3) en ont 15 \`a elles seules. Dans l'exemple qui suit,
 on produit cinq \'echantillons de deux TAR. On remarque que dans la strate 6,
 il y a de fortes chances que l'\'echantillon renvoie la m\^eme unit\'e
 d'\'echantillonnage dans la mesure o\`u il n'y a que deux unit\'es dans cette
 strate au d\'epart.
***/

preserve
* Les strates avec une seul entreprises, 4, 7 et 8, correspondent au noms
* encodes 4, 15 et 16
 bsample	2 if NOM!=4&NOM!=15&NOM!=16, strata(STR)
 save		"statainitiation_3_bsample.dta", replace
 list
restore

/*** 
Si on re-\'echantillonne toutes les observations, on tire une unit\'e au hasard,
 on la remet, on fait cela 23 fois. Nous avons tout de suite l'intuition que le
 nombre d'\'echantillons bootstrap possibles est t\'eoriquement \'enorme. Rien
 que le nombre d'\'echantillons \underline{distincts} cro\^it tr\`es vite avec
 $n$, comme on peut le voir pour $n=1,\ldots,10$ (on a des \'echantillons de
 taille 1 \`a 10, et on re-\'echantillonne tout ) :
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
\ \\[-36pt] L'accroissement est ``exponentiel'', de sorte qu'il est pratiquement
 impossible de voir tous les \'echantillons possibles. Vu que les \'echantillons
 sont al\'eatoires, la probabilit\'e que certains ne soient pas tir\'es n'est
 pas nulle. Ce n'est que dans le cas de $n$ tr\`es petit, que l'on est presque
 certain que tous les \'echantillons possibles seront tir\'es. Par exemple, dans
 le cas $N=n=3$, $\mathcal{S}=\{1,2,3\}$, on a les \'echantillons suivants :
 \{1,1,1\}, \{2,2,2\}, \{3,3,3\}, \{1,1,2\}, \{2,2,1\},
 \{1,1,3\}, \{3,3,1\}, \{2,2,3\}, \{3,3,2\}, \{1,2,3\}.

\large
\begin{flushleft}
\textbf{3.3 Protocole exp\'erimental}
\end{flushleft}

Le protocole exp\'erimental vient normalement juste apr\`es l'\'etape 
 d'\'echantillonnage, mais avant l'\'etape d'inf\'erence (estimation, test)
 sur le mod\`ele statistique. Chez les statisticiens, la sp\'ecification fait
 elle aussi partie du protocole (\textit{design}).

Il y a plusieurs types de protocoles exp\'erimentaux (mani\`eres d'exposer des
 individus \`a telle ou telle intervention), selon le contr\^ole que l'on a
 sur le processus \'economique \'etudi\'e. C'est ce que vous verrez l'an
 prochain notamment dans le cours M\'ethodes Statistiques de l'\'Evaluation.
 L'exposition des individus \`a telle ou telle intervention ressemble \`a
 l'affectation de ces individus dans les \fbox{groupes de traitement}, comme
 dans les sciences biom\'edicales. On parle de \fbox{m\'ecanisme d'affectation}
 des traitements aux individus.\footnote{\hspace{1.5pt} Imbens, G.W., Rubin,
 D.B. 2015. \textit{Causal Inference for Statistics, Social, and Biomedical
 Sciences}. Cambridge University Press, Cambridge, USA, 625 pp.}

Dans la \textbf{section 1}, nous avions introduit un exemple tir\'e de l'article
 de Rubin (1977), dans lequel le traitement prenait deux \'etats possibles pour
 des \'el\`eves de CM1 aux \'Etats-Unis. Il y a ce que l'on appelle la version
 active du traitement (l'\'el\`eve suit un nouveau programme de math\'ematique),
 et la version de contr\^ole (l'\'el\`eve reste sur l'ancien programme). Le
 m\'ecanisme le plus simple, et le m\'ecanisme al\'eatoire contr\^ol\'e, aussi
 appel\'e \fbox{randomisation}, ou \fbox{\textit{randomized controlled trial}},
 ou tout simplement \fbox{\textit{experiment}}. Dans le cas o\`u il n'y a
 aucune contrainte sur le nombre d'individus affect\'es dans l'un des groupes
 de traitement, on a ce que l'on appelle un m\'ecanisme de Bernoulli, qui est
 exactement comme le tirage al\'atoire simple.

Supposons un \'echantillon de taille $n$, et les deux programmes consid\'er\'es
 par Rubin : le programme 1 (le cours am\'elior\'e) et 2 (le cours comme avant).
 On mod\'elise le m\'ecanisme \`a l'aide d'une variable, $D$, qui prend la
 valeur 1 si l'individu est dans le programme 1, et 0 sinon. Quelle est la loi
 suivie par $D$ ? Tout d\'epend du m\'ecanisme d'affectation. Si on d\'ecide
 que le m\'ecanisme est un m\'ecanisme de Bernoulli, on a tout simplement : 
 $$\textnormal{Pr}(D=1)=\frac{1}{2}.$$

Le probl\`eme de ce m\'ecanisme, est qu'on peut se retrouver avec tous les
 individus dans un seul groupe. Du coup, on pr\'ef\`ere g\'en\'eralement un
 m\'ecanisme pleinement randomis\'e (\fbox{completely randomized experiment}),
 qui pioche $n_1$ \'el\`eves au hasard dans l'\'echantillon, et les affecte au
 programme 1. La probabilit\'e pour un \'el\`eve de suivre les programme 1 est :
 $$\textnormal{Pr}(D=1)=\frac{n_1}{n}.$$ La d\'emonstration est exactement la
 m\^eme que celle pour le tirage al\'eatoire simple, selon lequel une unit\'e
 d'observation avait $n/N$ chances de se retrouver dans l'\'echantillon.

\begin{flushleft}
\textbf{Exercice}.\ \\ Montrer que la probabilit\'e qu'un \'el\`eve soit
 expos\'e au programme 1 est $n_1/n$.
\end{flushleft}

Rubin (1977) a \'et\'e plus loin en affectant les \'el\`eves sur la base d'une
 note obtenue avant de mettre en place le nouveau programme. Soit $X$ cette
 note, une variable al\'eatoire. On parle de variable de pr\'e-traitement, ou
 de \fbox{\textit{baseline outcome}}. Il s'agit d'une note entre 0 et 100, le
 fameux SAT am\'ericain, telle que lorsque vous avez 100, cela veut dire que
 100\% des autres autres \'el\`eves que vous ont une note inf\'erieure \`a la
 votre. Le m\'ecanisme est un peu plus sophistiqu\'e :
 $$\textnormal{Pr}(D=1|X=x)=\frac{100}{100+x}.$$ Ainsi, pour chaque valeur 
 $x$, par exemple, $x=50$, $\textnormal{Pr}(D=1|X=50)=2/3$, soit 66\% de chance
 de suivre le nouveau programme. Pour $x=80$, $\textnormal{Pr}(D=1|X=80)=5/9$,
 soit 55\% de chance de suivre le nouveau programme.

Le programme suivant affecte les \'el\`eves selon ce m\'ecanisme. Nous ne
 retrouvons pas les affectations de Rubin (1977), qui ne d\'etaille pas son
 m\'ecanisme. La technique que nous utilisons est la suivante. Apr\`es avoir
 calcul\'e la probabilit\'e $100/(100+x)$ pour chaque $x$ (nous convertissons
 $X$, qui est une note sur 10 en SAT, en prenant $10\times X$), nous comparons
 cette probabilit\'e au fractile d'une loi uniforme 0-1, d'esp\'erance 1/2.
 Si la probabilit\'e est sup\'erieure \`a 1/2, on met l'\'el\`eve dans le
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

quietly log close

/***
\end{document}
***/

markdoc		statainitiation_3_sampling, ///
 linesize(180) texmaster export(pdf) markup(latex) replace
