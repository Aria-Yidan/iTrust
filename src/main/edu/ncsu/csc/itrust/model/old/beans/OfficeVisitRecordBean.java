package edu.ncsu.csc.itrust.model.old.beans;


import edu.ncsu.csc.itrust.model.old.dao.DAOFactory;

import java.sql.Timestamp;

/**
 * class for officevisit record
 */
public class OfficeVisitRecordBean {
    private long officeVisitRecordID;
    private long patient;
    private long hcp;
    private String weeksOfPregnant;
    private double weightGain;
    private double highbloodPressure;
    private double lowbloodPressure;
    private double fetalHeartRate;
    private int numberOfPregnancy;
    private boolean lowLyingPlacenta;
    private Timestamp currentDate;

    /**
     * get officevisitrecord ID
     * @return officevisitrecord ID
     */
    public long getOfficeVisitRecordID(){
        return officeVisitRecordID;
    }

    /**
     * set officevisitrecord ID
     * @param officeVisitRecordID
     */
    public void setOfficeVisitRecordID(long officeVisitRecordID){
        this.officeVisitRecordID = officeVisitRecordID;
    }

    /**
     * get patient ID
     * @return patient ID
     */
    public long getPatient(){
        return patient;
    }

    /**
     * set patient ID
     * @param patient
     */
    public void setPatient(long patient){
        this.patient = patient;
    }

    /**
     * get HCP ID
     * @return HCP ID
     */
    public long getHcp(){
        return hcp;
    }

    /**
     * set HCP ID
     * @param hcp
     */
    public void setHcp(long hcp){
        this.hcp = hcp;
    }

    /**
     * get weeks of pregnant
     * @return weeks of pregnant
     */
    public String getWeeksOfPregnant(){
        return weeksOfPregnant;
    }

    /**
     * set weeks of pregnant
     * @param weeksOfPregnant
     */
    public void setWeeksOfPregnant(String weeksOfPregnant){
        this.weeksOfPregnant = weeksOfPregnant;
    }

    /**
     * get weight gain
     * @return weight gain
     */
    public double getWeightGain(){
        return weightGain;
    }

    /**
     * set weight gain
     * @param weightGain
     */
    public void setWeightGain(double weightGain){
        this.weightGain = weightGain;
    }

    /**
     * get high blood pressure
     * @return high blood pressure
     */
    public double getHighBloodPressure(){
        return highbloodPressure;
    }

    /**
     * set highbloodPressure
     * @param highbloodPressure
     */
    public void setHighBloodPressure(double highbloodPressure){
        this.highbloodPressure = highbloodPressure;
    }

    /**
     * get weight gain
     * @return weight gain
     */
    public double getLowBloodPressure(){
        return lowbloodPressure;
    }

    /**
     * set lowbloodPressure
     * @param lowbloodPressure
     */
    public void setLowBloodPressure(double lowbloodPressure){
        this.lowbloodPressure = lowbloodPressure;
    }

    /**
     * set fetalHeartRate
     * @param fetalHeartRate
     */
    public void setFetalHeartRate(double fetalHeartRate){
        this.fetalHeartRate = fetalHeartRate;
    }

    /**
     * get Fetal Heart Rate
     * @return Fetal Heart Rate
     */
    public double getFetalHeartRate(){
        return fetalHeartRate;
    }

    /**
     * set numberOfPregnancy
     * @param numberOfPregnancy
     */
    public void setNumberOfPregnancy(int numberOfPregnancy){
        this.numberOfPregnancy = numberOfPregnancy;
    }

    /**
     * get number of pregnant
     * @return number of pregnant
     */
    public int getNumberOfPregnancy(){
        return numberOfPregnancy;
    }

    /**
     * set lowLyingPlacenta
     * @param lowLyingPlacenta
     */
    public void setLowLyingPlacenta(boolean lowLyingPlacenta){
        this.lowLyingPlacenta = lowLyingPlacenta;
    }

    /**
     * get LLP
     * @return LLP
     */
    public boolean getLowLyingPlacenta(){
        return lowLyingPlacenta;
    }

    /**
     * get date
     * @return date
     */
    public Timestamp getCurrentDate(){
        return currentDate;
    }

    /**
     * set currentDate
     * @param currentDate
     */
    public void setCurrentDate(Timestamp currentDate){
        this.currentDate = currentDate;
    }

    /**
     * Returns true if both id's are equal. Probably needs more advance field by field checking.
     */
    @Override public boolean equals(Object other) {

        if (this == other) {
            return true;
        }

        if (!(other instanceof OfficeVisitRecordBean)) {
            return false;
        }

        OfficeVisitRecordBean otherOfficeVisitRecord = (OfficeVisitRecordBean)other;
        return otherOfficeVisitRecord.getOfficeVisitRecordID() == getOfficeVisitRecordID();

    }
}
