package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_93;

import edu.ncsu.csc.itrust.exception.ITrustException;
import edu.ncsu.csc.itrust.model.old.beans.PregnancyBean;
import edu.ncsu.csc.itrust.model.old.dao.mysql.PregnancyDAO;
import edu.ncsu.csc.itrust.unit.datagenerators.TestDataGenerator;
import edu.ncsu.csc.itrust.unit.testutils.EvilDAOFactory;
import edu.ncsu.csc.itrust.unit.testutils.TestDAOFactory;
import junit.framework.TestCase;

public class AddPregnancyTest extends TestCase {
  private final PregnancyBean pregnancyBean = new PregnancyBean();

  @Override
  protected void setUp() throws Exception {
    TestDataGenerator gen = new TestDataGenerator();
    gen.clearAllTables();
    pregnancyBean.setMID(1L);
    pregnancyBean.setYearOfConception(2018);
    pregnancyBean.setWeeksOfPregnant("39-6");
    pregnancyBean.setDeliveryType("vaginal delivery");
  }

  public void testAddPregnancy() throws Exception {
    PregnancyDAO pregnancyDAO = TestDAOFactory.getTestInstance().getPregnancyDAO();
    pregnancyDAO.addPregnancy(pregnancyBean);
    assertEquals(1, pregnancyDAO.getAllPregnancy(1L).size());
  }

  /**
   * testEvilDAOFactory
   */
  public void testEvilDAOFactory() {
    PregnancyDAO pregnancyDAO = EvilDAOFactory.getEvilInstance().getPregnancyDAO();
    try {
      pregnancyDAO.addPregnancy(pregnancyBean);
      fail();
    } catch (ITrustException e) {
      assertSame("A database exception has occurred. Please see the log in the " + "console for stacktrace",
          e.getMessage());
    }
  }
}