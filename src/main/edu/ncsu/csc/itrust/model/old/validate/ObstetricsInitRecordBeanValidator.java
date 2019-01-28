package edu.ncsu.csc.itrust.model.old.validate;

import edu.ncsu.csc.itrust.exception.ErrorList;
import edu.ncsu.csc.itrust.exception.FormValidationException;
import edu.ncsu.csc.itrust.model.old.beans.ObstetricsInitRecordBean;

public class ObstetricsInitRecordBeanValidator extends BeanValidator<ObstetricsInitRecordBean> {

  /**
   * The default constructor.
   */
  public ObstetricsInitRecordBeanValidator() {
  }

  /**
   * Validate the variables in bean meet the requirements and return the error message that indicates
   * the violating requirements.
   * @param bean
   * @throws FormValidationException
   */
  @Override
  public void validate(ObstetricsInitRecordBean bean) throws FormValidationException {
    ErrorList errorList = new ErrorList();
    errorList.addIfNotNull(checkFormat("MID", bean.getMID(), ValidationFormat.MID, false));
    errorList.addIfNotNull(checkFormat("Last menstrual period", bean.getLMP(), ValidationFormat.DATE, false));
    errorList.addIfNotNull(checkFormat("Estimated due date", bean.getEDD(), ValidationFormat.DATE, false));
    errorList.addIfNotNull(checkFormat("Number of weeks pregnant", bean.getWeeksOfPregnant(), ValidationFormat.WEEKS_PREGNANT, false));
    if (errorList.hasErrors())
      throw new FormValidationException(errorList);
  }
}
