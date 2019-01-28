package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_99;

import edu.ncsu.csc.itrust.model.old.beans.TravelHistoryBean;
import junit.framework.TestCase;

public class TravelHistoryBeanTest extends TestCase {
    TravelHistoryBean testBean;
    TravelHistoryBean testBeanTwo;

    /**
     * setUp
     */
    @Override
    public void setUp() {
        testBean = new TravelHistoryBean();
        testBeanTwo = new TravelHistoryBean();
    }

    /**
     * testPatientMID
     */
    public void testPatientMID() {
        testBean.setPatientMID(10L);
        assertEquals(testBean.getPatientMID(), 10L);
    }

    /**
     * testStartDate
     */
    public void testStartDate() {
        java.sql.Date date = new java.sql.Date(System.currentTimeMillis() - 10000000000L);
        testBean.setStartDate(date);
        assertEquals(testBean.getStartDate(), date);
    }

    /**
     * testEndDate
     */
    public void testEndDate() {
        java.sql.Date date = new java.sql.Date(System.currentTimeMillis() - 10000000000L);
        testBean.setEndDate(date);
        assertEquals(testBean.getEndDate(), date);
    }

    /**
     * testEquals
     */
    public void testEquals() {
        java.sql.Date startDate = new java.sql.Date(System.currentTimeMillis() - 10000000000L);
        java.sql.Date endDate = new java.sql.Date(System.currentTimeMillis() - 9000000000L);

        testBean.setPatientMID(1L);
        testBean.setStartDate(startDate);
        testBean.setEndDate(endDate);
        testBean.setTravelledCities("Paris,France");

        testBeanTwo.setPatientMID(1L);
        testBeanTwo.setStartDate(startDate);
        testBeanTwo.setEndDate(endDate);
        testBeanTwo.setTravelledCities("Paris,France");

        assertEquals(testBean, testBeanTwo);
    }

}
