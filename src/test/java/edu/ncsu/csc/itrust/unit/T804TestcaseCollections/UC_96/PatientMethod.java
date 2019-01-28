package edu.ncsu.csc.itrust.unit.T804TestcaseCollections.UC_96;
import java.text.SimpleDateFormat;
import java.util.Date;
import junit.framework.TestCase;
import edu.ncsu.csc.itrust.DateUtil;
import edu.ncsu.csc.itrust.model.old.beans.PatientBean;
import edu.ncsu.csc.itrust.model.old.enums.BloodType;

public class PatientMethod extends TestCase {
    private Date today;

    @Override
    protected void setUp() throws Exception {
        today = new Date();
    }

    public void testAgeZero() throws Exception {
        PatientBean baby = new PatientBean();
        baby.setDateOfBirthStr(new SimpleDateFormat("MM/dd/yyyy").format(today));
        assertEquals(0, baby.getAge());
    }

    public void testBirthTime() throws Exception {
        PatientBean newBorn = new PatientBean();
        newBorn.setBirthTime("02:00 PM");
        assertEquals("02:00 PM", newBorn.getBirthTime());
    }


    public void testAge10() throws Exception {
        PatientBean kid = new PatientBean();
        kid.setDateOfBirthStr(DateUtil.yearsAgo(10));
        assertEquals(10, kid.getAge());
    }

    public void testDrugs() throws Exception {
        PatientBean p = new PatientBean();
        assertFalse(p.getPitocin());
        assertFalse(p.getNitrous_oxide());
        assertFalse(p.getEpidural_anaesthesia());
        assertFalse(p.getPethidine());
        assertFalse(p.getMagnesium_sulfate());
        assertFalse(p.getRH_immune_globulin());
        p.setPitocin(true);
        p.setNitrous_oxide(true);
        p.setEpidural_anaesthesia(true);
        p.setPethidine(true);
        p.setMagnesium_sulfate(true);
        p.setRH_immune_globulin(true);
        assertTrue(p.getPitocin());
        assertTrue(p.getNitrous_oxide());
        assertTrue(p.getEpidural_anaesthesia());
        assertTrue(p.getPethidine());
        assertTrue(p.getMagnesium_sulfate());
        assertTrue(p.getRH_immune_globulin());
    }

    public void testBirthMethod() throws Exception {
        PatientBean p = new PatientBean();
        p.setPreferMethod("vaginal delivery forceps assist");
        assertEquals("vaginal delivery forceps assist", p.getPreferMethod());
    }


    public void testBean() {
        PatientBean p = new PatientBean();
        p.setBloodType(BloodType.ABNeg);
        p.setDateOfBirthStr("bad date");
        p.setCity("Raleigh");
        p.setState("NC");
        p.setZip("27613-1234");
        p.setIcCity("Raleigh");
        p.setIcState("NC");
        p.setIcZip("27613-1234");
        p.setSecurityQuestion("Question");
        p.setSecurityAnswer("Answer");
        p.setPassword("password");
        p.setConfirmPassword("confirm");
        assertEquals(BloodType.ABNeg, p.getBloodType());
        assertNull(p.getDateOfBirth());
        assertEquals(-1, p.getAge());
        assertEquals("Raleigh, NC 27613-1234", p.getIcAddress3());
        assertEquals("Raleigh, NC 27613-1234", p.getStreetAddress3());
        assertEquals("Question", p.getSecurityQuestion());
        assertEquals("Answer", p.getSecurityAnswer());
        assertEquals("password", p.getPassword());
        assertEquals("confirm", p.getConfirmPassword());
    }

}
