package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_95;

import edu.ncsu.csc.itrust.exception.DBException;
import edu.ncsu.csc.itrust.model.old.beans.PreExistingConditionRecordBean;
import edu.ncsu.csc.itrust.model.old.dao.mysql.PreExistingConditionRecordDAO;
import edu.ncsu.csc.itrust.unit.datagenerators.TestDataGenerator;
import edu.ncsu.csc.itrust.unit.testutils.TestDAOFactory;
import junit.framework.TestCase;
import org.junit.Before;
import org.junit.Test;
import java.util.List;

public class PreExistingConditionRecordDAOTest extends TestCase {

    // PreExistingConditionRecordDAO instance for testing
    private PreExistingConditionRecordDAO pdao = TestDAOFactory.getTestInstance().getPreExistingConditionRecordDAO();

    /**
     * Provide setup for the rest of the tests; initialize all globals.
     *
     * @throws Exception
     */
    @Before
    public void setUp() throws Exception {
        TestDataGenerator gen = new TestDataGenerator();
        gen.clearAllTables();
        gen.preExistingConditionRecord1();
    }

    /*
     * Tests getting pre-existing condition records from a current database for a given patient
     */
    @Test(expected = DBException.class)
    public final void testGetPreExistingConditionRecord() throws DBException {
        try {
            List<PreExistingConditionRecordBean> list = pdao.getPreExistingConditionRecordsByMID(16L);
            assertEquals(1, list.size());

            PreExistingConditionRecordBean bean = list.get(0);
            String[] threeConditions = bean.getIcdInfo().split("&");
            assertEquals(threeConditions[0].trim(), "R971, Elevated cancer antigen 125 [CA 125], 0");
            assertEquals(threeConditions[1].trim(), "A64, Unspecified sexually transmitted disease, 0");
            assertEquals(threeConditions[2].trim(), "D720, Genetic anomalies of leukocytes, 0");
        } catch (DBException e) {
            fail();
        }
    }
}
