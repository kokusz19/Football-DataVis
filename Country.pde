public class Country extends CountryStatic{
	public String name;
	public int plays;
	public int goalsGave, goalsGot;
	public int won, draw, lost;
	public int points;

	public Country(String tname){
		name = tname;
		maxPlays = maxPlays+1;
	}

	public void update(Recording recording){
		if(recording.homeTeam.equals(name)){
			plays++;
			goalsGave += recording.homeGoals;
			goalsGot += recording.awayGoals;
			if(recording.awayGoals < recording.homeGoals){
				won++;
				points += 3;
			}
			else if(recording.awayGoals > recording.homeGoals)
				lost++;
			else if(recording.awayGoals == recording.homeGoals){
				draw++;
				points += 1;
			}
			findMaxValues();
		} else if(recording.awayTeam.equals(name)){
			plays++;
			goalsGave += recording.awayGoals;
			goalsGot += recording.homeGoals;
			if(recording.awayGoals > recording.homeGoals){
				won++;
				points += 3;
			}
			else if(recording.awayGoals < recording.homeGoals)
				lost++;
			else if(recording.awayGoals == recording.homeGoals){
				draw++;
				points += 1;
			}
			findMaxValues();
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
		return name + " plays:" + plays + ", +goals:" + goalsGave + ", -goals:" + goalsGot + ", W" + won + ", D" + draw + ", L" + lost + ", PTS:" + points;
	}
}