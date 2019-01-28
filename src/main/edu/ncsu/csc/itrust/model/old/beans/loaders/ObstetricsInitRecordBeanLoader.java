package edu.ncsu.csc.itrust.model.old.beans.loaders;

import edu.ncsu.csc.itrust.model.old.beans.ObstetricsInitRecordBean;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * A loader for ObstetricsInitRecordBean.
 *
 * Loads in information to/from beans using ResultSets and PreparedStatements. Use the superclass to enforce consistency.
 * For details on the paradigm for a loader (and what its methods do), see {@link BeanLoader}
 */
public class ObstetricsInitRecordBeanLoader implements BeanLoader<ObstetricsInitRecordBean> {

  /**
   * Load a list of ObstetricsInitRecordBean from rs
   * @param rs
   * @return list
   * @throws SQLException
   */
  @Override
  public List<ObstetricsInitRecordBean> loadList(ResultSet rs) throws SQLException {
    List<ObstetricsInitRecordBean> list = new ArrayList<>();
    while (rs.next()) {
      list.add(loadSingle(rs));
    }
    return list;
  }

  /**
   * Load a single ObstetricsInitRecordBean from rs
   * @param rs
   * @return o
   * @throws SQLException
   */
  @Override
  public ObstetricsInitRecordBean loadSingle(ResultSet rs) throws SQLException {
    ObstetricsInitRecordBean o = new ObstetricsInitRecordBean();
    o.setMID(rs.getLong("MID"));
    o.setLMP(rs.getString("LMP"));
    o.setEDD(rs.getString("EDD"));
    o.setWeeksOfPregnant(rs.getString("weeksOfPregnant"));
    o.setRecordCreatedTime(rs.getString("recordCreatedTime"));
    return o;
  }

  /**
   * Load the info in ObstetricsInitRecordBean into a prepared statement
   * @param ps
   * @param p
   * @return ps
   * @throws SQLException
   */
  @Override
  public PreparedStatement loadParameters(PreparedStatement ps, ObstetricsInitRecordBean p) throws SQLException {
    int i = 1;
    ps.setLong(i++, p.getMID());
    ps.setString(i++, p.getLMP());
    ps.setString(i++, p.getEDD());
    ps.setString(i, p.getWeeksOfPregnant());
    return ps;
  }
}
