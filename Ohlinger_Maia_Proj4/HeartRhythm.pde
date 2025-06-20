static class HeartRhythm {
  protected String rhythm;
  
  public HeartRhythm(JSONObject json) {
    if (json.isNull("heartRhythm")) {
      this.rhythm = "";
    }
    else {
      this.rhythm = json.getString("heartRhythm");      
    }
  }
  
  public String getRhythm() {
    return rhythm;
  }
  
  private String findHeartRhythm() {
    //method that device would use to find the rhythm of the user's heart
    return "";
  }
  
  public void printRhythm() {
    println(rhythm);
  }
}
