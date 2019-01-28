package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_93;

import edu.ncsu.csc.itrust.exception.ITrustException;
import edu.ncsu.csc.itrust.model.old.beans.ObstetricsInitRecordBean;
import edu.ncsu.csc.itrust.model.old.dao.mysql.ObstetricsInitRecordDAO;
import edu.ncsu.csc.itrust.unit.datagenerators.TestDataGenerator;
import edu.ncsu.csc.itrust.unit.testutils.EvilDAOFactory;
import edu.ncsu.csc.itrust.unit.testutils.TestDAOFactory;
import junit.framework.TestCase;

import java.util.List;

public class ListAllObstetricsInitRecordTest extends TestCase {

  @Override
  protected void setUp() throws Exception {
    TestDataGenerator gen = new TestDataGenerator();
    gen.clearAllTables();
    gen.obstetricsInitRecord1();
  }

  public void testListAllObstetricsInitRecord() throws Exception {
    ObstetricsInitRecordDAO obstetricsInitRecordDAO = TestDAOFactory.getTestInstance().getObstetricsInitRecordDAO();
    List<ObstetricsInitRecordBean> list = obstetricsInitRecordDAO.getAllObstetricsInitRecord(6L);
    assertEquals(1, list.size());
    ObstetricsInitRecordBean obstetricsInitRecordBean = list.get(0);

    assertEquals(6, obstetricsInitRecordBean.getMID());
    assertEquals("20-6", obstetricsInitRecordBean.getWeeksOfPregnant());
    assertEquals("03/02/2018", obstetricsInitRecordBean.getLMP());
    assertEquals("12/09/2018", obstetricsInitRecordBean.getEDD());
  }

  /**
   * testEvilDAOFactory
   */
  public void testEvilDAOFactory() {
    ObstetricsInitRecordDAO obstetricsInitRecordDAO = EvilDAOFactory.getEvilInstance().getObstetricsInitRecordDAO();
    try {
      obstetricsInitRecordDAO.getAllObstetricsInitRecord(6L);
      fail();
    } catch (ITrustException e) {
      assertSame("A database exception has occurred. Please see the log in the " + "console for stacktrace",
          e.getMessage());
    }
  }
}
