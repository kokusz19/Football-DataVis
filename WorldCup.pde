public class WorldCup{
	public int year, goalsScored, qualifiedTeams, matchesPlayed, attendance;
	public String country, winner, second, third, fourth;

	public WorldCup(int tyear, String tcountry, String twinner, String tsecond, String tthird, String tfourth, int tgoaldScored, int tqualifiedteams, int tmatchesplayed, int tattendance){
		year = tyear;
		country = tcountry;
		winner = twinner;
		second = tsecond;
		third = tthird;
		fourth = tfourth;
		goalsScored = tgoaldScored;
		qualifiedTeams = tqualifiedteams;
		matchesPlayed = tmatchesplayed;
		attendance = tattendance;
	}

	public String toString(){
		return year + " - " + country + " - " + winner + " - " + second + " - " + third + " - " + fourth + " - " + goalsScored + " - " + qualifiedTeams + " - " + matchesPlayed + " - " + attendance;
	}
}