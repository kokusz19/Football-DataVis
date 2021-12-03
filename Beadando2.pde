import g4p_controls.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.TreeMap;

// First loading in the data
static final int PANEL_HEIGHT = 50; 
List<Button> panel;
int panelSelected;
Table table, table2;
Recording[] records;
WorldCup[] worldCups;

// First Panel
List<Country> countries;
String[] countryNames;
ParallelCoordinatesView parallelCoordinatesView;

// Second panel
GDropList dl, dl2;
GButton selectAll, unSelectAll;
List<Country> chosenCountries;

// Third panel

// Fourth panel

void setup(){
  size(1600, 800);
  
  // Create the navigation panel (last panel is always a placeholder only, without any function)
  panel = new ArrayList<Button>();
  panel.add(new Button(0, 0, 100, PANEL_HEIGHT, "Overall"));
  panel.add(new Button(100, 0, 150, PANEL_HEIGHT, "Play X Score"));
  panel.add(new Button(250, 0, 50, PANEL_HEIGHT));
  panel.add(new Button(300, 0, 100, PANEL_HEIGHT));
  panel.add(new Button(400, 0, width, PANEL_HEIGHT));

  // Loading the 2nd csv and printing it's values if needed
  table2 = loadTable("world_cups.csv", "header");
  worldCups = new WorldCup[table2.getRowCount()];
  for(int i = 0; i < table2.getRowCount(); i++){
  	TableRow tr = table2.getRow(i);
  	worldCups[i] = new WorldCup(tr.getInt(0), tr.getString(1), tr.getString(2), tr.getString(3), tr.getString(4), tr.getString(5), tr.getInt(6), tr.getInt(7), tr.getInt(8), tr.getInt(9));
  	//println(worldCups[i]);
  }

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
				selectAll.setVisible(false);
				unSelectAll.setVisible(false);
			}
			parallelCoordinatesView.draw();
			break;
		}
		case 1: {
			if(dl != null){
				dl.setVisible(true);
				dl2.setVisible(true);
				selectAll.setVisible(true);
				unSelectAll.setVisible(true);
			}
			secondPanelDraw();
			break;
		}
		case 2: {
			if(dl != null){
				dl.setVisible(false);
				dl2.setVisible(false);
				selectAll.setVisible(false);
				unSelectAll.setVisible(false);
			}
			thirdPanelDraw();
			break;
		}
		case 3: {
			if(dl != null){
				dl.setVisible(false);
				dl2.setVisible(false);
				selectAll.setVisible(false);
				unSelectAll.setVisible(false);
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
		println("\t" + country.interestingFacts);
		//println("\tGoals" + country.goalsByYear);
	}*/
}
void secondPanelSetup(){
	countriesSetup();
	// Had to use CopyOnWriteArrayList to sort out the "ConcurrentModificationException"
	// Occured: 2nd panel, after selecting a few countries, then clicked a button and tried to remove a country using the 2nd dropdownlist, the exception has been thrown
	chosenCountries = new CopyOnWriteArrayList<Country>();
}
void secondPanelDraw(){
	countryNames = new String[countries.size()+1];
	textSize(12);
	textAlign(LEFT);
	
	// Create the dropDownLists and buttons to select/unselect countries
	secondPanelG4P();
	// println(chosenCountries);

	// Show the selected countries
	textSize(15);
	text("Selected countries", 5, 120);
	int x = 10, y = 140, k = 0, maxTextWidth = ceil(textWidth("Selected countries"));
	for(int i = 0; i < chosenCountries.size(); i++){
		if(y + i*15 >= height && k == 0){
			y = 140;
			x += maxTextWidth+5;
			k = i;
		}
		if(textWidth(chosenCountries.get(i).name) > maxTextWidth)	
			maxTextWidth = ceil(textWidth(chosenCountries.get(i).name));	
		text(chosenCountries.get(i).name, x, y+(i-k)*15);	
	}
	textSize(12);
	
	// To display the matches of the selected countries
	if(chosenCountries != null && chosenCountries.size() != 0)
		showMatchesOfTeams(chosenCountries, x+maxTextWidth+10, 120);	
}
void secondPanelG4P(){
	// Create the first dropDownList
	//text("Not selected countries", 5, 62);
	if(dl != null){
		if(dl.getSelectedIndex() != 0){
			dl2.addItem(dl.getSelectedText());
			int idx = dl.getSelectedIndex();
			
			for(Country country : countries)
				if(country.name.equals(dl.getSelectedText()))
					chosenCountries.add(country);

			dl.setSelected(0);
			dl.removeItem(idx);
		}
	} else{
		dl = new GDropList(this, 5f, 60f, 200f, 200f);
		countryNames[0] = "Select a country";
		for(int i = 1; i <= countries.size(); i++){
			countryNames[i] = countries.get(i-1).name;
		}
		dl.setItems(countryNames, 0);
	}		
	dl.draw();

	// Create the second dropDownList
	//text("Selected countries", 225, 70);
	if(dl2 != null){
		if(dl2.getSelectedIndex() != 0){
			dl.addItem(dl2.getSelectedText());
			int idx = dl2.getSelectedIndex();

			for(Country country : chosenCountries)
				if(country.name.equals(dl2.getSelectedText()))
					chosenCountries.remove(country);

			dl2.setSelected(0);
			dl2.removeItem(idx);
		}
	} else{
		dl2 = new GDropList(this, 225f, 60f, 200f, 200f);
		String[] tmp = new String[]{ "Unselect a country" };
		dl2.setItems(tmp, 0);
	}		
	dl2.draw();


	// Create buttons with text
	if(selectAll == null){
		selectAll = new GButton(this, 445+textWidth("Select all")+5, 60, 100, 40f);
		unSelectAll = new GButton(this, 445+textWidth("Select all")+110+textWidth("unSelectAll")+10, 60, 100, 40f);
	}	
	selectAll.draw();
	unSelectAll.draw();
	text("Select all:", 445, 85);
	text("Unselect all:", 445+textWidth("Select all")+110, 85);
}
void showMatchesOfTeams(List<Country> chosenCountries, int minX, int minY){
	fill(185);
	rect(minX, minY-15, width, height);
	fill(0);
	//line(minX, minY-15, minX, height);
	//line(minX, minY-15, width, minY-15);
	//stroke(0);
	//stroke(color(255, 0, 0));
	//line(minX, 0, minX, height);
	// Gather the recordings, where 2 (out of all) countries played against each other
	List<Recording> chosenRecordings = new ArrayList<Recording>();
	for(Recording record : records){
		int presence = 0;
		for(Country country : chosenCountries){
			if(country.name.equals(record.homeTeam) || country.name.equals(record.awayTeam))
				presence++;
		}
		if(presence == 2)
			chosenRecordings.add(record);
	}
	// println(chosenRecordings);

	// Display the results
	color greenColor = color(10, 101, 34);
	color redColor = color(194, 24, 7);
	int startY = minY, midPoint = (minX+width)/2, leftTextSize = 0, rightTextSize = 0;
	textSize(15);
	for(Recording tmpRecording : chosenRecordings){
		//text(chosenRecordings.get(i).toString(), minX, startY+i*15);
		String homeTeam = tmpRecording.homeTeam, awayTeam = tmpRecording.awayTeam, dateHappened = tmpRecording.dateTime.toString(), group = tmpRecording.round, observation = tmpRecording.observation;
		int homeGoals = tmpRecording.homeGoals, awayGoals = tmpRecording.awayGoals;
		textAlign(CENTER, CENTER);
		text(":", midPoint, startY);
		
		if(tmpRecording.winner.equals(homeTeam))
			fill(greenColor);
		else if(tmpRecording.winner.equals(awayTeam))
			fill(redColor);
		else
			fill(0);
		textAlign(RIGHT, CENTER);
		text(homeTeam + " " + homeGoals, midPoint-textWidth(" : "), startY);
		if(leftTextSize < ceil(textWidth(homeTeam + " " + homeGoals))+ceil(textWidth(" : ")))	leftTextSize = ceil(textWidth(homeTeam + " " + homeGoals))+ceil(textWidth(" : "));

		if(tmpRecording.winner.equals(awayTeam))
			fill(greenColor);
		else if(tmpRecording.winner.equals(homeTeam))
			fill(redColor);
		else
			fill(0);
		textAlign(LEFT, CENTER);
		text(awayGoals + " " + awayTeam, midPoint+textWidth(" : "), startY);
		if(rightTextSize < ceil(textWidth(awayTeam + " " + awayGoals))+ceil(textWidth(" : ")))	rightTextSize = ceil(textWidth(awayTeam + " " + awayGoals))+ceil(textWidth(" : "));

		// Make text "bold"
		if(tmpRecording.winner.equals(homeTeam)){
			fill(greenColor);
			textAlign(RIGHT, CENTER);
			text(homeTeam + " " + homeGoals, midPoint-textWidth(" : ")+1, startY);
		} else if(tmpRecording.winner.equals(awayTeam)){
			fill(greenColor);
			textAlign(LEFT, CENTER);
			text(awayGoals + " " + awayTeam, midPoint+textWidth(" : ")+1, startY);
		}
		startY += 20;
	}
	textSize(12);
	fill(0);

	startY = minY;
	int sizeOfRounds = 0;
	for(Recording tmpRecording : chosenRecordings){
		textAlign(RIGHT, CENTER);
		if(sizeOfRounds < ceil(textWidth(tmpRecording.round)))	
			sizeOfRounds = ceil(textWidth(tmpRecording.round));
		text(tmpRecording.round, midPoint-leftTextSize-20, startY);
		textAlign(LEFT, CENTER);
		text(tmpRecording.observation, midPoint+rightTextSize+20, startY);
		startY += 20;
	}

	startY = minY;
	for(Recording tmpRecording : chosenRecordings){
		textAlign(RIGHT, CENTER);
		text(tmpRecording.getDateTime(), midPoint-leftTextSize-20-sizeOfRounds-20, startY);
		startY += 20;
	}
}
// To handle button press on GButtons
void handleButtonEvents(GButton button, GEvent event) {
   if(button == selectAll && event == GEvent.CLICKED){
		// GDropLists if set to "null" or if they are disposed, still can't be rendered over or can't be reinitialized
		// If they are set to invisible (GDropList.setVisible(false)), this issue does not occur
 		dl.setVisible(false);
 		dl2.setVisible(false);
    dl = new GDropList(this, 5f, 60f, 200f, 200f);
    String[] tmp = new String[]{ "Select a country" };
  	dl.setItems(tmp, 0);

		dl2 = new GDropList(this, 225f, 60f, 200f, 200f);
    countryNames[0] = "Unselect a country";
		for(int i = 1; i <= countries.size(); i++){
			countryNames[i] = countries.get(i-1).name;
		}
		dl2.setItems(countryNames, 0);

		chosenCountries.clear();
  	for(Country country : countries)
			chosenCountries.add(country);
		// println("select all");
		// println(chosenCountries);
   }
   if(button == unSelectAll && event == GEvent.CLICKED){
 		dl.setVisible(false);
 		dl2.setVisible(false);
    dl = new GDropList(this, 5f, 60f, 200f, 200f);
    countryNames[0] = "Select a country";
		for(int i = 1; i <= countries.size(); i++){
			countryNames[i] = countries.get(i-1).name;
		}
		dl.setItems(countryNames, 0);

		dl2 = new GDropList(this, 225f, 60f, 200f, 200f);
    String[] tmp = new String[]{ "Unselect a country" };
  	dl2.setItems(tmp, 0);

  	chosenCountries.clear();
		// println("unselect all");
		// println(chosenCountries);
   }
}
public void handleDropListEvents(GDropList list, GEvent event) { /* Just so the informational message gets hidden */ }

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
    rect(button.rectX, button.rectY, (button.rectX+button.rectXSize), (button.rectY+button.rectYSize));
}