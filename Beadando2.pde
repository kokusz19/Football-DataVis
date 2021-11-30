import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;

static final int PANEL_HEIGHT = 50; 
List<Button> panel;
int panelSelected;
Table table;
Recording[] records;
ParallelCoordinatesView parallelCoordinatesView;

void setup(){
  size(1600, 800);
  
  // Create the navigation panel (last panel is always a placeholder only, without any function)
  panel = new ArrayList<Button>();
  panel.add(new Button(0, 0, 100, PANEL_HEIGHT));
  panel.add(new Button(100, 0, 200, PANEL_HEIGHT));
  panel.add(new Button(200, 0, 300, PANEL_HEIGHT));
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

  // Get countries for first panel
  firstPanelSetup();
}

void draw(){
	background(230);

	switch(panelSelected){
		case 0: {
			parallelCoordinatesView.draw();
			break;
		}
		case 1: {
			secondPanel();
			break;
		}
		case 2: {
			thirdPanel();
			break;
		}
		case 3: {
			fourthPanel();
			break;
		}
	}
	// Rendering the upper panels
	for(int i = 0; i < panel.size(); i++){
		createUpperPanel();
		if(i != (panel.size()-1))
			panel.get(i).update();
	}

	fill(0);
	textSize(20);
	textAlign(CENTER, CENTER);
	text("Overall", 50, PANEL_HEIGHT/2);

}

void firstPanelSetup(){
	List<Country> countries = new ArrayList<Country>();

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


	ArrayList<String> labels = new ArrayList<String>() {
		{
			add("Plays");
			add("Goals gave");
			add("Goals got");
			add("Won");
			add("Draw");
			add("Lost");
			add("Points");
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
	//for(int i = 0; i < countries.size(); i++)
	//	println(countries.get(i));
}
void secondPanel(){
	text("2222", 150, 150);
}
void thirdPanel(){
	text("3333", 150, 150);
}
void fourthPanel(){
	text("4444", 150, 150);
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