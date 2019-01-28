package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_94;

import edu.ncsu.csc.itrust.model.old.beans.UltraSoundRecordBean;
import junit.framework.TestCase;

public class UltrasoundRecordBeanTest extends TestCase {

    public void testUltrasoundRecordEquals() {
        UltraSoundRecordBean b = new UltraSoundRecordBean();
        b.setUltraSoundID(3);

        UltraSoundRecordBean a = new UltraSoundRecordBean();
        a.setUltraSoundID(3);

        assertTrue(a.equals(b));
    }
}
