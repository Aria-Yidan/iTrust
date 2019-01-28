package edu.ncsu.csc.itrust.model.old.beans;

/*
 * A bean for storing pre-existing conditions of patients
 * (includes diabetes, chronic illness (autoimmune disorders), cancers, STDs,
 * Hyperemesis gravidarum, Hypothyroidism, and High genetic potential for miscarriage
 */

import java.util.Objects;

public class PreExistingConditionRecordBean {

    long patientMID;
    String icdInfo;

    // default constructor
    public PreExistingConditionRecordBean() { }

    /**
     * constructor with two parameters: patientMID and icdInfo
     *
     * @param patientMID
     * @param icdInfo
     */
    public PreExistingConditionRecordBean(long patientMID, String icdInfo) {
        this.patientMID = patientMID;
        this.icdInfo = icdInfo;
    }

    public long getPatientMID() {
        return patientMID;
    }

    public void setPatientMID(long patientMID) {
        this.patientMID = patientMID;
    }

    public String getIcdInfo() {
        return icdInfo;
    }

    public void setIcdInfo(String icdInfo) {
        this.icdInfo = icdInfo;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        PreExistingConditionRecordBean that = (PreExistingConditionRecordBean) o;
        return patientMID == that.patientMID &&
                Objects.equals(icdInfo, that.icdInfo);
    }
}
