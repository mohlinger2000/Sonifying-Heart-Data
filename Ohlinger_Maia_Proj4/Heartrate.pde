static class Heartrate {
  protected int currHR;
  
  public Heartrate(JSONObject json) {
    this.currHR = json.getInt("currentHeartrate");      
  }
  
  public int getCurrHR() {
    return currHR;
  }
  
  private int measureHeartrate() {
    //method that the device would use to measure the user's heartrate
    return 0;
  }
  
  public void printHR() {
    println(currHR + " bpm");
  }
}
