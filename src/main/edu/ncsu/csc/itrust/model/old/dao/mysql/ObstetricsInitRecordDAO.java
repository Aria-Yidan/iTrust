package edu.ncsu.csc.itrust.model.old.dao.mysql;

import edu.ncsu.csc.itrust.exception.DBException;
import edu.ncsu.csc.itrust.model.old.beans.ObstetricsInitRecordBean;
import edu.ncsu.csc.itrust.model.old.beans.loaders.ObstetricsInitRecordBeanLoader;
import edu.ncsu.csc.itrust.model.old.dao.DAOFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class ObstetricsInitRecordDAO {
  private DAOFactory factory;
  private ObstetricsInitRecordBeanLoader obstetricsInitRecordBeanLoader;

  /**
   * The typical constructor.
   *
   * @param factory The {@link DAOFactory} associated with this DAO, which is used
   *                for obtaining SQL connections, etc.
   */
  public ObstetricsInitRecordDAO(DAOFactory factory) {
    this.factory = factory;
    this.obstetricsInitRecordBeanLoader = new ObstetricsInitRecordBeanLoader();
  }

  /**
   * Adds a obstetrics initialization record.
   *
   * @throws DBException
   */
  public void addObstetricsInitRecord(final ObstetricsInitRecordBean obstetricsInitRecordBean)
      throws DBException {
    try (Connection conn = factory.getConnection();
         PreparedStatement stmt = obstetricsInitRecordBeanLoader
             .loadParameters(conn.prepareStatement("INSERT INTO obstetricsInitRecord(MID, LMP," +
                 "EDD, weeksOfPregnant) VALUES(?,?,?,?)"), obstetricsInitRecordBean)) {
      stmt.executeUpdate();
    } catch (SQLException e) {
      throw new DBException(e);
    }
  }

  /**
   * Returns all of the obstetrics initialization records that are associated with a MID.
   * Ordered by recordCreatedTime in Descending order (The most recent created record at the front)
   * @param mid The MID of the patient.
   * @return A java.util.List of ObstetricsInitRecordBean.
   * @throws DBException
   */
  public List<ObstetricsInitRecordBean> getAllObstetricsInitRecord(final long mid)
      throws DBException {
    try (Connection conn = factory.getConnection();
         PreparedStatement stmt = conn
             .prepareStatement("SELECT * FROM obstetricsInitRecord WHERE MID=? ORDER BY recordCreatedTime DESC")) {
      stmt.setLong(1, mid);
      final ResultSet results = stmt.executeQuery();
      final List<ObstetricsInitRecordBean> allObstetricsInitRecord
          = obstetricsInitRecordBeanLoader.loadList(results);
      results.close();
      return allObstetricsInitRecord;
    } catch (SQLException e) {
      throw new DBException(e);
    }
  }
}
