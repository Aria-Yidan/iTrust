package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_95;

import edu.ncsu.csc.itrust.exception.FormValidationException;
import edu.ncsu.csc.itrust.model.old.beans.PreExistingConditionRecordBean;
import edu.ncsu.csc.itrust.model.old.validate.PreExistingConditionRecordBeanValidator;
import junit.framework.TestCase;

public class PreExistingConditionRecordValidatorTest extends TestCase {
    private PreExistingConditionRecordBeanValidator validator = new PreExistingConditionRecordBeanValidator();

    public void testInvalidPatientMID() {
        PreExistingConditionRecordBean bean = new PreExistingConditionRecordBean();
        bean.setPatientMID(-1L);
        bean.setIcdInfo("D720, Genetic anomalies of leukocytes, 0");
        try {
            validator.validate(bean);
            fail("Validator should throw the FormValidationException");
        } catch (FormValidationException e) {
            assertEquals(1, e.getErrorList().size());
            assertEquals("patientMID: Between 1 and 10 digits", e.getErrorList().get(0));
        }
    }

    public void testInvalidIcdInfo() {
        PreExistingConditionRecordBean bean = new PreExistingConditionRecordBean();
        bean.setPatientMID(11L);
        bean.setIcdInfo("Lorem ipsum dolor sit amet, cu congue scriptorem concludaturque nam, an saepe " +
                "scripta comprehensam his, sed populo bonorum perfecto cu. In nisl malis dicam nam, ut dicant " +
                "tibique mel, cu nisl diceret hendrerit vix. In vel homero putant quaerendum, sed no simul quaeque. " +
                "Ne doming oblique est, an tritani lobortis mei. At oblique evertitur vix, an ancillae gubergren " +
                "intellegat nam. Suas scripta appetere at eos, volumus delicata cotidieque et has, mei ullum malorum" +
                " lobortis ut.volumus delicata cotidieque et has, mei ullum malorum lobortis ut.");
        try {
            validator.validate(bean);
            fail("Validator should throw the FormValidationException");
        } catch (FormValidationException e) {
            assertEquals(1, e.getErrorList().size());
            assertEquals("icdInfo: Up to 512 characters are valid IcdInfo", e.getErrorList().get(0));
        }
    }

    public void testValidIcdInfo() {
        PreExistingConditionRecordBean bean = new PreExistingConditionRecordBean();
        bean.setPatientMID(12L);
        bean.setIcdInfo("024119, Pre-existing type 2 diabetes mellitus, in pregnancy, unexpected trimester, 0 " +
                "& E033, Postinfectious hypothyroidism, 0");
        try {
            validator.validate(bean);
        } catch (FormValidationException e) {
            fail("Validator should not throw the FormValidationException");
        }

        assertEquals(12, bean.getPatientMID());
        assertEquals("024119, Pre-existing type 2 diabetes mellitus, in pregnancy, unexpected trimester, 0 " +
                "& E033, Postinfectious hypothyroidism, 0", bean.getIcdInfo());
    }
}
