# BattleShip
 * miniPROJET 2016/2017	UPEC				THIRUCHELVAM Thivagaran
 * Cours Programmation Fonctionelle
  
Le but de ce projet est de faire un jeu : un clone de Bataille Navale. L'objectif de BattleShip est d'essayer de couler tous les autres joueurs avant qu'ils ne coulent tous vos navires. Chaque joueur cache des navires sur une grille contenant des coordonnées verticales et horizontales. Les joueurs choisissent à tour de rôle les coordonnées des lignes et des colonnes de la grille de l'autre joueur pour tenter d'identifier une case qui contient un navire.  

Pour lancer faire make puis "./fleet" 

SUR LA PREMIERE GRILLE : 

Placez la souris sur une case puis choisissez sur le clavier un numéro entre 1 et 5 (qui correspond au taille des navires)
Puis choisissez une lettre h ou b ou g ou d (qui correspond respectivement l'orientation du navire (Haut,Bas,Gauche,Droite))
Vous pouvez changer l'orientation (h,b,g,d) avec la même taille du navire jusqu'a qu il y en est plus  et s il vous voulez changer de taille de navire il suffit de choissir un autre numéro au clavier. Pour placer un navire sur une nouvelle case (nouvelle coordonnée) il suffit juste de placer la souris sur la case.
Si vous vous voyez que le navire se reaffiche pas c'est soit parce que le navire n'est plus disponible (c-a-d quantité : 0) ou soit vous pouvez pas le placer à cette case que vous avez choisie (c'est parce qu il y a un contact avec un autre navire).
Pour une taille 1 de navire il faut quand même choisir une orientation (h,b,g,d) pour pouvoir l'afficher.

Ne prenez pas en compte les messages affichés sur la fênetre.

SUR LA DEUXIEME GRILLE : 

Il suffit juste cliquer sur les case pour afficher les navires placer sur la première grille. 

Technologies utilisées : Ocaml, Sublime Text.
