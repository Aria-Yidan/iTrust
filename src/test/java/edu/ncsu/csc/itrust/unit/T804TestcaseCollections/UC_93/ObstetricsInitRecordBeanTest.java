package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_93;

import edu.ncsu.csc.itrust.model.old.beans.ObstetricsInitRecordBean;
import junit.framework.TestCase;

public class ObstetricsInitRecordBeanTest extends TestCase {

  public void testBean() {
    ObstetricsInitRecordBean orb = new ObstetricsInitRecordBean();
    orb.setLMP("01/01/2018");
    orb.setEDD("10/08/2018");
    orb.setWeeksOfPregnant("14-6");

    assertEquals("01/01/2018", orb.getLMP());
    assertEquals("10/08/2018", orb.getEDD());
    assertEquals("14-6", orb.getWeeksOfPregnant());
  }
}
