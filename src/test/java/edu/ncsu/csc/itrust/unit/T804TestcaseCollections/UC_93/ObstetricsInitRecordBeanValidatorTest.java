package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_93;

import edu.ncsu.csc.itrust.exception.FormValidationException;
import edu.ncsu.csc.itrust.model.old.beans.ObstetricsInitRecordBean;
import edu.ncsu.csc.itrust.model.old.validate.ObstetricsInitRecordBeanValidator;
import junit.framework.TestCase;

public class ObstetricsInitRecordBeanValidatorTest extends TestCase {
  private ObstetricsInitRecordBeanValidator validator = new ObstetricsInitRecordBeanValidator();

  public void testInvalidMID() {
    ObstetricsInitRecordBean bean = new ObstetricsInitRecordBean();
    bean.setMID(-1);
    bean.setLMP("01/01/2018");
    bean.setEDD("10/08/2018");
    bean.setWeeksOfPregnant("1-2");
    try {
      validator.validate(bean);
      fail("Validator should have thrown FormValidationException");
    } catch (FormValidationException e) {
      assertEquals("MID: Between 1 and 10 digits", e.getErrorList().get(0));
    }
  }

  public void testInvalidLMP() {
    ObstetricsInitRecordBean bean = new ObstetricsInitRecordBean();
    bean.setMID(1);
    bean.setLMP("01/01/18");
    bean.setEDD("10/08/2018");
    bean.setWeeksOfPregnant("1-2");
    try {
      validator.validate(bean);
      fail("Validator should have thrown FormValidationException");
    } catch (FormValidationException e) {
      assertEquals("Last menstrual period: MM/DD/YYYY", e.getErrorList().get(0));
    }
  }

  public void testInvalidEDD() {
    ObstetricsInitRecordBean bean = new ObstetricsInitRecordBean();
    bean.setMID(1);
    bean.setLMP("01/01/2018");
    bean.setEDD("10/08/08");
    bean.setWeeksOfPregnant("1-2");
    try {
      validator.validate(bean);
      fail("Validator should have thrown FormValidationException");
    } catch (FormValidationException e) {
      assertEquals("Estimated due date: MM/DD/YYYY", e.getErrorList().get(0));
    }
  }

  public void testInvalidWeeksOfPregnant() {
    ObstetricsInitRecordBean bean = new ObstetricsInitRecordBean();
    bean.setMID(1);
    bean.setLMP("01/01/2018");
    bean.setEDD("10/08/2008");
    bean.setWeeksOfPregnant("1-9");
    try {
      validator.validate(bean);
      fail("Validator should have thrown FormValidationException");
    } catch (FormValidationException e) {
      assertEquals("Number of weeks pregnant: Weeks must be between 0 and 42," +
          " Days must be between 0 and 6", e.getErrorList().get(0));
    }
  }

  public void testValidBean() {
    ObstetricsInitRecordBean bean = new ObstetricsInitRecordBean();
    bean.setMID(1);
    bean.setLMP("01/01/2018");
    bean.setEDD("10/08/2008");
    bean.setWeeksOfPregnant("1-1");
    try {
      validator.validate(bean);
    } catch (FormValidationException e) {
      fail("Validator should not throw FormValidationException");
    }
  }
}
