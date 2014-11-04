// These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html
float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}


PVector depthToWorld(int x, int y, int depthValue) {

  final double fx_d = 1.0 / 5.9421434211923247e+02;
  final double fy_d = 1.0 / 5.9104053696870778e+02;
  final double cx_d = 3.3930780975300314e+02;
  final double cy_d = 2.4273913761751615e+02;

  PVector result = new PVector();
  double depth =  depthLookUp[depthValue];//rawDepthToMeters(depthValue);
  result.x = (float)((x - cx_d) * depth * fx_d);
  result.y = (float)((y - cy_d) * depth * fy_d);
  result.z = (float)(depth);
  return result;
}

void stop() {
  kinect.quit();
  super.stop();
}

void affichageKinect() 
{
  //***********************  KINECT **************************
  //code en rapport avec l'affichage visuel de la Kinect

    // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();

  // Nombre de pas entre chaque pixels affiche
  int skip = 4;

  // Translate and rotate
  translate(width/2, height/2, -50);
  //rotateY(mouseY);

  for (int x=0; x<w; x+=skip) {
    for (int y=0; y<h; y+=skip) {
      int offset = x+y*w;

      // Convert kinect data to world xyz coordinate
      int rawDepth = depth[offset];
      PVector v = depthToWorld(x, y, rawDepth);
      textSize(8);

      //threshold définit la profondeur de champ afficher (entre 0 et 5)
      if (v.z < threshold )
      {
        noStroke();
        pushMatrix();
        // facteur de grossissement de la Kinect
        float factor = 800;
        translate(v.x*factor, v.y*factor, factor - v.z*factor);
        //println(v.z*factor);
        // Draw a point 
        fill(mainColor, ledGlobal);
        switch(choc) {
        case 0: 
          stroke(mainColor, ledGlobal);
          point(0, 0);          
          break;
        case 1: 
          noStroke();
          box(4);
          break;
        case 2:
          noStroke();
          text("5", 0, 0);
          break;
        }
        popMatrix();
      }
    }
  }

  //***********************  KINECT **************************
}

