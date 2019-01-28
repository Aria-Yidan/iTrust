package edu.ncsu.csc.itrust.model.old.beans.loaders;

import edu.ncsu.csc.itrust.model.old.beans.PregnancyBean;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * A loader for PregnancyBean.
 *
 * Loads in information to/from beans using ResultSets and PreparedStatements. Use the superclass to enforce consistency.
 * For details on the paradigm for a loader (and what its methods do), see {@link BeanLoader}
 */
public class PregnancyBeanLoader implements BeanLoader<PregnancyBean>  {

  /**
   * Load a list of PregnancyBean from rs
   * @param rs
   * @return list
   * @throws SQLException
   */
  @Override
  public List<PregnancyBean> loadList(ResultSet rs) throws SQLException {
    List<PregnancyBean> list = new ArrayList<>();
    while (rs.next()) {
      list.add(loadSingle(rs));
    }
    return list;
  }

  /**
   * Load a single PregnancyBean from rs
   * @param rs
   * @return p
   * @throws SQLException
   */
  @Override
  public PregnancyBean loadSingle(ResultSet rs) throws SQLException {
    PregnancyBean p = new PregnancyBean();
    p.setMID(rs.getLong("MID"));
    p.setDeliveryType(rs.getString("deliveryType"));
    p.setWeeksOfPregnant(rs.getString("weeksOfPregnant"));
    p.setHoursInLabor(rs.getDouble("hoursInLabor"));
    p.setWeightGain(rs.getDouble("weightGain"));
    p.setYearOfConception(rs.getInt("yearOfConception"));
    p.setPregnancyNumber(rs.getInt("pregnancyNumber"));
    return p;
  }

  /**
   * Load the info in PregnancyBean into a prepared statement
   * @param ps
   * @param p
   * @return ps
   * @throws SQLException
   */
  @Override
  public PreparedStatement loadParameters(PreparedStatement ps, PregnancyBean p) throws SQLException {
    int i = 1;
    ps.setLong(i++, p.getMID());
    ps.setInt(i++, p.getYearOfConception());
    ps.setString(i++, p.getWeeksOfPregnant());
    ps.setDouble(i++, p.getHoursInLabor());
    ps.setDouble(i++, p.getWeightGain());
    ps.setString(i++, p.getDeliveryType());
    ps.setInt(i, p.getPregnancyNumber());
    return ps;
  }
}
