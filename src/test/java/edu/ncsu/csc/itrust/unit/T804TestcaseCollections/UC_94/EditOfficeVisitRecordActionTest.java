package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_94;

import java.util.List;

import edu.ncsu.csc.itrust.action.EditOfficeVisitRecordAction;
import edu.ncsu.csc.itrust.action.ViewMyOfficeVisitRecordsAction;
import edu.ncsu.csc.itrust.exception.DBException;
import edu.ncsu.csc.itrust.exception.ITrustException;
import edu.ncsu.csc.itrust.model.old.beans.OfficeVisitRecordBean;
import edu.ncsu.csc.itrust.model.old.dao.DAOFactory;
import edu.ncsu.csc.itrust.unit.datagenerators.TestDataGenerator;
import edu.ncsu.csc.itrust.unit.testutils.TestDAOFactory;
import junit.framework.TestCase;

public class EditOfficeVisitRecordActionTest extends TestCase {
    private EditOfficeVisitRecordAction editAction;
    private ViewMyOfficeVisitRecordsAction viewAction;
    private DAOFactory factory;
    private long hcpId = 9000000000L;
    private TestDataGenerator gen = new TestDataGenerator();

    @Override
    protected void setUp() throws Exception {
        this.factory = TestDAOFactory.getTestInstance();
        this.editAction = new EditOfficeVisitRecordAction(this.factory, this.hcpId);
        this.viewAction = new ViewMyOfficeVisitRecordsAction(this.factory, this.hcpId);
        gen.clearAllTables();
        gen.pregnancy1();
        gen.patient42();
        gen.hcp0();
    }

    public void testGetOfficeVisitRecords() throws Exception, DBException {
        List<OfficeVisitRecordBean> officeVisitRecords = viewAction.getMyOfficeVisitRecords();
        OfficeVisitRecordBean b1 = officeVisitRecords.get(0);
        OfficeVisitRecordBean b2 = editAction.getOfficeVisitRecord((int)(b1.getOfficeVisitRecordID()));
        OfficeVisitRecordBean b3;

        b3 = editAction.getOfficeVisitRecord(1234567891);

        assertTrue(b3 == null);

        assertEquals(b1.getOfficeVisitRecordID(), b2.getOfficeVisitRecordID());
        assertEquals(b1.getHcp(), b2.getHcp());
        assertEquals(b1.getPatient(), b2.getPatient());
        assertEquals(b1.getCurrentDate(), b2.getCurrentDate());
    }

    /**
     * testGetName
     *
     * @throws ITrustException
     */
    public void testGetName() throws ITrustException {
        assertEquals("Kelly Doctor", editAction.getName(hcpId));
        assertEquals("Bad Horse", editAction.getName(42));
    }
}
