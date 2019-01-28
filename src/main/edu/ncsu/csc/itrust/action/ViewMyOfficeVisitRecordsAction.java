package edu.ncsu.csc.itrust.action;

import java.sql.SQLException;
import java.util.List;

import edu.ncsu.csc.itrust.exception.DBException;
import edu.ncsu.csc.itrust.logger.TransactionLogger;
import edu.ncsu.csc.itrust.model.old.beans.OfficeVisitRecordBean;
import edu.ncsu.csc.itrust.model.old.dao.DAOFactory;
import edu.ncsu.csc.itrust.model.old.enums.TransactionType;

public class ViewMyOfficeVisitRecordsAction extends OfficeVisitRecordAction {
    private long loggedInMID;

    public ViewMyOfficeVisitRecordsAction(DAOFactory factory, long loggedInMID) {
        super(factory, loggedInMID);
        this.loggedInMID = loggedInMID;
    }

    public void setLoggedInMID(long mid) {
        this.loggedInMID = mid;
    }

    public List<OfficeVisitRecordBean> getMyOfficeVisitRecords() throws SQLException, DBException {
        return officeVisitRecordDAO.getOfficeVisitRecordsFor(loggedInMID);
    }

    public List<OfficeVisitRecordBean> getAllMyOfficeVisitRecords() throws SQLException, DBException {
        //
        return officeVisitRecordDAO.getOfficeVisitRecord(loggedInMID);
    }

    /**
     * Gets a user's office visit records
     *
     * @param MID the MID of the user
     * @return a list of the user's office visit records
     * @throws SQLException
     * @throws DBException
     */
    public List<OfficeVisitRecordBean> getOfficeVisitRecords(long MID) throws SQLException, DBException {
        return officeVisitRecordDAO.getOfficeVisitRecord(MID);
    }
}
