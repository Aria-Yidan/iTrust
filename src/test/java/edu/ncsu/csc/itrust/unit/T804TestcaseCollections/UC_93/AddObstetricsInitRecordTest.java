package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_93;

import edu.ncsu.csc.itrust.exception.ITrustException;
import edu.ncsu.csc.itrust.model.old.beans.ObstetricsInitRecordBean;
import edu.ncsu.csc.itrust.model.old.dao.mysql.ObstetricsInitRecordDAO;
import edu.ncsu.csc.itrust.unit.datagenerators.TestDataGenerator;
import edu.ncsu.csc.itrust.unit.testutils.EvilDAOFactory;
import edu.ncsu.csc.itrust.unit.testutils.TestDAOFactory;
import junit.framework.TestCase;

public class AddObstetricsInitRecordTest extends TestCase {
  private final ObstetricsInitRecordBean obstetricsInitRecordBean = new ObstetricsInitRecordBean();

  @Override
  protected void setUp() throws Exception {
    TestDataGenerator gen = new TestDataGenerator();
    gen.clearAllTables();
    obstetricsInitRecordBean.setMID(1L);
    obstetricsInitRecordBean.setLMP("01/01/2018");
    obstetricsInitRecordBean.setEDD("10/08/2018");
    obstetricsInitRecordBean.setWeeksOfPregnant("20-6");
  }

  public void testAddObstetricsInitRecord() throws Exception {
    ObstetricsInitRecordDAO obstetricsInitRecordDAO = TestDAOFactory.getTestInstance().getObstetricsInitRecordDAO();
    obstetricsInitRecordDAO.addObstetricsInitRecord(obstetricsInitRecordBean);
    assertEquals(1, obstetricsInitRecordDAO.getAllObstetricsInitRecord(1L).size());
  }

  /**
   * testEvilDAOFactory
   */
  public void testEvilDAOFactory() {
    ObstetricsInitRecordDAO obstetricsInitRecordDAO = EvilDAOFactory.getEvilInstance().getObstetricsInitRecordDAO();
    try {
      obstetricsInitRecordDAO.addObstetricsInitRecord(obstetricsInitRecordBean);
      fail();
    } catch (ITrustException e) {
      assertSame("A database exception has occurred. Please see the log in the " + "console for stacktrace",
          e.getMessage());
    }
  }
}
