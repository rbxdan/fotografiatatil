static int circ_num = 0;
static int circ_id = -1;
float[] circ_radius, circ_x, circ_y;
boolean circ_selected = false;
JSONArray mapArray;

void createMapping() {
  File f = dataFile("mapping.json");
  JSONObject jsonObject;
  JSONArray jsonArray;

  if (f.isFile()) {
    mapArray = loadJSONArray(f.getPath());
  } else {
    mapArray = new JSONArray();
  }

  jsonArray = new JSONArray();

  for (int i = 0; i < circ_num; i++) {
    jsonObject = new JSONObject();
    jsonObject.setFloat("circ_id", i);
    jsonObject.setFloat("circ_x", circ_x[i]);
    jsonObject.setFloat("circ_y", circ_y[i]);
    jsonObject.setFloat("circ_radius", circ_radius[i]);
    jsonArray.append(jsonObject);
  }

  mapArray.append(jsonArray);
  saveJSONArray(mapArray, f.getPath());
}

void readMapping(int value) {
  JSONArray mappings = new JSONArray();
  JSONObject circle;

  loadMappings();
  if (value >= 1 && value <= mapArray.size()) {
    mappings = mapArray.getJSONArray(value-1);
  } else if (value == 0) {
    println("Digite um número a partir de 1");
  } else {
    println("Só existem "+(mapArray.size())+" mapeamentos!");
  }

  circ_num = mappings.size();

  for (int i = 0; i < circ_num; i++) {
    circle = mappings.getJSONObject(i); 
    circ_x[i] = circle.getFloat("circ_x");
    circ_y[i] = circle.getFloat("circ_y");
    circ_radius[i] = circle.getFloat("circ_radius");
  }
}

void loadMappings() {
  File f = dataFile("mapping.json");

  if (f.isFile()) {
    mapArray = loadJSONArray(f.getPath());
    circ_num = mapArray.getJSONArray(0).size();
  } else {
    mapArray = new JSONArray();
    circ_num = 0;
    println("Não há mapeamentos registrados.");
  }
}
