static class BloodPressure {
  protected String currBP;
  
  public BloodPressure(JSONObject json) {
    if (json.isNull("currentBloodPressure")) {
      this.currBP = "";
    }
    else {
      this.currBP = json.getString("currentBloodPressure");      
    }   
  }
  
  public String getCurrBP() {
    return currBP;
  }
  
  private String measureBP() {
    //method that the device would use to measure the user's blood pressure
    return "";
  }
  
  public void printBP() {
    println(currBP);
  }
}
