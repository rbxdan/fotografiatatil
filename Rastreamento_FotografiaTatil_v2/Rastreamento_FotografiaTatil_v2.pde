void setup() {
  // Canvas config
  size(640, 480);

  // Mapping config
  loadMappings();
  println(circ_num);
  circ_radius = new float[circ_num];
  circ_x = new float[circ_num];
  circ_y = new float[circ_num];

  // Audio config
  //minim = new Minim(this);
  //audio_run = new boolean[circ_num];
  
  

  //for (int i = 0; i < circ_num; i++) {
  //  circ_x[i] = -50;
  //  circ_y[i] = -50;

  //  circ_radius[i] = 30;
    //audio_run[i] = false;
    //circle_audios[i] = minim.loadFile("./data/04/"+i+".mp3");
    //println(circle_audios[i]);
  //}
}

void draw() {
  background(200, 200, 200);
  
  if (circ_selected) {
    noFill();
    stroke(0, 255, 0);
    ellipse(mouseX, mouseY, circ_radius[circ_id], circ_radius[circ_id]);
    text(circ_id, mouseX-3, mouseY+5);
  }

  for (int i = 0; i < circ_num; i++) {
    if (i == circ_id) {
      stroke(0, 255, 0);
      if (!circ_selected) {
        textSize(15);
        text(i, circ_x[i]-3, circ_y[i]+5);
        ellipse(circ_x[i], circ_y[i], circ_radius[i], circ_radius[i]);
      }
    } else {
      textSize(15);
      text(i, circ_x[i]-3, circ_y[i]+5);
      stroke(255, 255, 0);
      ellipse(circ_x[i], circ_y[i], circ_radius[i], circ_radius[i]);
    }
  }

  for (int i = 0; i < circ_num; i++) {
    if (circ_radius[i] < 10) {
      circ_radius[i] = 10;
    }
  }
}
