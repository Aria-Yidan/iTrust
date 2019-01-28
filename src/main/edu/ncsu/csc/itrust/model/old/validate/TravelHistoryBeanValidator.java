package edu.ncsu.csc.itrust.model.old.validate;

import edu.ncsu.csc.itrust.exception.ErrorList;
import edu.ncsu.csc.itrust.exception.FormValidationException;
import edu.ncsu.csc.itrust.model.old.beans.TravelHistoryBean;

public class TravelHistoryBeanValidator extends BeanValidator<TravelHistoryBean> {

    // The default constructor.
    public TravelHistoryBeanValidator () { }

    /**
     * Validate the variables in bean meet the requirements and return the error message that indicates
     * the violating requirements.
     *
     * @param bean
     * @throws FormValidationException
     */
    @Override
    public void validate(TravelHistoryBean bean) throws FormValidationException {
        ErrorList errorList = new ErrorList();
        errorList.addIfNotNull(checkFormat("patientMID", bean.getPatientMID(), ValidationFormat.MID, false));
        errorList.addIfNotNull(checkFormat("travelledCities", bean.getTravelledCities(), ValidationFormat.Travelled_Cities, false));
        if (bean.getStartDate() != null) {
            errorList.addIfNotNull(checkFormat("startDate", bean.getStartDate().toString(), ValidationFormat.START_END_DATE, true));
        }
        if (bean.getEndDate() != null) {
            errorList.addIfNotNull(checkFormat("endDate", bean.getEndDate().toString(), ValidationFormat.START_END_DATE, true));
        }
        if (errorList.hasErrors()) {
            throw new FormValidationException(errorList);
        }
    }
}
