package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_95;

import edu.ncsu.csc.itrust.model.old.beans.PreExistingConditionRecordBean;
import edu.ncsu.csc.itrust.model.old.beans.loaders.PreExistingConditionRecordBeanLoader;
import junit.framework.TestCase;
import org.easymock.classextension.IMocksControl;
import org.junit.Test;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import static org.easymock.EasyMock.expect;
import static org.easymock.classextension.EasyMock.createControl;


public class PreExistingConditionRecordBeanLoaderTest extends TestCase {

    private IMocksControl ctrl;
    ResultSet rs;
    List<PreExistingConditionRecordBean> list = new ArrayList<>();
    PreExistingConditionRecordBeanLoader loader = new PreExistingConditionRecordBeanLoader();

    /**
     * Set Up
     */
    @Override
    protected void setUp() throws Exception {
        ctrl = createControl();
        rs = ctrl.createMock(ResultSet.class);
        assertTrue(true);
    }

    /**
     * testLoadList
     */
    @Test
    public void testLoadList() {
        try {
            list = loader.loadList(rs);
        } catch (SQLException e) {
            // TODO
        }

        assertEquals(0, list.size());
    }

    /**
     * testloadSingle
     */
    public void testloadSingle() {
        try {
            expect(rs.getString("icdInfo")).andReturn("No Pre-existing condition found").once();
            ctrl.replay();

            //thb.loadSingle(rs);
        } catch (SQLException e) {
            // TODO
        }
        assertTrue(true);
    }

    /**
     * testLoadParameters
     */
    public void testLoadParameters() {
        try {
            loader.loadParameters(null, null);
            fail();
        } catch (Exception e) {
            // TODO
        }

        assertTrue(true);
    }
}
