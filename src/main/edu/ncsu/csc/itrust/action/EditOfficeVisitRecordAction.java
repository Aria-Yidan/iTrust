package edu.ncsu.csc.itrust.action;

import java.sql.SQLException;
import java.util.List;

import edu.ncsu.csc.itrust.exception.DBException;
import edu.ncsu.csc.itrust.exception.FormValidationException;
import edu.ncsu.csc.itrust.logger.TransactionLogger;
import edu.ncsu.csc.itrust.model.old.beans.OfficeVisitRecordBean;
import edu.ncsu.csc.itrust.model.old.dao.DAOFactory;
import edu.ncsu.csc.itrust.model.old.enums.TransactionType;
import edu.ncsu.csc.itrust.model.old.validate.OfficeVisitRecordBeanValidator;

/**
 * EditOfficeVisitRecordAction
 */
public class EditOfficeVisitRecordAction extends OfficeVisitRecordAction {

    private OfficeVisitRecordBeanValidator validator = new OfficeVisitRecordBeanValidator();
    private long loggedInMID;
    private long originalPatient;
    private long originalOfficeVisitRecordID;

    /**
     * EditApptAction
     * @param factory factory
     * @param loggedInMID loggedInMID
     */
    public EditOfficeVisitRecordAction(DAOFactory factory, long loggedInMID) {
        this(factory, loggedInMID, 0L, 0L);
    }

    public void setOriginalOfficeVisitRecordID(long id) {
        this.originalOfficeVisitRecordID = id;
    }

    public void setOriginalPatient(long patient) {
        this.originalPatient = patient;
    }

    public void logViewAction() {
        TransactionLogger.getInstance().logTransaction(TransactionType.OFFICE_VISIT_RECORDS_VIEW, loggedInMID, originalPatient, "" + originalOfficeVisitRecordID);
    }

    /**
     * EditOfficeVisitRecordAction
     * @param factory factory
     * @param loggedInMID loggedInMID
     */
    public EditOfficeVisitRecordAction(DAOFactory factory, long loggedInMID, long originalPatient, long originalOfficeVisitRecordID) {
        super(factory, loggedInMID);
        this.loggedInMID = loggedInMID;
        this.originalPatient = originalPatient;
        this.originalOfficeVisitRecordID = originalOfficeVisitRecordID;
    }

    /**
     * Retrieves an office visit record from the database, given its ID.
     * Returns null if there is no match, or multiple matches.
     *
     * @param officeVisitRecordID officeVisitRecordID
     * @return OfficeVisitRecordBean with matching ID
     * @throws DBException
     * @throws SQLException
     */
    public OfficeVisitRecordBean getOfficeVisitRecord(int officeVisitRecordID) throws DBException, SQLException {
        try {
            List<OfficeVisitRecordBean> officeVisitRecordBeans = officeVisitRecordDAO.getOfficeVisitRecord(officeVisitRecordID);
            if (officeVisitRecordBeans.size() == 1){
                return officeVisitRecordBeans.get(0);
            }
            return null;
        } catch (DBException e) {
            return null;
        }
    }

    /**
     * Updates an existing office visit record
     *
     * @param officeVisitRecord OfficeVisitRecordBean containing the updated information
     * @return Message to be displayed
     * @throws FormValidationException
     * @throws SQLException
     * @throws DBException
     */
    public String editOfficeVisitRecord(OfficeVisitRecordBean officeVisitRecord) throws FormValidationException, SQLException, DBException {
        try {
            officeVisitRecordDAO.modifyOfficeVisitRecord(officeVisitRecord);
            TransactionLogger.getInstance().logTransaction(TransactionType.OFFICE_VISIT_RECORD_EDIT,
                    loggedInMID, originalPatient,
                    ""+ officeVisitRecord.getOfficeVisitRecordID());
            return "Success: Office Visit Record changed";
        } catch (DBException e) {
            return e.getMessage();
        }
    }
}
