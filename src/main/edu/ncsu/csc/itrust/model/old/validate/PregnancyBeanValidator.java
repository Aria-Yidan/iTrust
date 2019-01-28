package edu.ncsu.csc.itrust.model.old.validate;

import edu.ncsu.csc.itrust.exception.ErrorList;
import edu.ncsu.csc.itrust.exception.FormValidationException;
import edu.ncsu.csc.itrust.model.old.beans.PregnancyBean;

/**
 * Validates a pregnancy bean
 */
public class PregnancyBeanValidator extends BeanValidator<PregnancyBean> {

  /**
   * The default constructor.
   */
  public PregnancyBeanValidator() {
  }

  /**
   * Validate the variables in bean meet the requirement and return the error message that indicates
   * the violating requirements.
   * @param bean
   * @throws FormValidationException
   */
  @Override
  public void validate(PregnancyBean bean) throws FormValidationException {
    ErrorList errorList = new ErrorList();
    errorList.addIfNotNull(checkFormat("MID", bean.getMID(), ValidationFormat.MID, false));
    errorList.addIfNotNull(checkFormat("Year of conception", bean.getYearOfConception(), ValidationFormat.YEAR, false));
    errorList.addIfNotNull(checkFormat("Number of weeks pregnant", bean.getWeeksOfPregnant(), ValidationFormat.WEEKS_PREGNANT, false));
    errorList.addIfNotNull(checkFormat("Number of hours in labor", bean.getHoursInLabor(), ValidationFormat.HOURS_LABOR, true));
    errorList.addIfNotNull(checkFormat("Delivery Type", bean.getDeliveryType(), ValidationFormat.DELIVERYTYPE, false));
    errorList.addIfNotNull(checkFormat("Pregnancy Number", bean.getPregnancyNumber(), ValidationFormat.PREGNANCY_NUMBER, false));
    if (errorList.hasErrors())
      throw new FormValidationException(errorList);
  }
}
