import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

static final int PANEL_HEIGHT = 50; 
List<Button> panel;
int panelSelected;
Table table;
Recording[] records;

void setup(){
  size(1050, 800);
  
  // Create the navigation panel (last panel is always a placeholder only, without any function)
  panel = new ArrayList<Button>();
  panel.add(new Button(0, 0, 100, PANEL_HEIGHT));
  panel.add(new Button(100, 0, 200, PANEL_HEIGHT));
  panel.add(new Button(200, 0, width, PANEL_HEIGHT));

  // Loading the csv and printing it's values if needed
  table = loadTable("world_cup_results.csv", "header");
  records = new Recording[table.getRowCount()];
  for(int i = 0; i < table.getRowCount(); i++){
  	TableRow tr = table.getRow(i);
  	records[i] = new Recording(tr.getInt(0), tr.getString(1), tr.getString(2), tr.getString(3), tr.getString(4), tr.getString(5), tr.getString(6), tr.getString(7), tr.getInt(8), tr.getInt(9), tr.getString(10), tr.getString(11));
  	// println(records[i]);
  }
}

void draw(){
	background(230);

	// Rendering the upper panels
	for(int i = 0; i < panel.size(); i++){
		createUpperPanel();
		if(i != (panel.size()-1))
			panel.get(i).update();
	}
}

void mousePressed() {
  // Check if the mouse has been clicked inside of a panel
  for(int i = 0; i < panel.size()-1; i++)
  	if(panel.get(i).rectOver){
  		panel.get(i).currentColor = panel.get(i).selectedColor;
  		panelSelected = i;
  	}
}
void createUpperPanel(){
  // Creating upper panel
  // First panel is selected by default, can be chosen by clicking on any other panel
  for(int i = 0; i < panel.size(); i++){
  	if(panelSelected == i)
  		createButton(panel.get(i), true);
  	else
  		createButton(panel.get(i), false);
  }
}
void createButton(Button button, boolean selected){
    if(selected)
      button.currentColor = button.selectedColor;
    else
      button.currentColor = button.currentColor;
    fill(button.currentColor);
    noStroke();
    rect(button.rectX, button.rectY, button.rectXSize, button.rectYSize);
}