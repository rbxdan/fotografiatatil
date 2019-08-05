void keyPressed() {
  
  if (keyCode == UP) {
    circ_radius[circ_id] = circ_radius[circ_id]+10;
  }
  if (keyCode == DOWN) {
    circ_radius[circ_id] = circ_radius[circ_id]-10;
  }
  
  switch(key) {
    case(TAB):
    //circ_num = 1;
    append(circ_radius, 30);
    break;
    
    case('a'):
    if (circ_id >= 0) {
      circ_id -= 1;
    } else {
      circ_id = 0;
    }
    circ_selected = true;
    break;
    
    case('d'):
    circ_id += 1;
    circ_selected = true;
    break;
    
    case(ENTER):
    createMapping();
    break;
    
    case(RETURN):
    createMapping();
    break;
  }
  
  if (key > 47 && key < 58) {
    readMapping(Character.getNumericValue(key));
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    println(circ_id);
    if (circ_selected == true) {
      circ_selected = false;
      circ_num += 1;
      println(circ_num);
    }
    if (circ_id >= 0) {
      println("x=", mouseX, ",Y=", mouseY);
      append(circ_y, mouseY);
      append(circ_x, mouseX);
      //circ_y[circ_id] = mouseY;
      //circ_x[circ_id] = mouseX;
    }
  }
  
  //Caso o usuário pressione uma tecla e adicione um círculo indesejado, o clique com o botão direito faz o círculo ser "deletado"
  //na verdade o círculo volta para a posição -50 -50
  if (mouseButton == RIGHT) {
    if (circ_selected == true) {
      circ_selected = false;
      circ_num -= 1;
      println(circ_num);
    }
    if (circ_id >= 0) {
      circ_y[circ_id]=-50;
      circ_x[circ_id]=-50;
      circ_radius[circ_id] = 30;
    }
  }
}
