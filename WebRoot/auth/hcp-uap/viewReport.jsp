<%@taglib uri="/WEB-INF/tags.tld" prefix="itrust" %>
<%@page errorPage="/auth/exceptionHandler.jsp" %>

<%@page import="java.util.List"%>
<%@page import="org.junit.Assert.*"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.ReportRequestBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.PersonnelDAO"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.DAOFactory"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.OfficeVisitRecordDAO"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.PreExistingConditionRecordDAO"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.ReportRequestDAO"%>
<%@page import="edu.ncsu.csc.itrust.action.ViewMyReportRequestsAction"%>
<%@page import="edu.ncsu.csc.itrust.action.ViewMyRecordsAction"%>
<%@page import="edu.ncsu.csc.itrust.action.ViewReportAction"%>
<%@page import="edu.ncsu.csc.itrust.action.ObstetricHistoryAction"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.PatientBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.PersonnelBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.AllergyBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.FamilyMemberBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.MedicationBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.PregnancyBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.OfficeVisitRecordBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.ObstetricsInitRecordBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.PreExistingConditionRecordBean"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.text.DecimalFormat" %>
<%@page import="edu.ncsu.csc.itrust.Localization" %>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.Ethnicity"%>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.BloodType"%>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.Gender"%>

<%@include file="/global.jsp" %>

<%
pageTitle = "iTrust - Comprehensive Patient Report";
%>

<%@include file="/header.jsp" %>

<%
//long loggedInMID = request.getUserPrincipal()==null ? 0L : Long.valueOf(request.getUserPrincipal().getName());

PersonnelDAO personnelDAO = new PersonnelDAO(prodDAO);
ViewMyReportRequestsAction rAction = new ViewMyReportRequestsAction(prodDAO, loggedInMID.longValue());
int patientIndex = Integer.parseInt(request.getParameter("patient"));
List<PatientBean> patients = (List<PatientBean>) session.getAttribute("patients");
//session.removeAttribute("patients");
String pidString = "" + patients.get(patientIndex).getMID();
String rrString = request.getParameter("requestID");
long patientMID;
int requestID;
ReportRequestBean reportRequest;
try {
	if (pidString == null || pidString.equals("")) throw new Exception("Error: patientMID is null");
	if (rrString == null || rrString.equals("")) throw new Exception("Error: requestID is null");
	patientMID = Long.parseLong(pidString);
	requestID = Integer.parseInt(rrString);
	reportRequest = rAction.getReportRequest(requestID);
	rAction.setViewed(requestID);
	reportRequest = rAction.getReportRequest(requestID);

    // TransactionType type, long loggedInMID, long secondaryMID, String viewedInfo
    loggingAction.logEvent(TransactionType.VIEW_LABOR_AND_DELIVERY_REPORT, loggedInMID, patientMID, "viewed patient's labor and delivery report, Patient Viewable=YES");
    System.out.println("Logged In:" + loggedInMID + " viewed patient's labor and delivery report!");

ViewMyRecordsAction action = new ViewMyRecordsAction(prodDAO, patientMID);
ViewReportAction viewAction = new ViewReportAction(prodDAO, loggedInMID.longValue(), patientMID);
PatientBean patient = action.getPatient();
List<AllergyBean> allergies = action.getAllergies();
List<PatientBean> represented = action.getRepresented();
List<PatientBean> representing = action.getRepresenting();
List<FamilyMemberBean> family = action.getFamily();
List<PersonnelBean> hcps = viewAction.getDeclaredHCPs(patientMID);

OfficeVisitRecordDAO officeDAO = new OfficeVisitRecordDAO(DAOFactory.getProductionInstance());
ObstetricHistoryAction obstetricHistoryAction = new ObstetricHistoryAction(DAOFactory.getProductionInstance());
List<ObstetricsInitRecordBean> obstetricsInitRecordBean = obstetricHistoryAction.getPatientObstericsInitRecords(patientMID);
List<PregnancyBean> pregnancyBean = obstetricHistoryAction.getAllPregnancy(patientMID);
List<OfficeVisitRecordBean> officeBean = officeDAO.getPatientOfficeVisitRecord(patientMID);
OfficeVisitRecordBean mostRecent = null;
if (officeBean.size() > 0) {
    officeBean.get(officeBean.size() -1);
}

PreExistingConditionRecordDAO preCondRecordDAO = new PreExistingConditionRecordDAO(DAOFactory.getProductionInstance());
List<PreExistingConditionRecordBean> allPreCondRecords = preCondRecordDAO.getPreExistingConditionRecordsByMID(patientMID);
ObstetricsInitRecordBean mostRecentPreg = null;
if (patient.getObstetricEligible().equals("0")) {
    out.println("Selected patient does not have an obstetrics record");
    return;
}

if (obstetricsInitRecordBean.size() > 0) {
    mostRecentPreg = obstetricsInitRecordBean.get(obstetricsInitRecordBean.size() - 1);
}
%>
<h3>Comprehensive Patient Report for <%= StringEscapeUtils.escapeHtml("" + (patient.getFullName())) %></h3>
<link rel="stylesheet" href="/iTrust/css/collapsible.css">
<div align=center>
<table>
	<tr><td valign=top>
	<table class="fTable">
		<tr>
			<th colspan="2">Patient Information</th>
		</tr>
		<tr>
			<td class="subHeaderVertical">Name:</td>
			<td ><%= StringEscapeUtils.escapeHtml("" + (patient.getFullName())) %></td>
		</tr>
		<tr>
			<td class="subHeaderVertical">Address:</td>
			<td >
			<%= StringEscapeUtils.escapeHtml("" + (patient.getStreetAddress1())) %><br />
			<%= "".equals(patient.getStreetAddress2()) ? "" : patient.getStreetAddress2() + "<br />"%>
			<%= StringEscapeUtils.escapeHtml("" + (patient.getStreetAddress3())) %><br />
			</td>
		</tr>
		<tr>
			<td class="subHeaderVertical">Phone:</td>
			<td ><%= StringEscapeUtils.escapeHtml("" + (patient.getPhone())) %></td>
		</tr>
		<tr>
			<td class="subHeaderVertical">Email:</td>
			<td ><%= StringEscapeUtils.escapeHtml("" + (patient.getEmail())) %></td>
		</tr>
	</table>
	</td>
	<td width="15px">&nbsp;</td>
	<td>
	<table class="fTable">
		<tr>
			<th colspan="2">Insurance Information</th>
		</tr>
		<tr>
			<td class="subHeaderVertical">Name (ID):</td>
			<td ><%= StringEscapeUtils.escapeHtml("" + (patient.getIcName())) %> (<%= StringEscapeUtils.escapeHtml("" + (patient.getIcID())) %>)</td>
		</tr>
		<tr>
			<td class="subHeaderVertical">Address:</td>
			<td >
			<%= StringEscapeUtils.escapeHtml("" + (patient.getIcAddress1())) %><br />
			<%="".equals(patient.getIcAddress2()) ? "" : patient.getIcAddress2() + "<br />"%>
			<%= StringEscapeUtils.escapeHtml("" + (patient.getIcAddress3())) %><br />
			</td>
		</tr>
		<tr>
			<td class="subHeaderVertical">Phone:</td>
			<td ><%= StringEscapeUtils.escapeHtml("" + (patient.getIcPhone())) %></td>
		</tr>
	</table>
    </td>
        <td width="15px">&nbsp;</td>
        <td>
    <table class="fTable" align=center style="width: 350px;">
        <tr>
            <th colspan=2>Patient's Health Information</th>
        </tr>
        <tr>
            <td class="subHeaderVertical">Ethnicity:</td>
            <td><%= StringEscapeUtils.escapeHtml("" + (patient.getEthnicity())) %></td>
        </tr>
        <tr>
            <td class="subHeaderVertical">Blood Type:</td>
            <td><%= StringEscapeUtils.escapeHtml("" + (patient.getBloodType())) %>
        </tr>
        <tr>
            <td class="subHeaderVertical">Gender:</td>
            <td><%= StringEscapeUtils.escapeHtml("" + (patient.getGender())) %></td>
        </tr>
        <tr>
            <td class="subHeaderVertical">Date Of Birth:</td>
            <td><%= StringEscapeUtils.escapeHtml("" + (patient.getDateOfBirthStr())) %></td>
        </tr>
        <tr>
            <td class="subHeaderVertical">Date Of Death:</td>
            <td><%= StringEscapeUtils.escapeHtml("" + (patient.getDateOfDeathStr())) %>></td>
        </tr>
        <tr>
            <td class="subHeaderVertical">Topical Notes:</td>
            <td><%= StringEscapeUtils.escapeHtml("" + (patient.getTopicalNotes())) %>
            </td>
        </tr>
    </table>
        </td>
    </tr>
</table>
<br />
<table class="fTable">
		<tr>
			<th colspan="2">Designated HCPs</th>
		</tr>
			<tr class="subHeader">
				<td>HCP Name</td>
			</tr>

			<%if(hcps.size()==0){ %>
			<tr>
				<td colspan="2" style="text-align: center;">No designated HCPs on record</td>
			</tr>
			<%} else {
				for(PersonnelBean hcp : hcps){%>
			<tr>
				<td style="text-align: center;"><%= StringEscapeUtils.escapeHtml("" + (hcp.getFullName())) %></td>
			</tr>
			<%  }
			  }

   %>
</table>
    <br /><br>
    <table class="fTable">
        <tr>
            <th colspan="1">Estimated Delivery Date</th>
        </tr>
        <%if (patient.getObstetricEligible().equals("1")) {%>
        <tr>
            <td><%=mostRecentPreg == null ? "Unknown" : mostRecentPreg.getEDD()%></td>
        </tr>

        <%} else { %>
        <tr><td>Patient is not pregnant</td></tr>
        <%}%>
    </table>


    <br>
    <br /><br>
    <table class="fTable">
        <tr>
            <th colspan="2">Pregnancy Complication & Warning Flags</th>
        </tr>
        <%if (mostRecent != null) {%>
        <tr>
            <td class="subHeaderVertical">High Blood Pressure:</td>
            <td ><%=mostRecent.getHighBloodPressure() >= 140.0 || mostRecent.getLowBloodPressure() >= 90.0%></td>
        </tr>
        <tr>
            <td class="subHeaderVertical">Advanced Maternal Age:</td>
            <td >
                <%= patient.getAge() >= 35 %><br />
            </td>
        </tr>
        <tr>
            <td class="subHeaderVertical">Low-lying Placenta:</td>
            <td ><%= mostRecent.getLowLyingPlacenta() %></td>
        </tr>
        <tr>
            <td class="subHeaderVertical">Abnormal Fetal Heart Rate:</td>
            <td ><%= mostRecent.getFetalHeartRate() < 120 || mostRecent.getFetalHeartRate() > 160%></td>
        </tr>
        <tr>
            <td class="subHeaderVertical">Multiple Pregnancy:</td>
            <td ><%= mostRecent.getNumberOfPregnancy() > 1 %></td>
        </tr>
        <tr>
            <td class="subHeaderVertical">Aytpical Weight Change:</td>
            <td ><%= mostRecent.getWeightGain() < 14 || mostRecent.getWeightGain() > 35 %></td>
        </tr>
        <%} else { %>
        <tr><td>No Office Visit Record on File</td></tr>
        <%}%>
    </table>


    <br>
    <table class="fTable">
        <tr>
            <th colspan="2">Office Visit Information</th>
        </tr>
        <tr class="subHeader">
            <td class="subHeaderVertical">Number Of Office Visits:</td>

            <td ><%= StringEscapeUtils.escapeHtml("" + (officeBean.size())) %></td>
        </tr>


        <%
            for (int i = 0; i < officeBean.size(); i++) {
                OfficeVisitRecordBean ob = officeBean.get(i);
        %>
        <tr><td>
            <button class="collapsible">Office Visit at <%=ob.getCurrentDate()%></button>
            <div class="content">
                <p><table>
                <td>
                    Weeks pregnant:
                </td>
                <td>
                    <%= StringEscapeUtils.escapeHtml("" + ob.getWeeksOfPregnant()) %>
                </td>
                <tr>
                    <td>
                        Change in weights:
                    </td>
                    <td>
                        <%= StringEscapeUtils.escapeHtml("" + ob.getWeightGain()) %>
                    </td>
                </tr>
                <tr>
                    <td>
                        Multiple Pregnancy:
                    </td>
                    <td>
                        <%= StringEscapeUtils.escapeHtml("" + ob.getNumberOfPregnancy()) %>
                    </td>
                </tr>
                <tr>
                    <td>
                        Fetal Heart Rate:
                    </td>
                    <td>
                        <%= StringEscapeUtils.escapeHtml("" + ob.getFetalHeartRate()) %>
                    </td>
                </tr>
                <tr>
                    <td>
                        Blood Pressure:
                    </td>
                    <td>
                        <%= StringEscapeUtils.escapeHtml("" + ob.getHighBloodPressure()) %>
                        <%= StringEscapeUtils.escapeHtml("/" + ob.getLowBloodPressure()) %>
                    </td>
                </tr>
            </table></p>
            </div>
        </td>
        </tr>
        <%
            }%>

    </table>
    <br />
    <table class="fTable">
        <tr>
            <th colspan="2">Past Pregnancy Information</th>
        </tr>
        <tr class="subHeader">
            <td class="subHeaderVertical">Number Of Past Pregnancy:</td>

            <td ><%= StringEscapeUtils.escapeHtml("" + (pregnancyBean.size())) %></td>
        </tr>


        <%
            for (int i = 0; i < pregnancyBean.size(); i++) {
            PregnancyBean pb = pregnancyBean.get(i);
            %>
            <tr><td>
            <button class="collapsible">Pregnancy #<%=i + 1%></button>
            <div class="content">
                <p><table>
                <td>
                    Year of Conception:
                    </td>
                <td>
                    <%=pb.getYearOfConception()%>
                    </td>
                <tr>
                    <td>
                        Weeks of Pregnant:
                    </td>
                    <td>
                        <%=pb.getWeeksOfPregnant()%>
                    </td>
                </tr>
                <tr>
                    <td>
                        Hours in Labor:
                    </td>
                    <td>
                        <%=pb.getHoursInLabor()%>
                    </td>
                </tr>
                <tr>
                    <td>
                        Weight Gain:
                    </td>
                    <td>
                        <%=pb.getWeightGain()%>
                    </td>
                </tr>
                <tr>
                    <td>
                        Delivery Type:
                    </td>
                    <td>
                        <%=pb.getDeliveryType()%>
                    </td>
                </tr>
            </table></p>
            </div>
        </td>
        </tr>
        <%
        }%>

    </table>
    <br />
    <script>
        var coll = document.getElementsByClassName("collapsible");
        var i;

        for (i = 0; i < coll.length; i++) {
            coll[i].addEventListener("click", function() {
                this.classList.toggle("active");
                var content = this.nextElementSibling;
                if (content.style.display === "block") {
                    content.style.display = "none";
                } else {
                    content.style.display = "block";
                }
            });
        }
    </script>

    <table class="fTable">
        <tr>
            <th colspan="3">Pre-existing Conditions</th>
        </tr>
        <tr class="subHeader">
            <td>ICD Code</td>
            <td>Description</td>
            <td>Chronic</td>
        </tr>

        <%if(allPreCondRecords.size()==0){ %>
        <tr>
            <td colspan="2" style="text-align: center;">No Pre-existing Conditions on Record</td>
        </tr>
        <%} else {
            String ICDcode = "";
            String description = "";
            String chronic = "";
            for(PreExistingConditionRecordBean preCondRec : allPreCondRecords){
                String ICDinfo = preCondRec.getIcdInfo();
                String[] allICDs = ICDinfo.split(" & ");
                for (String oneICD : allICDs) {
                    String[] ICDinfos = oneICD.split(",");
                    StringBuilder sb = new StringBuilder();
                    for (int i = 1; i < ICDinfos.length - 1; i++) {
                        sb.append(ICDinfos[i]);
                        if (i != ICDinfos.length - 2) sb.append(", ");
                    }
                    ICDcode = ICDinfos[0];
                    description = sb.toString();
                    chronic = (ICDinfos[ICDinfos.length - 1].equals("0")) ? "Yes" : "No";
                    %>
                        <tr>
                            <td style="text-align: center;"><%= StringEscapeUtils.escapeHtml("" + ICDcode) %></td>
                            <td style="text-align: center;"><%= StringEscapeUtils.escapeHtml("" + description) %></td>
                            <td style="text-align: center;"><%= StringEscapeUtils.escapeHtml("" + chronic) %></td>
                        </tr>
                    <%
                }
        %>
        <%  }
        } %>
    </table>
<br><br>
<table class="fTable">
		<tr>
			<th colspan="2">Allergies</th>
		</tr>
			<tr class="subHeader">
				<td>Allergy Description</td>
				<td>First Found</td>
			</tr>

			<%if(allergies.size()==0){ %>
			<tr>
				<td colspan="2" style="text-align: center;">No Allergies on record</td>
			</tr>
			<%} else {
				for(AllergyBean allergy : allergies){%>
			<tr>
				<td style="text-align: center;"><%= StringEscapeUtils.escapeHtml("" + (allergy.getDescription())) %></td>
				<td style="text-align: center;"><%= StringEscapeUtils.escapeHtml("" + (allergy.getFirstFoundStr())) %></td>
			</tr>
			<%  }
			  } %>
</table>
<br />
<br />
<br />
<br />
<table class="fTable">
		<tr>
			<th colspan="2">Known Relatives</th>
		</tr>
			<tr class="subHeader">
				<th>Name</th>
				<th>Relation</th>
			</tr>
			<%
			  if(family.size()==0){%>
				<tr>
					<td colspan="3" style="text-align: center;">No Relations on	record</td>
				</tr>
			  <%} else {
				  for(FamilyMemberBean member : family) {%>
			  	<tr>
					<td><%= StringEscapeUtils.escapeHtml("" + (member.getFullName())) %></td>
					<td><%= StringEscapeUtils.escapeHtml("" + (member.getRelation())) %></td>
				</tr>
			  <%  }
				}%>
</table>
<br />
<table class="fTable">
		<tr>
			<th>Patients <%= StringEscapeUtils.escapeHtml("" + (patient.getFirstName())) %> is representing</th>
		</tr>
			<tr class="subHeader">
				<th>Patient</th>
			</tr>
			<%if(represented.size() ==0){ %>
			<tr>
				<td><%= StringEscapeUtils.escapeHtml("" + (patient.getFirstName())) %> is not representing any patients</td>
			</tr>
			<%} else {
				for(PatientBean p : represented){%>
				<tr>
					<td align=center>
						<%= StringEscapeUtils.escapeHtml("" + (p.getFullName())) %>
					</td>
				</tr>
			 <% }
			  }%>
</table>
<br />
<table class="fTable">
		<tr>
			<th >Patients Representing <%= StringEscapeUtils.escapeHtml("" + (patient.getFirstName())) %></th>
		</tr>
			<tr class="subHeader">
				<th>Patient</th>
			</tr>
			<%if(representing.size() ==0){ %>
			<tr>
				<td><%= StringEscapeUtils.escapeHtml("" + (patient.getFirstName())) %> is not represented by any patients</td>
			</tr>
			<%} else {
				for(PatientBean p : representing){%>
				<tr>
					<td align=center>
						<%= StringEscapeUtils.escapeHtml("" + (p.getFullName())) %>
					</td>
				</tr>
			 <% }
			  }%>
</table>
<br />
<br />

<%} catch (Exception ex) {
    out.println("EXCEPTION");
	%><%=ex.getClass()+", " %><%=ex.getCause()+", " %><%=StringEscapeUtils.escapeHtml(ex.getMessage()) %><%
}
%>

<%@include file="/footer.jsp" %>
