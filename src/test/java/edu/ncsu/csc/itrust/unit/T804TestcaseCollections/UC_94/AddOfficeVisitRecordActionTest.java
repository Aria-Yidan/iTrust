package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_94;

import java.sql.SQLException;
import java.sql.Timestamp;

import edu.ncsu.csc.itrust.action.AddOfficeVisitRecordAction;
import edu.ncsu.csc.itrust.exception.DBException;
import edu.ncsu.csc.itrust.exception.FormValidationException;
import edu.ncsu.csc.itrust.exception.ITrustException;
import edu.ncsu.csc.itrust.model.old.beans.OfficeVisitRecordBean;
import edu.ncsu.csc.itrust.model.old.dao.DAOFactory;
import edu.ncsu.csc.itrust.unit.datagenerators.TestDataGenerator;
import edu.ncsu.csc.itrust.unit.testutils.TestDAOFactory;
import junit.framework.TestCase;

public class AddOfficeVisitRecordActionTest extends TestCase {
    private AddOfficeVisitRecordAction action;
    private DAOFactory factory;
    private long mid = 1L;
    private long hcpId = 9000000000L;
    TestDataGenerator gen;

    @Override
    protected void setUp() throws Exception {
        gen = new TestDataGenerator();
        gen.clearAllTables();
        gen.standardData();

        this.factory = TestDAOFactory.getTestInstance();
        this.action = new AddOfficeVisitRecordAction(this.factory, this.hcpId);
    }

    public void testAddOfficeVisitRecord() throws FormValidationException, SQLException, DBException {
        OfficeVisitRecordBean b = new OfficeVisitRecordBean();

        b.setHcp(hcpId);
        b.setPatient(mid);
        b.setCurrentDate(new Timestamp(System.currentTimeMillis() + (10 * 60 * 1000)));

        b.setOfficeVisitRecordID(3657);
        b.setWeeksOfPregnant("3-05");
        b.setWeightGain(11.2);
        b.setHighBloodPressure(1.024);
        b.setLowBloodPressure(1.024);
        b.setFetalHeartRate(2.98);
        b.setNumberOfPregnancy(1);
        b.setLowLyingPlacenta(true);

        assertTrue(action.addOfficeVisitRecord(b, true).startsWith("Success"));
    }

    public void testGetName() throws ITrustException {
        assertEquals("Kelly Doctor", action.getName(hcpId));
    }

    public void testGetName2() throws ITrustException {
        assertEquals("Random Person", action.getName(mid));
    }
}
