package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_99;

import edu.ncsu.csc.itrust.exception.FormValidationException;
import edu.ncsu.csc.itrust.model.old.beans.TravelHistoryBean;
import edu.ncsu.csc.itrust.model.old.validate.TravelHistoryBeanValidator;
import junit.framework.TestCase;

public class TravelHistoryValidatorTest extends TestCase {
    private TravelHistoryBeanValidator validator = new TravelHistoryBeanValidator();

    public void testInvalidTravelHistory() {
        TravelHistoryBean bean = new TravelHistoryBean();
        bean.setPatientMID(-1L);
        bean.setStartDate(null);
        bean.setEndDate(null);
        bean.setTravelledCities("Paris,France");
        try {
            validator.validate(bean);
            fail("Validator should throw the FormValidationException");
        } catch (FormValidationException e) {
            assertEquals("patientMID: Between 1 and 10 digits", e.getErrorList().get(0));
        }
    }

    public void testInvalidTravelledCities() {
        TravelHistoryBean bean = new TravelHistoryBean();
        bean.setPatientMID(1L);
        bean.setStartDate(null);
        bean.setEndDate(null);
        bean.setTravelledCities("Lorem ipsum dolor sit amet, cu congue scriptorem concludaturque nam, an saepe " +
                "scripta comprehensam his, sed populo bonorum perfecto cu. In nisl malis dicam nam, ut dicant " +
                "tibique mel, cu nisl diceret hendrerit vix. In vel homero putant quaerendum, sed no simul quaeque. " +
                "Ne doming oblique est, an tritani lobortis mei. At oblique evertitur vix, an ancillae gubergren " +
                "intellegat nam. Suas scripta appetere at eos, volumus delicata cotidieque et has, mei ullum malorum" +
                " lobortis ut.volumus delicata cotidieque et has, mei ullum malorum lobortis ut.");
        try {
            validator.validate(bean);
            fail("Validator should throw the FormValidationException");
        } catch (FormValidationException e) {
            assertEquals("travelledCities: Up to 512 characters are valid travelledCities", e.getErrorList().get(0));
        }
    }

    public void testValidTravelHistory() {
        TravelHistoryBean bean = new TravelHistoryBean();
        bean.setPatientMID(11L);
        bean.setStartDate(new java.sql.Date(System.currentTimeMillis()));
        bean.setEndDate(new java.sql.Date(System.currentTimeMillis()));
        bean.setTravelledCities("Paris,France");
        try {
            validator.validate(bean);
        } catch (FormValidationException e) {
            fail("Validator should not throw the FormValidationException");
        }
    }
}
