package edu.ncsu.csc.itrust.model.old.beans;

public class ObstetricsInitRecordBean {
  private long MID;
  private String LMP;
  private String EDD;
  private String weeksOfPregnant;
  private String recordCreatedTime;

  public long getMID() {
    return MID;
  }

  public void setMID(long MID) {
    this.MID = MID;
  }

  public String getEDD() {
    return EDD;
  }

  public void setEDD(String EDD) {
    this.EDD = EDD;
  }

  public String getLMP() {
    return LMP;
  }

  public void setLMP(String LMP) {
    this.LMP = LMP;
  }

  public String getWeeksOfPregnant() {
    return weeksOfPregnant;
  }

  public void setWeeksOfPregnant(String weeksOfPregnant) {
    this.weeksOfPregnant = weeksOfPregnant;
  }

  public String getRecordCreatedTime() {
    return recordCreatedTime;
  }

  public void setRecordCreatedTime(String recordCreatedTime) {
    this.recordCreatedTime = recordCreatedTime;
  }

}
