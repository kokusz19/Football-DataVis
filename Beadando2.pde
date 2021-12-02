import g4p_controls.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

// First loading in the data
static final int PANEL_HEIGHT = 50; 
List<Button> panel;
int panelSelected;
Table table, table2;
Recording[] records;
WorldCup[] worldCups;

// First Panel
List<Country> countries;
ParallelCoordinatesView parallelCoordinatesView;

// Second panel
GDropList dl, dl2;

// Third panel

// Fourth panel

void setup(){
  size(1600, 800);
  
  // Create the navigation panel (last panel is always a placeholder only, without any function)
  panel = new ArrayList<Button>();
  panel.add(new Button(0, 0, 100, PANEL_HEIGHT, "Overall"));
  panel.add(new Button(100, 0, 250, PANEL_HEIGHT, "Play X Score"));
  panel.add(new Button(250, 0, 300, PANEL_HEIGHT));
  panel.add(new Button(300, 0, 400, PANEL_HEIGHT));
  panel.add(new Button(400, 0, width, PANEL_HEIGHT));

  // Loading the csv and printing it's values if needed
  table = loadTable("world_cup_results.csv", "header");
  records = new Recording[table.getRowCount()];
  for(int i = 0; i < table.getRowCount(); i++){
  	TableRow tr = table.getRow(i);
  	records[i] = new Recording(tr.getInt(0), tr.getString(1), tr.getString(2), tr.getString(3), tr.getString(4), tr.getString(5), tr.getString(6), tr.getString(7), tr.getInt(8), tr.getInt(9), tr.getString(10), tr.getString(11));
  	// println(records[i]);
  }
  // Loading the 2nd csv and printing it's values if needed
  table2 = loadTable("world_cups.csv", "header");
  worldCups = new WorldCup[table2.getRowCount()];
  for(int i = 0; i < table2.getRowCount(); i++){
  	TableRow tr = table2.getRow(i);
  	worldCups[i] = new WorldCup(tr.getInt(0), tr.getString(1), tr.getString(2), tr.getString(3), tr.getString(4), tr.getString(5), tr.getInt(6), tr.getInt(7), tr.getInt(8), tr.getInt(9));
  	//println(worldCups[i]);
  }


  // Get countries for first panel
  firstPanelSetup();
  secondPanelSetup();
}

void draw(){
	background(230);

	// Rendering the data based on the selected panel
	switch(panelSelected){
		case 0: {
			if(dl != null){
				dl.setVisible(false);
				dl2.setVisible(false);
			}
			parallelCoordinatesView.draw();
			break;
		}
		case 1: {
			if(dl != null){
				dl.setVisible(true);
				dl2.setVisible(true);
			}
			secondPanelDraw();
			break;
		}
		case 2: {
			if(dl != null){
				dl.setVisible(false);
				dl2.setVisible(false);
			}
			thirdPanelDraw();
			break;
		}
		case 3: {
			if(dl != null){
				dl.setVisible(false);
				dl2.setVisible(false);
			}
			fourthPanelDraw();
			break;
		}
	}

	// Rendering the upper panels
	createUpperPanel();
	for(int i = 0; i < panel.size(); i++){
		if(i != (panel.size()-1))
			panel.get(i).update();
	}
}

void firstPanelSetup(){
	countriesSetup();

	ArrayList<String> labels = new ArrayList<String>() {
		{
			add("Plays");
			add("Goals gave");
			add("Goals got");
			add("Won");
			add("Draw");
			add("Lost");
			add("Points");
			add("Country");
		}
	};
	ArrayList<Sample> samples = new ArrayList<Sample>();
	for(Country country : countries){
		String classLabel = country.name;
		ArrayList<Float> features = new ArrayList<Float>();
		features.add(float(country.plays));
		features.add(float(country.goalsGave));
		features.add(float(country.goalsGot));
		features.add(float(country.won));
		features.add(float(country.draw));
		features.add(float(country.lost));
		features.add(float(country.points));
		samples.add(new Sample(features, classLabel));
	}
	parallelCoordinatesView = new ParallelCoordinatesView(labels, samples, 0.0f, 100.0f, width-600, height-PANEL_HEIGHT);	
/*for(Country country : countries){
		println(country);
		println("\tPoints: " + country.pointsByYear);
		println("\tGoals" + country.goalsByYear);
	}*/
}
void secondPanelSetup(){
	
}
void secondPanelDraw(){
	String[] countryNames = new String[countries.size()+1];
	textSize(12);
	textAlign(LEFT);
	
	// Create the first dropDownList
	text("Not selected countries", 5, 62);
	if(dl != null){
		if(dl.getSelectedIndex() != 0){
			dl2.addItem(dl.getSelectedText());
			int idx = dl.getSelectedIndex();
			dl.setSelected(0);
			dl.removeItem(idx);
		}
	} else{
		dl = new GDropList(this, 5f, 70f, 200f, 200f);
		countryNames[0] = "Select a country";
		for(int i = 1; i <= countries.size(); i++){
			countryNames[i] = countries.get(i-1).name;
		}
		dl.setItems(countryNames, 0);
	}		
	dl.draw();

	// Create the second dropDownList
	text("Selected countries", 5, 290);
	if(dl2 != null){
		if(dl2.getSelectedIndex() != 0){
			dl.addItem(dl2.getSelectedText());
			int idx = dl2.getSelectedIndex();
			dl2.setSelected(0);
			dl2.removeItem(idx);
		}
	} else{
		dl2 = new GDropList(this, 5f, 300f, 200f, 200f);
		String[] tmp = new String[]{ "Unselect a country" };
		dl2.setItems(tmp, 0);
	}		
	dl2.draw();
}
void thirdPanelDraw(){
	text("3333", 150, 150);
}
void fourthPanelDraw(){
	text("4444", 150, 150);
}


void countriesSetup(){
	countries = new ArrayList<Country>();

	for(int i = 0; i < records.length; i++){
		boolean ht = false;
		boolean at = false;
		for(Country country : countries){
			if(country.name.equals(records[i].homeTeam))
				ht = true;
			if(country.name.equals(records[i].awayTeam))
				at = true;
		}
		if(!at)
			countries.add(new Country(records[i].awayTeam));
		if(!ht)
			countries.add(new Country(records[i].homeTeam));

		for(Country country : countries){
			if(country.name.equals(records[i].homeTeam))
				country.update(records[i]);
			if(country.name.equals(records[i].awayTeam))
				country.update(records[i]);
		}
	}

	//for(Country country : countries)
	//	println(country);
}
void mousePressed() {
  // Check if the mouse has been clicked inside of a panel
  for(int i = 0; i < panel.size()-1; i++)
  	if(panel.get(i).rectOver){
  		panel.get(i).currentColor = panel.get(i).selectedColor;
  		panelSelected = i;
  	}
  // MousePressed for ParallelCoordinatesView
  parallelCoordinatesView.onMousePressedAt(mouseX, mouseY);

}
void mouseClicked(){
  parallelCoordinatesView.onMouseClickedOn(mouseX, mouseY);
}
void mouseMoved(){
  parallelCoordinatesView.onMouseMovedTo(mouseX, mouseY);
}
void mouseDragged(){
  parallelCoordinatesView.onMouseDragged(pmouseX, pmouseY, mouseX, mouseY);
}
void mouseReleased(){
  parallelCoordinatesView.onMouseReleasedAt(mouseX, mouseY);
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