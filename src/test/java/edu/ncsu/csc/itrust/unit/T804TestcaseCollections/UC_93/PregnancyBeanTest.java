package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_93;

import edu.ncsu.csc.itrust.model.old.beans.PregnancyBean;
import junit.framework.TestCase;

public class PregnancyBeanTest  extends TestCase {
  public void testBean() {
    PregnancyBean pb = new PregnancyBean();
    pb.setYearOfConception(2018);
    pb.setWeightGain(10.5);
    pb.setHoursInLabor(5.1);
    pb.setDeliveryType("vaginal delivery");
    pb.setWeeksOfPregnant("35-5");
    pb.setPregnancyNumber(2);

    assertEquals(2018, pb.getYearOfConception());
    assertEquals(10.5, pb.getWeightGain());
    assertEquals(5.1, pb.getHoursInLabor());
    assertEquals("vaginal delivery", pb.getDeliveryType());
    assertEquals("35-5", pb.getWeeksOfPregnant());
    assertEquals(2, pb.getPregnancyNumber());
  }
}
