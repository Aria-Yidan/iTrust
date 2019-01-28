package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_93;

import edu.ncsu.csc.itrust.exception.ITrustException;
import edu.ncsu.csc.itrust.model.old.beans.PregnancyBean;
import edu.ncsu.csc.itrust.model.old.dao.mysql.PregnancyDAO;
import edu.ncsu.csc.itrust.unit.datagenerators.TestDataGenerator;
import edu.ncsu.csc.itrust.unit.testutils.EvilDAOFactory;
import edu.ncsu.csc.itrust.unit.testutils.TestDAOFactory;
import junit.framework.TestCase;

import java.util.List;

public class ListAllPregnancyTest extends TestCase {

  @Override
  protected void setUp() throws Exception {
    TestDataGenerator gen = new TestDataGenerator();
    gen.clearAllTables();
    gen.pregnancy1();
  }

  public void testListAllPregnancy() throws Exception {
    PregnancyDAO pregnancyDAO = TestDAOFactory.getTestInstance().getPregnancyDAO();
    List<PregnancyBean> list = pregnancyDAO.getAllPregnancy(6L);
    assertEquals(3, list.size());
    PregnancyBean pregnancyBean = list.get(0);

    assertEquals(6, pregnancyBean.getMID());
    assertEquals(2018, pregnancyBean.getYearOfConception());
    assertEquals("40-6", pregnancyBean.getWeeksOfPregnant());
    assertEquals(4.5, pregnancyBean.getHoursInLabor());
    assertEquals(20.0, pregnancyBean.getWeightGain());
    assertEquals("vaginal delivery", pregnancyBean.getDeliveryType());
    assertEquals(1, pregnancyBean.getPregnancyNumber());
  }

  /**
   * testEvilDAOFactory
   */
  public void testEvilDAOFactory() {
    PregnancyDAO pregnancyDAO = EvilDAOFactory.getEvilInstance().getPregnancyDAO();
    try {
      pregnancyDAO.getAllPregnancy(6L);
      fail();
    } catch (ITrustException e) {
      assertSame("A database exception has occurred. Please see the log in the " + "console for stacktrace",
          e.getMessage());
    }
  }
}
