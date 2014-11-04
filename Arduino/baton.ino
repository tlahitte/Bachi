int returnPhoto(int x, int y){
  //600: seuil uniquement depasse lorsqu'une main est pose sur la cellule.
  if(x < 600)
  {
    if(y < 255)
    {
      //3 multiple de 255
      y += 3;
    } 
  } 
  else 
  {
    if(y > 0)
    {
      y -= 3;
    }
  }
  return y;
}






