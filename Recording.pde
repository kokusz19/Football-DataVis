public class Recording{
	public int year;
	public LocalDateTime dateTime;
	public String round;
	public String stadium;
	public String city;
	public String country;
	public String homeTeam;
	public int homeGoals;
	public int awayGoals;
	public String awayTeam;
	public String observation;

	public Recording(int tmpyear, String tmpdate, String tmptime, String tmpround, String tmpstadium, String tmpcity, String tmpcountry, String tmphomeTeam, int tmphomeGoals, int tmpawayGoals, String tmpawayTeam, String tmpobservation){
		year = tmpyear;

		int tmpMonth = 0;
		switch(split(tmpdate, '.')[1]){
			case "maj":
				tmpMonth = 5;
				break;
			case "jun":
				tmpMonth = 6;
				break;
			case "jul":
				tmpMonth = 7;
				break;
			default: 
				tmpMonth = 0;
				break;
		}
		dateTime = LocalDateTime.of(Integer.parseInt(split(tmpdate, '.')[2])+floor(year/100)*100, tmpMonth, Integer.parseInt(split(tmpdate, '.')[0]), Integer.parseInt(split(tmptime, ':')[0]), Integer.parseInt(split(tmptime, ':')[1]));
		round = tmpround;
		stadium = tmpstadium;
		city = tmpcity;
		country = tmpcountry;
		homeTeam = tmphomeTeam;
		homeGoals = tmphomeGoals;
		awayGoals = tmpawayGoals;
		awayTeam = tmpawayTeam;
		observation = tmpobservation;
	}

	public String toString(){
		return year + " - " + dateTime.getYear() + "." + dateTime.getMonth() + "." + dateTime.getDayOfMonth() + " " + dateTime.getHour() + ":" + dateTime.getMinute() + " - " +
		 round + " - " + stadium + " - " + city + " - " + country + " - " +
		 homeTeam + " - " + homeGoals + " - " + awayGoals + " - " + awayTeam + " - " + observation;
	}
}