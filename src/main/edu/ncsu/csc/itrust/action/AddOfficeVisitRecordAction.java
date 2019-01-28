package edu.ncsu.csc.itrust.action;

import java.sql.SQLException;

import edu.ncsu.csc.itrust.exception.DBException;
import edu.ncsu.csc.itrust.exception.FormValidationException;
import edu.ncsu.csc.itrust.logger.TransactionLogger;
import edu.ncsu.csc.itrust.model.old.beans.OfficeVisitRecordBean;
import edu.ncsu.csc.itrust.model.old.dao.DAOFactory;
import edu.ncsu.csc.itrust.model.old.dao.mysql.AuthDAO;
import edu.ncsu.csc.itrust.model.old.enums.TransactionType;
import edu.ncsu.csc.itrust.action.EventLoggingAction;

public class AddOfficeVisitRecordAction extends OfficeVisitRecordAction {
    private long loggedInMID;

    /**
     * constructor
     * @param factory
     * @param loggedInMID
     */
    public AddOfficeVisitRecordAction(DAOFactory factory, long loggedInMID) {
        super(factory, loggedInMID);
        this.loggedInMID = loggedInMID;
    }

    /**
     * execute addOfficeVisitRecord, calls addOfficevisitrecord in DAO
     * @param ov
     * @param ignoreConflicts
     * @return
     * @throws FormValidationException
     * @throws SQLException
     * @throws DBException
     */
    public String addOfficeVisitRecord(OfficeVisitRecordBean ov, boolean ignoreConflicts) throws FormValidationException, SQLException, DBException {
        try {
            officeVisitRecordDAO.addOfficeVisitRecord(ov);
            return "Success: Office Visit Record for " + ov.getCurrentDate() + " added";
        } catch (SQLException e) {
            return e.getMessage();
        }
    }
}
