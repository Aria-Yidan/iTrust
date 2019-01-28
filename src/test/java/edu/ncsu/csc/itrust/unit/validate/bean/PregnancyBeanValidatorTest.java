package edu.ncsu.csc.itrust.unit.validate.bean;

import edu.ncsu.csc.itrust.exception.FormValidationException;
import edu.ncsu.csc.itrust.model.old.beans.PregnancyBean;
import edu.ncsu.csc.itrust.model.old.validate.PregnancyBeanValidator;
import junit.framework.TestCase;

public class PregnancyBeanValidatorTest extends TestCase {
  private PregnancyBeanValidator validator = new PregnancyBeanValidator();

  public void testInvalidMID() {
    PregnancyBean bean = new PregnancyBean();
    bean.setMID(-1);
    bean.setYearOfConception(2018);
    bean.setWeeksOfPregnant("42-0");
    bean.setDeliveryType("vaginal delivery");
    bean.setWeightGain(5.6);
    try {
      validator.validate(bean);
      fail("Validator should have thrown FormValidationException");
    } catch (FormValidationException e) {
      assertEquals("MID: Between 1 and 10 digits", e.getErrorList().get(0));
    }
  }

  public void testInvalidYearOfConception() {
    PregnancyBean bean = new PregnancyBean();
    bean.setMID(1);
    bean.setYearOfConception(18);
    bean.setWeeksOfPregnant("42-0");
    bean.setDeliveryType("vaginal delivery");
    bean.setWeightGain(5.6);
    try {
      validator.validate(bean);
      fail("Validator should have thrown FormValidationException");
    } catch (FormValidationException e) {
      assertEquals("Year of conception: Must be 4 digits", e.getErrorList().get(0));
    }
  }

  public void testInvalidWeeksOfPregnant() {
    PregnancyBean bean = new PregnancyBean();
    bean.setMID(1);
    bean.setYearOfConception(2018);
    bean.setWeeksOfPregnant("50-0");
    bean.setDeliveryType("vaginal delivery");
    bean.setWeightGain(5.6);
    try {
      validator.validate(bean);
      fail("Validator should have thrown FormValidationException");
    } catch (FormValidationException e) {
      assertEquals("Number of weeks pregnant: Weeks must be between 0 and 42," +
          " Days must be between 0 and 6", e.getErrorList().get(0));
    }
  }

  public void testInvalidDeliveryType() {
    PregnancyBean bean = new PregnancyBean();
    bean.setMID(1);
    bean.setYearOfConception(2018);
    bean.setWeeksOfPregnant("40-0");
    bean.setDeliveryType("delivery");
    bean.setWeightGain(5.6);
    try {
      validator.validate(bean);
      fail("Validator should have thrown FormValidationException");
    } catch (FormValidationException e) {
      assertEquals("Delivery Type: must be one of {vaginal delivery, vaginal delivery " +
          "vacuum assist, vaginal delivery forceps assist, caesarean section, miscarriage}",
          e.getErrorList().get(0));
    }
  }

  public void testInvalidHoursInLabor() {
    PregnancyBean bean = new PregnancyBean();
    bean.setMID(1);
    bean.setYearOfConception(2018);
    bean.setWeeksOfPregnant("42-0");
    bean.setDeliveryType("vaginal delivery");
    bean.setHoursInLabor(-1);
    try {
      validator.validate(bean);
      fail("Validator should have thrown FormValidationException");
    } catch (FormValidationException e) {
      assertEquals("Number of hours in labor: Hours in labor must between 0.0 and 999.99",
          e.getErrorList().get(0));
    }
  }

  public void testInvalidPregnancyNumber() {
    PregnancyBean bean = new PregnancyBean();
    bean.setMID(1);
    bean.setYearOfConception(2018);
    bean.setWeeksOfPregnant("42-0");
    bean.setDeliveryType("vaginal delivery");
    bean.setHoursInLabor(3);
    bean.setPregnancyNumber(0);
    try {
      validator.validate(bean);
      fail("Validator should have thrown FormValidationException");
    } catch (FormValidationException e) {
      assertEquals("Pregnancy Number: Pregnancy Number has to be larger than 1 and no more than 6. Humans should not be able to conceive more than 6 babies!",
          e.getErrorList().get(0));
    }
  }

  public void testValidBean() {
    PregnancyBean bean = new PregnancyBean();
    bean.setMID(1);
    bean.setYearOfConception(2018);
    bean.setWeeksOfPregnant("42-0");
    bean.setDeliveryType("vaginal delivery");
    bean.setHoursInLabor(5);
    bean.setPregnancyNumber(1);

    try {
      validator.validate(bean);
    } catch (FormValidationException e) {
      fail("Validator should not throw FormValidationException");
    }
  }
}
