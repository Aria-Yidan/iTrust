package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_94;

import edu.ncsu.csc.itrust.model.old.beans.UltraSoundRecordBean;
import edu.ncsu.csc.itrust.model.old.dao.DAOFactory;
import edu.ncsu.csc.itrust.model.old.dao.mysql.UltraSoundRecordDAO;
import edu.ncsu.csc.itrust.unit.datagenerators.TestDataGenerator;
import edu.ncsu.csc.itrust.unit.testutils.TestDAOFactory;
import junit.framework.TestCase;

public class UltrasoundDAOTest extends TestCase {
    private DAOFactory factory = TestDAOFactory.getTestInstance();
    private UltraSoundRecordDAO ultrasoundRecordDAO = factory.getUltraSoundRecordDAO();
    private UltraSoundRecordBean u1;

    @Override
    protected void setUp() throws Exception {
        TestDataGenerator gen = new TestDataGenerator();
        gen.clearAllTables();
        gen.appointmentType();

        u1 = new UltraSoundRecordBean();
        u1.setUltraSoundID(1);
        u1.setOfficeVisitID(10);
        u1.setCrownRumpLength(1.42857);
        u1.setBiparietalDiameter(2.85714);
        u1.setHeadCircumference(4.28571);
        u1.setFemurLength(5.71428);
        u1.setOcciFrontalDiameter(7.14285);
        u1.setAbdoCircumference(8.57142);
        u1.setHumerusLength(14.2857);
        u1.setEstimatedFetalWeight(28.5714);
        u1.setUltraSoundImage("/image1.jpg");

    }

    public void testAddUltrasoundRecord() throws Exception {

        ultrasoundRecordDAO.addUltraSoundRecord(u1);
    }
}
