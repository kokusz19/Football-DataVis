public class Country extends CountryStatic{
	public int id = 0;
	public String name;
	public int plays;
	public int goalsGave, goalsGot;
	public int won, draw, lost;
	public int points;
	public HashMap<Integer, Integer> pointsByYear;
	public HashMap<Integer, Integer> goalsByYear;

	public Country(String tname){
		id = count;
		count++;
		name = tname;
		maxPlays = maxPlays+1;
		pointsByYear = new HashMap<Integer, Integer>();
		goalsByYear = new HashMap<Integer, Integer>();
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

			if(pointsByYear.containsKey(recording.year)){
				pointsByYear.put(recording.year, pointsByYear.get(recording.year)+tmpPoints);
				goalsByYear.put(recording.year, goalsByYear.get(recording.year)+recording.homeGoals);
			} else{
				pointsByYear.put(recording.year, tmpPoints);
				goalsByYear.put(recording.year, recording.homeGoals);
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

			if(pointsByYear.containsKey(recording.year)){
				pointsByYear.put(recording.year, pointsByYear.get(recording.year)+tmpPoints);
				goalsByYear.put(recording.year, goalsByYear.get(recording.year)+recording.awayGoals);
			} else{
				pointsByYear.put(recording.year, tmpPoints);
				goalsByYear.put(recording.year, recording.awayGoals);
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
}