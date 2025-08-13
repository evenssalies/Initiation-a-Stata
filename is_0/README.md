## Note sur les données des ventes en chais

### Source

Les [données](is_0/statainitiation_0_vin.csv) sont issues des mercuriales (prix) mensuelles, de janvier 1995 à avril 1998.[^1]

### Description

- Trois variables : sorties des chais des récoltants ($Q$), prix moyens pondérés (FF/hl) courants ($P$) et le produit ($R$). Le prix tient compte du degré-hecto (moyen) des quantités (hL) de vin __négocié__ (pour être franc, je ne me rappelle plus des règles de calcul).
- Les vins dont des Côtes du Roussillon AOC, destinés à la commercialisation (vrac, bouteille), Blanc, Rouge et Rosé.
- Les ventes sont négociées : tant d'hL se vend au prix p, avec généralement $q'>q\Leftrightarrow p'(q')<p(q)$.
- Le prix moyen, environ 450 FF/hL en 1998 (68,6 €/hL en euros de 1998, 103,05 €/hL en euros 2023).

### Deux valeurs abérantes ?

Il y a deux valeurs abérantes dans le nuage $(p ; q)$ : observations 23 et 39. La première en octobre 1996 (471,6 ; 36368) et l'autre en février 1998 (492,59 ; 9614). Ce qui est remarquable, c'est que ces deux points ne sont plus abérants quand on les considère dans le nuage $(R ; q)$ (voir le point ci-dessous).

### Le plus grand $\rho$ (pardon !) de tous les temps ?

Multiplier le prix mensuel $p$ par la quantité négociée $q$, appeler ce produit $R$, et calculer le coefficient de corrélation entre $R$ et $q$, vous obtiendrez un $\rho$ très proche de 1. J'ai pas mal réfléchi sur le fait d'avoir une demande $p(q)$ incompréhensible, alors que la recette $R(q)$ est pratiquement affine ! **À vos claviers !**.

[^1]: j'ai perdu le fichier Excel d'origine, créé par un étudiant en 2000, Laurent Cutzach. Laurent avait réalisé un mémoire sous ma co-direction avec Philippe Mahenc [^2] : ``Le marché des vins tranquilles à A.O.C. des Pyrénées Orientales'', dans lequel il estimait l'élasticité-prix de la demande des vins doux en région Occitanie (Languedoc-Roussillon à l'époque).

[^2]: [Philippe Mahenc](https://www.cee-m.fr/member/mahenc-philippe/), professeur à Montpellier, organisait les travaux dirigés de Théorie des jeux en Master (Maîtrise à l'époque) à la fin des années 1990 lorsque j'étais étudiant à l'Université de Sciences Economiques de Toulouse (Place Anatole France (les cours étaient donnés par [Michel Moreaux](https://www.tse-fr.eu/fr/michel-moreaux-1941-2021).
