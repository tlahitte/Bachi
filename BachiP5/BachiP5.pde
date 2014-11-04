/*========== Bachi_taiko ==========
 par Tommy LAHITTE
 cours EDM4640 - Électronique, mécanique et médias interactifs
 UQAM - Automne 2014
 tlahitte@gmail.com
 https://github.com/tlahitte/Bachi_taiko
 =================================*/

import processing.serial.*;
import org.openkinect.*;
import org.openkinect.processing.*;

// Kinect Library object
Kinect kinect;
//oscP5
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;

//valeur seuil de profondeur Kinect
float threshold = 1.2;

// Size of kinect image
int w = 640;
int h = 480;

// We'll use a lookup table so that we don't have to repeat the math over and over
float[] depthLookUp = new float[2048];

// nom du port Serial utilise par Arduino
String portName = "/dev/tty.usbmodem411";

// Declarer une instance de la classe Serial:
Serial serial;

//valeurs senseurs envoyees depuis Arduino
boolean interaction;
int choc;
int ledPhotoDroit;
int ledPhotoGauche;
float ledGlobal;
int valPiezo;
int valAccelero;

//Valeurs utiles a la calibration du senseurs piezo
float minPiezo = 1023;
float maxPiezo = 0;
float minAccelero = 1023;
float maxAccelero = 0;
boolean interfaceActive = false;
boolean affichageKinect = true;
boolean calibration = false;
boolean audioEnable = false;
float calibrated;
float calibrAccelero;
int chrono;

//valeur utile au filtre passe-haut (hip)
float hip = 0;
float hipPrevious = 0;
float hipFactor = 0.9;

//Couleur
color A = color(25, 120, 255);
color B = color(38, 255, 221);
color mainColor;
float facteurLerp;

void setup() {
  size(displayWidth, displayHeight, P3D);
  frameRate(30);

  // start oscP5, telling it to listen for incoming messages at port 5001 */
  oscP5 = new OscP5(this, 5002);

  // set the remote location to be the localhost on port 5001
  myRemoteLocation = new NetAddress("127.0.0.1", 5002);

  //cam = new PeasyCam(this, 0, 0, 0, -100);

  //KINECT INITIALISATION
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);
  // We don't need the grayscale image in this example
  // so this makes it more efficient
  kinect.processDepthImage(false);

  // Lookup table for all possible depth values (0 - 2047)
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }

  //ARDUINO COMMUNICATION
  // Creer une instance de la classe Serial avec
  // une vitesse de 57600 baud:
  serial = new Serial(this, portName, 57600);

  // Indiquer a l'instance serial de lancer la fonction serialEvent()
  // lorsque l'octet 13 est recu. L'octet 13 est envoye par
  // l'Arduino pour indiquer la fin du message
  serial.bufferUntil(13);
}


void draw() {
  background(0);
  mainColor = lerpColor(A, B, facteurLerp);
  //***********************  CALIBRATION *********************
  //Appel des fonctions de calibration si necessaire
  if (interfaceActive == true) {
    debug();
  }
  if (calibration == true) {
    calibration();
  }
  ledGlobal = ledPhotoGauche + ledPhotoDroit; 
  ledGlobal = map(ledGlobal, 0, 510, 0, 255);
  //***********************  CALIBRATION *********************

  //phase de calibration des valeurs
  if ( minPiezo == maxPiezo ) {
    calibrated = minPiezo;
  } else {
    calibrated = map(valPiezo, minPiezo, maxPiezo, 0, 1023);
  }

  hip = hipFactor * (hip + calibrated - hipPrevious);
  hipPrevious = calibrated;

  if (hip > 255 || hip < - 255) {
    //filtre le nombre de choc
    if (hipPrevious < 255 || hipPrevious > -255) {
      if (choc < 3)
      {
        choc += 1;
      } else
        choc = 0;
      //deplacer la camera a chaque choc, changer couleur
    } else {
      choc += 0;
    }
  } else {
    choc += 0;
  }

  if ( minAccelero == maxAccelero ) {
    calibrAccelero = minAccelero;
  } else {
    calibrAccelero = map(valAccelero, minAccelero, maxAccelero, 0, 1023);
  }

  facteurLerp = map(calibrAccelero, minAccelero, maxAccelero, 0, 1);
  hip = hipFactor * (hip + calibrated - hipPrevious);
  hipPrevious = calibrated;
  //***********************  CALIBRATION *********************

  if (affichageKinect == true) {
    affichageKinect();
  }

  oscParsing("/choc", choc);
  oscParsing("/minAccelero", (int)minAccelero);
  oscParsing("/maxAccelero", (int)maxAccelero);
  oscParsing("/accelero", valAccelero);
}

