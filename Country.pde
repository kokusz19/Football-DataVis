public class Country extends CountryStatic{
	public int id = 0;
	public String name;
	public int plays;
	public int goalsGave, goalsGot;
	public int won, draw, lost;
	public int points;
	public TreeMap<Integer, InterestingFacts> interestingFacts;
	public List<String> aliases;

	public Country(String tname){
		id = count;
		count++;
		name = tname;
		maxPlays = maxPlays+1;
		interestingFacts = new TreeMap<Integer, InterestingFacts>();
		aliases = new ArrayList<String>();
		aliases.add(tname);
	}

	public void update(Recording recording){
		if(recording.homeTeam.equals(name)){
			plays++;
			goalsGave += recording.homeGoals;
			goalsGot += recording.awayGoals;
			int tmpPoints = 0;
			if(recording.awayGoals < recording.homeGoals){
				won++;
				tmpPoints = 3;
			}
			else if(recording.awayGoals > recording.homeGoals)
				lost++;
			else if(recording.awayGoals == recording.homeGoals){
				tmpPoints = 1;
				if(recording.observation.contains(name))
					tmpPoints = 3;
				if(recording.observation != null && !recording.observation.equals("") && !recording.observation.contains(name))
					tmpPoints = 0;
				if(tmpPoints == 1) draw++;
				else if(tmpPoints == 3) won++;
				else if(tmpPoints == 0) lost++;
				//println("\t" + name + " " + tmpPoints + "pts - " + recording.homeGoals + "-" + recording.awayGoals + "\t" + recording.observation);
			}


			if(recording.observation.contains(name))
				tmpPoints += 2;

			points += tmpPoints;
			findMaxValues();

			if(interestingFacts.containsKey(recording.year)){
				int currentPoints = interestingFacts.get(recording.year).pointsByYear;
				int currentGoals = interestingFacts.get(recording.year).goalsByYear;
				int currentPlacement = interestingFacts.get(recording.year).placementByYear;
				InterestingFacts infa = new InterestingFacts(currentPoints+tmpPoints, currentGoals+recording.homeGoals, currentPlacement);
				interestingFacts.put(recording.year, infa);
			} else{
				int currentPlacement = 0;
				for(WorldCup wc : worldCups)
					if(wc.year == recording.year){
						if(wc.winner.equals(name))	currentPlacement = 1;
						else if(wc.second.equals(name))	currentPlacement = 2;
						else if(wc.third.equals(name))	currentPlacement = 3;
						else if(wc.fourth.equals(name))	currentPlacement = 4;
					}
				InterestingFacts infa = new InterestingFacts(tmpPoints, recording.homeGoals, currentPlacement);
				interestingFacts.put(recording.year, infa);
			}

		} else if(recording.awayTeam.equals(name)){
			plays++;
			goalsGave += recording.awayGoals;
			goalsGot += recording.homeGoals;
			int tmpPoints = 0;
			if(recording.awayGoals > recording.homeGoals){
				won++;
				tmpPoints = 3;
			}
			else if(recording.awayGoals < recording.homeGoals)
				lost++;
			else if(recording.awayGoals == recording.homeGoals){
				tmpPoints = 1;
				if(recording.observation.contains(name))
					tmpPoints = 3;
				if(recording.observation != null && !recording.observation.equals("") && !recording.observation.contains(name))
					tmpPoints = 0;
				if(tmpPoints == 1) draw++;
				else if(tmpPoints == 3) won++;
				else if(tmpPoints == 0) lost++;
				//println("\t" + name + " " + tmpPoints + "pts - " + recording.awayGoals + "-" + recording.homeGoals + "\t" + recording.observation);
			}

			

			points += tmpPoints;
			findMaxValues();

			if(interestingFacts.containsKey(recording.year)){
				int currentPoints = interestingFacts.get(recording.year).pointsByYear;
				int currentGoals = interestingFacts.get(recording.year).goalsByYear;
				int currentPlacement = interestingFacts.get(recording.year).placementByYear;
				InterestingFacts infa = new InterestingFacts(currentPoints+tmpPoints, currentGoals+recording.awayGoals, currentPlacement);
				interestingFacts.put(recording.year, infa);
			} else{
				int currentPlacement = 0;
				for(WorldCup wc : worldCups)
					if(wc.year == recording.year){
						if(wc.winner.equals(name))	currentPlacement = 1;
						else if(wc.second.equals(name))	currentPlacement = 2;
						else if(wc.third.equals(name))	currentPlacement = 3;
						else if(wc.fourth.equals(name))	currentPlacement = 4;
					}
				InterestingFacts infa = new InterestingFacts(tmpPoints, recording.homeGoals, currentPlacement);
				interestingFacts.put(recording.year, infa);
			}
		}
	}

	void findMaxValues(){
		if(plays > maxPlays) maxPlays = plays;
		if(goalsGave > maxGoalsGave) maxGoalsGave = goalsGave;
		if(goalsGot > maxGoalsGot) maxGoalsGot = goalsGot;
		if(maxWin > won) maxWin = won;
		if(maxDraw > draw) maxDraw = draw;
		if(maxLost > lost) maxLost = lost;
		if(maxPoints > maxPoints) maxPoints = points;
	}

	public String toString(){
		return id + " " + name + " plays:" + plays + ", +goals:" + goalsGave + ", -goals:" + goalsGot + ", W" + won + ", D" + draw + ", L" + lost + ", PTS:" + points;
	}

	class InterestingFacts{
		int pointsByYear;
		int goalsByYear;
		int placementByYear;

		public InterestingFacts(int pby, int gby, int plby){
			pointsByYear = pby;
			goalsByYear = gby;
			placementByYear = plby;
		}

		public String toString(){
			if(placementByYear > 1)
				return placementByYear + ". place, " + pointsByYear + "pts, " + goalsByYear + "goals";
			return "No placement, " + pointsByYear + "pts, " + goalsByYear + "goals";
		}
	}
}