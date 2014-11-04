// Definir une fonction pour recevoir les donnees du port serie:
void serialEvent(Serial p) {

  // Lire le message.
  String chaine = p.readString();

  // Separer les elements du message
  // selon les espaces:
  String[] tableauDeChaines = splitTokens(chaine);

  // S'assurer qu'il y a bien deux mots
  // dans le message et les appliquer aux variables :
  if ( tableauDeChaines.length == 2 ) {
    String premier = tableauDeChaines[0];
    int deuxieme = int(tableauDeChaines[1]);
    // On peut "router" les messages en comparant le premier element :
    if ( premier.equals("interaction")) {
      if (deuxieme == 1)
      {
        interaction = true;
      } else
      {
        interaction = false;
      }
    }
    if ( premier.equals("ledDroit")) {
      ledPhotoDroit = deuxieme;
    }
    if ( premier.equals("ledGauche")) {
      ledPhotoGauche = deuxieme;
    }
    if ( premier.equals("valPiezo")) {
      valPiezo = deuxieme;
    }
      if ( premier.equals("valAccelero")) {
      valAccelero = 1023 - deuxieme;
    }
  }
}

