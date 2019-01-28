package edu.ncsu.csc.itrust.model.old.dao.mysql;

import edu.ncsu.csc.itrust.exception.DBException;
import edu.ncsu.csc.itrust.exception.ITrustException;
import edu.ncsu.csc.itrust.model.old.beans.TravelHistoryBean;
import edu.ncsu.csc.itrust.model.old.beans.loaders.TravelHistoryBeanLoader;
import edu.ncsu.csc.itrust.model.old.dao.DAOFactory;

import java.sql.*;
import java.util.List;

/**
 * Used for managing TravelHistory
 * Table Name: TravelHistories
 *
 * DAO stands for Database Access Object. All DAOs are intended to be
 * reflections of the database, that is, one DAO per table in the database (most
 * of the time). For more complex sets of queries, extra DAOs are added. DAOs
 * can assume that all data has been validated and is correct.
 */

public class TravelHistoryDAO {
    private DAOFactory factory;
    private TravelHistoryBeanLoader travelHistoryLoader;

    /**
     * Constructor for TravelHistoryDAO
     *
     * @param factory
     */
    public TravelHistoryDAO(DAOFactory factory) {
        this.factory = factory;
        this.travelHistoryLoader = new TravelHistoryBeanLoader();
    }

    /**
     * Returns a list of all TravelHistories under a patient's MID
     *
     * @param patientMID
     *            The ID of the hospital to get TravelHistories from
     * @return A java.util.List of TravelHistoryBeans.
     * @throws DBException
     */
    public List<TravelHistoryBean> getTravelHistoriesByMID(long patientMID) throws DBException {
        try (Connection conn = factory.getConnection();
             PreparedStatement ps = conn
                     .prepareStatement("SELECT * FROM TravelHistories WHERE patientMID = ? ORDER BY startDate")) {
            ps.setLong(1, patientMID);
            ResultSet rs = ps.executeQuery();
            List<TravelHistoryBean> TravelHistories = travelHistoryLoader.loadList(rs);
            rs.close();
            return TravelHistories;
        } catch (SQLException e) {
            throw new DBException(e);
        }
    }

    /**
     * Adds a TravelHistory
     *
     * @param travelHistory The TravelHistoryBean object to insert.
     * @return A boolean indicating whether the insertion was successful.
     * @throws DBException
     * @throws ITrustException
     */
    public boolean addTravelHistory(TravelHistoryBean travelHistory) throws DBException, ITrustException {
        try (Connection conn = factory.getConnection();
             PreparedStatement ps = travelHistoryLoader
                     .loadParameters(conn.prepareStatement("INSERT INTO TravelHistories (patientMID, startDate, endDate, travelledCities) "
                             + "VALUES (?,?,?,?)"), travelHistory)) {
            boolean added = ps.executeUpdate() == 1;
            return added;
        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) {
                throw new ITrustException("Error: TravelHistory already exists.");
            } else {
                throw new DBException(e);
            }
        }
    }
}
