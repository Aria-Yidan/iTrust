package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_99;

import edu.ncsu.csc.itrust.exception.DBException;
import edu.ncsu.csc.itrust.exception.ITrustException;
import edu.ncsu.csc.itrust.model.old.beans.TravelHistoryBean;
import edu.ncsu.csc.itrust.model.old.dao.mysql.TravelHistoryDAO;
import edu.ncsu.csc.itrust.unit.datagenerators.TestDataGenerator;
import edu.ncsu.csc.itrust.unit.testutils.TestDAOFactory;
import junit.framework.TestCase;
import org.junit.Before;
import org.junit.Test;
import java.util.List;


public class TravelHistoryDAOTest extends TestCase {
    /** TravelHistoryDAO instance for testing */
    private TravelHistoryDAO tdao = TestDAOFactory.getTestInstance().getTravelHistoryDAO();
    /**
     * Provide setup for the rest of the tests; initialize all globals.
     *
     * @throws Exception
     */
    @Before
    public void setUp() throws Exception {
        TestDataGenerator gen = new TestDataGenerator();
        gen.clearAllTables();
        gen.travelHistory1();
    }

    /**
     * Tests adding a TravelHistory to the TravelHistoryTable.
     */
    @Test
    public final void testAddTravelHistoryValid() throws DBException{
        try {
            TravelHistoryBean thb = new TravelHistoryBean();
            thb.setPatientMID(12L);
            thb.setStartDate(new java.sql.Date(System.currentTimeMillis() - 10000000000L));
            thb.setEndDate(new java.sql.Date(System.currentTimeMillis() - 1000000000L));
            thb.setTravelledCities("Paris,France");
            tdao.addTravelHistory(thb);
            assertEquals(1, tdao.getTravelHistoriesByMID(12L).size());
        } catch (Exception e) {
            fail();
        }
    }

    /**
     * Tests getting TravelHistory from a current database for a given Patient.
     *
     * @throws DBException
     */
    @Test(expected = DBException.class)
    public final void testGetTravelHistory() throws DBException {
        try {
            List<TravelHistoryBean> l = tdao.getTravelHistoriesByMID(16L);
            // test getting TravelHistory for p1
            assertEquals(1, l.size());

            l = tdao.getTravelHistoriesByMID(1L);
            assertEquals(4, l.size());
        } catch (DBException e) {
            fail();
        }
    }
}
