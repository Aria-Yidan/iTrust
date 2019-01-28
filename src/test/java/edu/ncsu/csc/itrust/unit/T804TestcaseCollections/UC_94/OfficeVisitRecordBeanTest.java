package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_94;

import edu.ncsu.csc.itrust.model.old.beans.OfficeVisitRecordBean;
import junit.framework.TestCase;

public class OfficeVisitRecordBeanTest extends TestCase {

    public void testOfficeVisitRecordEquals() {
        OfficeVisitRecordBean b = new OfficeVisitRecordBean();
        b.setOfficeVisitRecordID(3);

        OfficeVisitRecordBean a = new OfficeVisitRecordBean();
        a.setOfficeVisitRecordID(3);

        assertTrue(a.equals(b));
    }
}
