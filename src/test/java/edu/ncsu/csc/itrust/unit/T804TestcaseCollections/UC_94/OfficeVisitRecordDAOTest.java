package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_94;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;

import edu.ncsu.csc.itrust.model.old.dao.mysql.OfficeVisitRecordDAO;
import edu.ncsu.csc.itrust.model.old.beans.OfficeVisitRecordBean;

import edu.ncsu.csc.itrust.exception.DBException;
import edu.ncsu.csc.itrust.exception.FormValidationException;
import edu.ncsu.csc.itrust.model.old.dao.DAOFactory;
import edu.ncsu.csc.itrust.unit.datagenerators.TestDataGenerator;
import edu.ncsu.csc.itrust.unit.testutils.TestDAOFactory;
import junit.framework.TestCase;

public class OfficeVisitRecordDAOTest extends TestCase {

    private OfficeVisitRecordDAO dao;
    private DAOFactory factory;
    private long mid = 1L;
    private long hcpId = 9000000000L;

    @Override
    protected void setUp() throws Exception {
        this.factory = TestDAOFactory.getTestInstance();
        this.dao = new OfficeVisitRecordDAO(this.factory);
        TestDataGenerator gen = new TestDataGenerator();
        gen.clearOfficeVisitRecords();
    }

    public void testAddOfficeVisitRecord() throws FormValidationException, SQLException, DBException {
        OfficeVisitRecordBean b = new OfficeVisitRecordBean();
        b.setHcp(hcpId);
        b.setPatient(mid);
        b.setOfficeVisitRecordID(3657);
        b.setWeeksOfPregnant("3-05");
        b.setWeightGain(11.2);
        b.setHighBloodPressure(1.024);
        b.setLowBloodPressure(1.024);
        b.setFetalHeartRate(2.98);
        b.setNumberOfPregnancy(1);
        b.setLowLyingPlacenta(true);
        b.setCurrentDate(new Timestamp(new Date().getTime()));

        dao.addOfficeVisitRecord(b);

        assertEquals(dao.getOfficeVisitRecord(3657).size(), 1);
    }

    public void testModifyOfficeVisitRecord() throws FormValidationException, SQLException, DBException {
        OfficeVisitRecordBean b = new OfficeVisitRecordBean();
        b.setHcp(hcpId);
        b.setPatient(mid);
        b.setOfficeVisitRecordID(3657);
        b.setWeeksOfPregnant("3-05");
        b.setWeightGain(11.2);
        b.setHighBloodPressure(1.024);
        b.setLowBloodPressure(1.024);
        b.setFetalHeartRate(2.98);
        b.setNumberOfPregnancy(1);
        b.setLowLyingPlacenta(true);
        b.setCurrentDate(new Timestamp(new Date().getTime()));

        dao.addOfficeVisitRecord(b);

        String weeksOfPregnant = new String("6-02");
        b.setWeeksOfPregnant(weeksOfPregnant);
        dao.modifyOfficeVisitRecord(b);

        assertEquals(dao.getOfficeVisitRecord(3657).get(0).getWeeksOfPregnant(), weeksOfPregnant);
    }

    public void testDeleteOfficeVisitRecord() throws FormValidationException, SQLException, DBException {
        OfficeVisitRecordBean b = new OfficeVisitRecordBean();
        b.setHcp(hcpId);
        b.setPatient(mid);
        b.setOfficeVisitRecordID(3657);
        b.setWeeksOfPregnant("3-05");
        b.setWeightGain(11.2);
        b.setHighBloodPressure(1.024);
        b.setLowBloodPressure(1.024);
        b.setFetalHeartRate(2.98);
        b.setNumberOfPregnancy(1);
        b.setLowLyingPlacenta(true);
        b.setCurrentDate(new Timestamp(new Date().getTime()));

        dao.addOfficeVisitRecord(b);

        OfficeVisitRecordBean c = new OfficeVisitRecordBean();
        c.setOfficeVisitRecordID(3657);
        dao.deleteOfficeVisitRecord(c);

        assertEquals(dao.getOfficeVisitRecord(3657).size(), 0);
    }
}
