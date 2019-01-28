package edu.ncsu.csc.itrust.model.old.dao.mysql;

import edu.ncsu.csc.itrust.exception.DBException;
import edu.ncsu.csc.itrust.model.old.beans.PreExistingConditionRecordBean;
import edu.ncsu.csc.itrust.model.old.beans.loaders.PreExistingConditionRecordBeanLoader;
import edu.ncsu.csc.itrust.model.old.dao.DAOFactory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class PreExistingConditionRecordDAO {
    private DAOFactory factory;
    private PreExistingConditionRecordBeanLoader preConditionLoader;

    /**
     * constructor for PreExistingConditionRecordDAO
     *
     * @param factory
     */
    public PreExistingConditionRecordDAO(DAOFactory factory) {
        this.factory = factory;
        this.preConditionLoader = new PreExistingConditionRecordBeanLoader();
    }

    /*
     * Returns a list of all pre-existing condition records under a patient's MID
     *
     * @param patientMID
     *
     * @return A list of PreExistingConditionRecordBeans.
     * @throws DBException
     */
    public List<PreExistingConditionRecordBean> getPreExistingConditionRecordsByMID(long patientMID) throws DBException {
        try (Connection conn = factory.getConnection();
             PreparedStatement ps = conn
                     .prepareStatement("SELECT * FROM PreExistingConditionRecord WHERE patientMID = ?")) {
            ps.setLong(1, patientMID);
            ResultSet rs = ps.executeQuery();
            List<PreExistingConditionRecordBean> preExistingConditions = preConditionLoader.loadList(rs);
            rs.close();
            return preExistingConditions;
        } catch (SQLException e) {
            throw new DBException(e);
        }
    }
}
