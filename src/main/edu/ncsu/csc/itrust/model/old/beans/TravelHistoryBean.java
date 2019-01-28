package edu.ncsu.csc.itrust.model.old.beans;

import java.sql.Date;
import java.util.List;
import java.util.Objects;

/**
 * A bean for storing TravelHistory data of patients
 */

public class TravelHistoryBean {
    long patientMID;
    Date startDate;
    Date endDate;
    String travelledCities;

    // default constructor
    public TravelHistoryBean() {
        patientMID = 1L;
        startDate = null;
        endDate = null;
        travelledCities = "";
    }

    /**
     * constructor with patientMID, startDate, endDate, and travelledCities
     *
     * @param pmid
     * @param sd
     * @param ed
     * @param tc
     */
    public TravelHistoryBean(long pmid, Date sd, Date ed, String tc) {
        patientMID = pmid;
        startDate = sd;
        endDate = ed;
        travelledCities = tc;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getTravelledCities() {
        return travelledCities;
    }

    public void setTravelledCities(String travelledCities) {
        this.travelledCities = travelledCities;
    }

    public long getPatientMID() {
        return patientMID;
    }

    public void setPatientMID(long patientMID) {
        this.patientMID = patientMID;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TravelHistoryBean that = (TravelHistoryBean) o;
        return patientMID == that.patientMID &&
                Objects.equals(startDate, that.startDate) &&
                Objects.equals(endDate, that.endDate) &&
                Objects.equals(travelledCities, that.travelledCities);
    }
}
