class Server {
  Boolean debugMode = true;

  //private ArrayList<HeartStats> allDataFromJSON;
  private HeartStats stats;
  private User user;
  private int x = 120; //this is the index in the JSON representing a particular user and their data

  public Server() {
  }
  
  public void loadEventStream(String eventDataJSON) {
    //allDataFromJSON = this.getAllDataFromJSON(loadJSONArray(eventDataJSON));
    stats = this.getHeartDataFromJSON(loadJSONArray(eventDataJSON));
    user = this.getUserDataFromJSON(loadJSONArray(eventDataJSON));
  }
  
  public HeartStats getStats() {
    return stats;
  }
  
  public User getUser() {
    return user;
  }
  
  public int printSize(String eventDataJSON) {
    return loadJSONArray(eventDataJSON).size();
  }
  
  //public ArrayList<HeartStats> getAllDataFromJSON(JSONArray values) {
  //  ArrayList<HeartStats> allDataFromJSON = new ArrayList();
  //  for (int i = 0; i < values.size(); i++) {
  //    //println(values.getJSONObject(i));
  //    allDataFromJSON.add(new HeartStats(values.getJSONObject(i)));
  //  }
  //  return allDataFromJSON;
  //}
  
  public HeartStats getHeartDataFromJSON(JSONArray values) {
    return new HeartStats(values.getJSONObject(x));
  }
  
  public User getUserDataFromJSON(JSONArray values) {
    return new User(values.getJSONObject(x));
  }
}
