package edu.ncsu.csc.itrust.action;

import edu.ncsu.csc.itrust.exception.ITrustException;
import edu.ncsu.csc.itrust.model.old.dao.DAOFactory;
import edu.ncsu.csc.itrust.model.old.dao.mysql.OfficeVisitRecordDAO;
import edu.ncsu.csc.itrust.model.old.dao.mysql.PatientDAO;
import edu.ncsu.csc.itrust.model.old.dao.mysql.PersonnelDAO;

/**
 * OfficeVisitRecordAction
 */
public abstract class OfficeVisitRecordAction {

    /**officeVisitRecordDAO*/
    protected OfficeVisitRecordDAO officeVisitRecordDAO;
    /**patientDAO*/
    protected PatientDAO patientDAO;
    /**personnelDAO*/
    protected PersonnelDAO personnelDAO;

    /**
     * OfficeVisitRecordAction
     * @param factory factory
     * @param loggedInMID loggedMID
     */
    public OfficeVisitRecordAction(DAOFactory factory, long loggedInMID) {
        this.officeVisitRecordDAO = factory.getOfficeVisitRecordDAO();
        this.patientDAO = factory.getPatientDAO();
        this.personnelDAO = factory.getPersonnelDAO();
    }

    /**
     * Gets a users's name from their MID
     *
     * @param mid the MID of the user
     * @return the user's name
     * @throws ITrustException
     */
    public String getName(long mid) throws ITrustException {
        if(mid < 7000000000L)
            return patientDAO.getName(mid);
        else
            return personnelDAO.getName(mid);
    }
}
