void keyPressed() {
  //touche D  
  if (key == 100) {
    if (interfaceActive == false) {
      interfaceActive = true;
    } else {
      interfaceActive = false;
    }
  }
  //touche C
  if (key == 99)
  {
    if (calibration == false) {
      chrono = millis();
      affichageKinect = false;
      //reinitialise min et max avant calibration
      calibration = true;
    } else
    {
      minPiezo = 1023;
      maxPiezo = 0;
      minAccelero = 1023;
      maxAccelero = 0;
      calibration = false;
    }
  }

  //touche A
  if (key == 97)
  {
    if (audioEnable == false) {
      oscParsing("/stop", -3);
      audioEnable = true;
    } else
    {
      oscParsing("/stop", -100);
      audioEnable = false;
    }
  }

  //touches UP et DOWN
  if (key == CODED) {
    if (keyCode == UP) {
      if (threshold < 3) {
        threshold += 0.1;
      }
    } else if (keyCode == DOWN) {
      if (threshold > 0) {
        threshold -= 0.1;
      }
    }
  }
}


void debug()
{
  fill(255);
  textAlign(LEFT, CENTER);
  textSize(12);
  text("interaction : " + interaction, width * 0.05, height * 0.05);
  text("choc : " + choc, width * 0.05, (height * 0.05) + 16);
  text("LED Droit : " + ledPhotoDroit, width * 0.05, (height * 0.05)+ 32);
  text("LED Gauche : " + ledPhotoGauche, width * 0.05, (height * 0.05) + 48);
  text("Piezo : " + valPiezo, width * 0.05, (height * 0.05) + 64);
  text("Kinect FrameRate: " + (int)kinect.getDepthFPS(), width * 0.05, (height * 0.05) + 80);
  text("FPS : " + frameRate, width * 0.05, (height * 0.05) + 96);
  text("calibration : " + calibration, width * 0.05, (height * 0.05) + 112);
  text("Accelerometre : " + valAccelero, width * 0.05, (height * 0.05) + 128);
  text("Audio : " + audioEnable, width * 0.05, (height * 0.05) + 144);
}

void calibration () {
  fill(255);
  // CALIBRATION PIEZO
  if ( millis() - chrono < 4000 ) {
    if ( valPiezo < minPiezo ) {
      minPiezo = valPiezo;
      println("Nouveau MIN A  "+(millis()-chrono)+" ms : "+minPiezo);
    }
    if ( valPiezo > maxPiezo ) {
      maxPiezo = valPiezo;
      println("Nouveau MAX A  "+(millis()-chrono)+" ms : "+maxPiezo);
    }
    textAlign(CENTER, CENTER);
    textSize(30);
    text("Frappez vos bâtons entre eux à plusieurs reprises", width * 0.5, height * 0.5);
    textSize(14);
    text( "Calibration Piezo // "+ ( (millis() - chrono) / 40 ) +"% : " + minPiezo + " A  " + maxPiezo, width * 0.5, height * 0.7);
  }
  // CALIBRATION ACCELEROMETRE
  else  if (millis() - chrono < 8000)
  {
    if ( valAccelero < minAccelero ) {
      minAccelero = valAccelero;
      println("Nouveau MIN A  "+(millis()-chrono)+" ms : "+minAccelero);
    }
    if ( valAccelero > maxAccelero ) {
      maxAccelero = valAccelero;
      println("Nouveau MAX A  "+(millis()-chrono)+" ms : "+maxAccelero);
    }
    textAlign(CENTER, CENTER);
    textSize(30);
    text("Secouez vos bâtons", width * 0.5, height * 0.5);
    textSize(14);
    text( "Calibration Accelerometre // "+ ( (millis() - (chrono+4000)) / 40 ) +"% : " + minAccelero + " A  " + maxAccelero, width * 0.5, height * 0.7);
  } else {   
    affichageKinect = true;
  }
}

