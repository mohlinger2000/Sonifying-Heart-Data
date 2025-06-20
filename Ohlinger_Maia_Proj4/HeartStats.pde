class HeartStats {
  protected Heartrate heartrate;
  protected int avgHR;
  protected BloodPressure bloodPressure;
  protected HeartRhythm heartRhythm;
  protected boolean arrhythmia;;
  
  public HeartStats(JSONObject json) {
    heartrate = new Heartrate(json);
    this.avgHR = json.getInt("averageHeartrate");
    bloodPressure = new BloodPressure(json);
    heartRhythm = new HeartRhythm(json);
    arrhythmia = detectArrhythmia(json.getString("heartRhythm"));
  }
  
  public int getAvgHR() {
    return avgHR;
  }
  
  public boolean getArrhythmia() {
    return arrhythmia;
  }
  
  public int calculateAverageHR(int[] heartrates) {
    int total = 0;
    int len = heartrates.length;
    for (int i = 0; i < len; i++) {
      total += heartrates[i];
    }
    return avgHR = (int) total / len;
  }
  
  public boolean detectArrhythmia(String rhythm) {
    rhythm = rhythm.toUpperCase();
    arrhythmia = false;
    if (rhythm.equals("SINUS") != true) {
      arrhythmia = true;
    }
    return arrhythmia;
  }
  
  public void printAvg() {
    println(avgHR + " bpm");
  }
}
