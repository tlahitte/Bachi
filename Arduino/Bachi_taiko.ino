//interval entre chaque releve de valeur en ms
unsigned long interval = 20;
unsigned long previousMillis;

int ledPhotoGauche;
int ledPhotoDroit;
int valeurPhotoGauche;
int valeurPhotoDroit;
boolean interaction = false;
int valPiezo;
int valAccelero;

//valeur des Pins utilisees sur Arduino
int piezoPin = 5;
int photoGauchePin = 0;
int photoDroitPin = 1;
int acceleroPin = 3;

void setup() {
  // Il n'y a aucune configuration nÃ©cessaire de la broche
  // pour une entrÃ©e analogique.

  // Communication du port Serie a 57600 bauds pour communication avec Processing
  Serial.begin(57600);
  pinMode(3,OUTPUT);
}

void loop() {

  if ( millis() - previousMillis >= interval ) {
    previousMillis = millis();

    // Lire la tension aux entrees analogique relie aux photosenseurs
    valeurPhotoGauche = analogRead(photoGauchePin);
    valeurPhotoDroit = analogRead(photoDroitPin);
    valPiezo = analogRead(piezoPin);
    valAccelero = analogRead(acceleroPin);

    //envoie de donnee sur port serie pour debugg 
    //Serial.print("photoDroit ");
    //Serial.println(valeurPhotoDroit);
    //Serial.print("photoGauche ");
    //Serial.println(valeurPhotoGauche);
    Serial.print("interaction ");
    Serial.println(interaction);


    // Recuperation valeurs photosenseurs
    ledPhotoGauche = returnPhoto(valeurPhotoGauche, ledPhotoGauche);
    ledPhotoDroit = returnPhoto(valeurPhotoDroit, ledPhotoDroit);

    Serial.print("ledDroit ");
    Serial.println(ledPhotoDroit);
    Serial.print("ledGauche ");
    Serial.println(ledPhotoGauche);

    // Analyse des valeurs et activation de l'interaction
    if (ledPhotoDroit+ledPhotoGauche >= 256)
    {
      interaction = true;
    } 
    else
    {
      interaction = false;
    }

    //les valeurs du piezo seront calibres et traite dans Processing
    Serial.print("valPiezo ");
    Serial.println(valPiezo);
    Serial.print("valAccelero ");
    Serial.println(valAccelero);

    //Envoie valeur PWM au baton gauche et droit, les valeurs en PWM permettent le fade-in, fade-out des lumieres
    analogWrite(3,ledPhotoGauche);
    analogWrite(5,ledPhotoDroit);

  }

}














































