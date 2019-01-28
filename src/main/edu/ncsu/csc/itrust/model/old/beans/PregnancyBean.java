package edu.ncsu.csc.itrust.model.old.beans;

public class PregnancyBean {

  private long MID;
  private int yearOfConception;
  private String weeksOfPregnant;
  private double hoursInLabor;
  private double weightGain;
  private String deliveryType;
  private int pregnancyNumber;

  public long getMID() {
    return MID;
  }

  public void setMID(long MID) {
    this.MID = MID;
  }

  public int getYearOfConception() {
    return yearOfConception;
  }

  public void setYearOfConception(int yearOfConception) {
    this.yearOfConception = yearOfConception;
  }

  public String getWeeksOfPregnant() {
    return weeksOfPregnant;
  }

  public void setWeeksOfPregnant(String weeksOfPregnant) {
    this.weeksOfPregnant = weeksOfPregnant;
  }

  public double getHoursInLabor() {
    return hoursInLabor;
  }

  public void setHoursInLabor(double hoursInLabor) {
    this.hoursInLabor = hoursInLabor;
  }

  public double getWeightGain() {
    return weightGain;
  }

  public void setWeightGain(double weightGain) {
    this.weightGain = weightGain;
  }

  public String getDeliveryType() {
    return deliveryType;
  }

  public void setDeliveryType(String deliveryType) {
    this.deliveryType = deliveryType;
  }
  
  public int getPregnancyNumber() {
    return pregnancyNumber;
  }

  public void setPregnancyNumber(int pregNum) {
    this.pregnancyNumber = pregNum;
  }
}
