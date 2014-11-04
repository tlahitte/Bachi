  void oscParsing(String nom, int valeur) {
    OscMessage myMessage = new OscMessage(nom);

    myMessage.add(valeur); // add an int to the osc message

    // send the message
    oscP5.send(myMessage, myRemoteLocation);
  }
