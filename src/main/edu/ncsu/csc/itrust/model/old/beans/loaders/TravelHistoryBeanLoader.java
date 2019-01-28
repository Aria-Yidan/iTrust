package edu.ncsu.csc.itrust.model.old.beans.loaders;

import edu.ncsu.csc.itrust.model.old.beans.TravelHistoryBean;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * A loader for TravelHistoryBean.
 * Loads in information to/from beans using ResultSets and PreparedStatements. Use the superclass to enforce consistency.
*/
public class TravelHistoryBeanLoader implements BeanLoader<TravelHistoryBean> {

    /**
     * Load a list of TravelHistoryBean objects
     *
     * @param rs The java.sql.ResultSet we are extracting.
     * @return
     * @throws SQLException
     */
    @Override
    public List<TravelHistoryBean> loadList(ResultSet rs) throws SQLException {
        ArrayList<TravelHistoryBean> list = new ArrayList<>();
        while (rs.next()) {
            list.add(loadSingle(rs));
        }
        return list;
    }

    /**
     * Load a single TravelHistoryBean obejct
     *
     * @param rs The java.sql.ResultSet to be loaded.
     * @return
     * @throws SQLException
     */
    @Override
    public TravelHistoryBean loadSingle(ResultSet rs) throws SQLException {
        TravelHistoryBean travelHistory = new TravelHistoryBean(rs.getLong("patientMID"),
                rs.getDate("startDate"),
                rs.getDate("endDate"),
                rs.getString("travelledCities"));
        return travelHistory;
    }

    /**
     * Set the PreparedStatement object with the TravelHistoryBean object's information
     *
     * @param ps The prepared statement to be loaded.
     * @param bean The bean containing the data to be placed.
     * @return
     * @throws SQLException
     */
    @Override
    public PreparedStatement loadParameters(PreparedStatement ps, TravelHistoryBean bean) throws SQLException {
        int i = 1;
        ps.setLong(i++, bean.getPatientMID());
        ps.setDate(i++, bean.getStartDate());
        ps.setDate(i++, bean.getEndDate());
        ps.setString(i++, bean.getTravelledCities());
        return ps;
    }
}
