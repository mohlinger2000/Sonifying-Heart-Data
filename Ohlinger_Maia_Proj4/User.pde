static class User {
  protected String name;
  protected String gender;
  protected int age;
  protected float bmi;
  protected int numTimesPurged;
  protected int numPalpitationEpisodes;
  protected HeartStats stats;
  protected JSONObject json;
  
  public User(JSONObject json) {
    if (json.isNull("name")) {
      this.name = "";
    }
    else {
      this.name = json.getString("name");      
    }
    
    if (json.isNull("gender")) {
      this.gender = "";
    }
    else {
      this.gender = json.getString("gender");      
    }  
    
    this.age = json.getInt("age");
    this.bmi = json.getFloat("bmi");
    this.numTimesPurged = json.getInt("numberOfPurges");
    this.numPalpitationEpisodes = json.getInt("numberOfPalpitations");
  }
  
  private int increasePurge() {
    return numTimesPurged++;
  }
  
  private int increasePalpitations() {
    return numPalpitationEpisodes++;
  }
  
  public String getName() {
    return name;
  }
  
  public String getGender() {
    return gender;
  }
  
  public int getAge() {
    return age;
  }
  
  public float getBmi() {
    return bmi;
  }
  
  public int getNumTimesPurged() {
    return numTimesPurged;
  }
  
  public int getNumPalpitationEpisodes() {
    return numPalpitationEpisodes;
  }
  
  public void setNumTimesPurged() {
    numTimesPurged = increasePurge();
  }
  
  public void setNumPalpitationEpisodes() {
    numPalpitationEpisodes = increasePalpitations();
  }
  
  public void printUserInfo() {
    println("Name: " + name + "\nGender: " + gender + "\nAge: " + age + "\nBMI: " + bmi + "\nPurged: " + numTimesPurged + "\nPalpitations: " + numPalpitationEpisodes);
  }
}
