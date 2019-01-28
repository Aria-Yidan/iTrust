package edu.ncsu.csc.itrust.model.old.dao.mysql;

import edu.ncsu.csc.itrust.exception.DBException;
import edu.ncsu.csc.itrust.model.old.beans.PregnancyBean;
import edu.ncsu.csc.itrust.model.old.beans.loaders.PregnancyBeanLoader;
import edu.ncsu.csc.itrust.model.old.dao.DAOFactory;

import java.sql.*;
import java.util.List;

public class PregnancyDAO {
  private DAOFactory factory;
  private PregnancyBeanLoader pregnancyBeanLoader;

  /**
   * The typical constructor.
   *
   * @param factory
   *            The {@link DAOFactory} associated with this DAO, which is used
   *            for obtaining SQL connections, etc.
   */
  public PregnancyDAO(DAOFactory factory) {
    this.factory = factory;
    this.pregnancyBeanLoader = new PregnancyBeanLoader();
  }

  /**
   * Adds a pregnancy record.
   *
   * @throws DBException
   */
  public void addPregnancy(final PregnancyBean pregnancyBean) throws DBException {
    try (Connection conn = factory.getConnection();
         PreparedStatement stmt = pregnancyBeanLoader
             .loadParameters(conn.prepareStatement("INSERT INTO pregnancy(MID, yearOfConception," +
                 "weeksOfPregnant, hoursInLabor, weightGain, deliveryType, pregnancyNumber) VALUES(?,?,?,?,?,?,?)"),
                 pregnancyBean)) {
      stmt.executeUpdate();
    } catch (SQLException e) {
      throw new DBException(e);
    }
  }

  /**
   * Returns all of the pregnancy records that are associated with a MID.
   *
   * @param mid
   *            The MID of the patient.
   * @return A java.util.List of PregnancyBean.
   * @throws DBException
   */
  public List<PregnancyBean> getAllPregnancy(final long mid) throws DBException {
    try (Connection conn = factory.getConnection();
         PreparedStatement stmt = conn
             .prepareStatement("SELECT * FROM pregnancy WHERE MID=? ORDER BY yearOfConception DESC;")) {
      stmt.setLong(1, mid);
      final ResultSet results = stmt.executeQuery();
      final List<PregnancyBean> allPregnancy = pregnancyBeanLoader.loadList(results);
      results.close();
      return allPregnancy;
    } catch (SQLException e) {
      throw new DBException(e);
    }
  }
}
