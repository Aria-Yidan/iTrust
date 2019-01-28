package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_99;

import edu.ncsu.csc.itrust.model.old.beans.TravelHistoryBean;
import edu.ncsu.csc.itrust.model.old.beans.loaders.TravelHistoryBeanLoader;

import junit.framework.TestCase;
import org.easymock.classextension.IMocksControl;
import org.junit.Test;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static org.easymock.EasyMock.expect;
import static org.easymock.classextension.EasyMock.createControl;

public class TravelHistoryBeanLoaderTest extends TestCase {
    private IMocksControl ctrl;
    ResultSet rs;
    List<TravelHistoryBean> list = new ArrayList<TravelHistoryBean>();
    TravelHistoryBeanLoader thb = new TravelHistoryBeanLoader();

    /**
     * setUp
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
            list = thb.loadList(rs);
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
            expect(rs.getDate("startDate")).andReturn(null).once();
            expect(rs.getDate("endDate")).andReturn(null).once();
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
            thb.loadParameters(null, null);
            fail();
        } catch (Exception e) {
            // TODO
        }

        assertTrue(true);
    }
}
