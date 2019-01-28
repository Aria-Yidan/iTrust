package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_96;

import edu.ncsu.csc.itrust.model.old.beans.PatientBean;
import edu.ncsu.csc.itrust.model.old.beans.loaders.PatientLoader;
import junit.framework.TestCase;
import org.easymock.classextension.IMocksControl;
import org.junit.Test;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import static org.easymock.EasyMock.expect;
import static org.easymock.classextension.EasyMock.createControl;


public class PatientBeanLoaderTest extends TestCase {

    private IMocksControl ctrl;
    ResultSet rs;
    List<PatientBean> list = new ArrayList<>();
    PatientLoader loader = new PatientLoader();

    /**
     * Set Up
     */
    @Override
    protected void setUp() throws Exception {
        ctrl = createControl();
        rs = ctrl.createMock(ResultSet.class);
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

        assertTrue(true);
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
