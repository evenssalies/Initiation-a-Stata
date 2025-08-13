## Note sur les données des ventes en chais

### Source

Données issues des mercuriales (prix) mensuelles, de janvier 1995 à avril 1998.

### Description

- Trois variables : sorties des chais des récoltants ($Q$), prix moyens pondérés (FF/hl) courants ($P$) et le produit ($R$). Le prix tient compte du degré-hecto (moyen) des quantités (hL) de vin __négocié__ (pour être franc, je ne me rappelle plus des règles de calcul).
- Les vins dont des Côtes du Roussillon AOC, destinés à la commercialisation (vrac, bouteille), Blanc, Rouge et Rosé.
- Les ventes sont négociées : tant d'hL se vend au prix p, avec généralement $q'>q\Leftrightarrow p'(q')<p(q)$.

### Remarques

- Le prix moyen, environ 450 FF/hL en 1998 (68,6 €/hL en euros de 1998, 103,05 €/hL en euros 2023).
- Il y a deux valeurs abérantes dans le nuage $(p ; q)$ : observations 23 et 39. La première en octobre 1996 (471,6 ; 36368) et l'autre en février 1998 (492,59 ; 9614). Ce qui est remarquable, c'est que ces deux points ne sont plus abérants quand on les considère dans le nuage $(R ; q)$ (voir le point ci-dessous).

### Le plus grand coeffcient de corrélation de Pearson de tous les temps ?

Multiplier le prix mensuel $p$ par la quantité négociée $q$, appeler ce produit $R$, et calculer le coefficient de corrélation entre $R$ et $q$, vous obtiendrez un $\rho$ très proche de 1. J'ai pas mal réfléchi sur le fait d'avoir une demande $p(q)$ incompréhensible, alors que la recette $R(q)$ est pratiquement affine ! **À vos claviers !**.
