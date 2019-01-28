package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_94;

import java.sql.SQLException;

import edu.ncsu.csc.itrust.action.AddUltrasoundRecordAction;
import edu.ncsu.csc.itrust.exception.DBException;
import edu.ncsu.csc.itrust.exception.FormValidationException;
import edu.ncsu.csc.itrust.exception.ITrustException;
import edu.ncsu.csc.itrust.model.old.beans.UltraSoundRecordBean;
import edu.ncsu.csc.itrust.model.old.dao.DAOFactory;
import edu.ncsu.csc.itrust.unit.datagenerators.TestDataGenerator;
import edu.ncsu.csc.itrust.unit.testutils.TestDAOFactory;
import junit.framework.TestCase;

public class AddUltrasoundRecordActionTest extends TestCase {
    private AddUltrasoundRecordAction action;
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
        this.action = new AddUltrasoundRecordAction(this.factory, this.hcpId);
    }

    public void testAddUltrasoundRecord() throws FormValidationException, SQLException, DBException {
        UltraSoundRecordBean b = new UltraSoundRecordBean();
        b.setUltraSoundID(3568);
        b.setAbdoCircumference(2);
        b.setBiparietalDiameter(3);
        b.setCrownRumpLength(4);
        b.setEstimatedFetalWeight(5);
        b.setFemurLength(6);
        b.setHeadCircumference(7);
        b.setHumerusLength(8);
        b.setOcciFrontalDiameter(9);
        b.setOfficeVisitID(1);
        b.setUltraSoundImage("");

        assertTrue(action.addUltrasoundRecord(b, true).startsWith("Success"));
    }

    public void testGetName() throws ITrustException {
        assertEquals("Kelly Doctor", action.getName(hcpId));
    }

    public void testGetName2() throws ITrustException {
        assertEquals("Random Person", action.getName(mid));
    }
}
