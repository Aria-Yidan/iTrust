package edu.ncsu.csc.itrust.server;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.apache.commons.lang.StringEscapeUtils;

import edu.ncsu.csc.itrust.action.SearchUsersAction;
import edu.ncsu.csc.itrust.model.old.beans.PatientBean;
import edu.ncsu.csc.itrust.model.old.dao.DAOFactory;


/**
 * Servlet implementation class PateintSearchServlet
 */
public class PatientSearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private SearchUsersAction sua;
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PatientSearchServlet() {
        super();
        //We don't ever use the second parameter, so we don't need to give it meaning.
        sua = new SearchUsersAction(DAOFactory.getProductionInstance(), -1);
    }
    /**
     * @see HttpServlet#HttpServlet()
     */
    protected PatientSearchServlet(DAOFactory factory) {
        super();
        //We don't ever use the second parameter, so we don't need to give it meaning.
        sua = new SearchUsersAction(factory, -1);
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String query = request.getParameter("q");
		if (query == null){
			return;
		}
		boolean isAudit = request.getParameter("isAudit") != null && request.getParameter("isAudit").equals("true");
		boolean deactivated = request.getParameter("allowDeactivated") != null && request.getParameter("allowDeactivated").equals("checked");
		String forward = request.getParameter("forward");

		// String used to check if request is sent from Obstetric Patient care web page
		String obstetricSearch = request.getParameter("obstetric"); // If not from Obstetric patient page, will be null
		// String used to check if request is sent from Patient Information care web page, used to determine display of patient obstetric status
		String patientObstetricInfo = request.getParameter("patientObstetricInfo");
		// String used to Determine if set patient as obstetric or unset them from being obstetric once clicked on the patient dropdown list
		// It has two values : "TRUE" - Making patient obstetric,  "FALSE" - UnSetting obstetric patient into ordinary patient
		String setPatientObstetricStatus = request.getParameter("setPatientObstetricStatus");
		String obstetricPatientID = request.getParameter("id"); // Comes along with the event to set patient eligible for obstetric care

		String loggedInMID = request.getParameter("loggedInMID"); // HCP MID, use to identifying if current HCP user has OB or GYN speciality to set patient's obstetric care status
		boolean hcpIsOBGYN = loggedInMID != null ? sua.isOBGYNHCP(Long.parseLong(loggedInMID)) : false;



		List<PatientBean> search = null;

		// Extra use for knowing if needs to set patient to obstetric patient or not. It happens first so that
		// Ajax could immediately show the update right after it the button to update is clicked (Due to the changed
		// data would immediately be searched right after the update happens in the database)
		if (setPatientObstetricStatus != null) {

			int patientMID = Integer.parseInt(obstetricPatientID);

			if (setPatientObstetricStatus.equals("TRUE")) {
				sua.setPatientEligibleToObstetric(patientMID);
			} else {
				sua.setObstetricPatientToNormalPatient(patientMID);
			}
		}

		if(query.isEmpty() && deactivated){
			search = sua.getDeactivated();

		} else if (obstetricSearch != null && obstetricSearch.equals("YES")) { // Search for Obstetric patients ONLY!
			// Check if null first to avoid NullPointerException, then if the passed in argument is of String "YES", search for Obstetric patients only!
			search = sua.fuzzySearchForObstetricCarePatientsWithName(query, deactivated);
		}else {
			search = sua.fuzzySearchForPatients(query, deactivated);
		}

		// Notify hcp users if patients Name or MID are not valid when no results could be found
		String searchStringResultNotification = "<span class=\"searchResults\">Found " + search.size() + " Records</span>";
		if (search.size() == 0) {
			searchStringResultNotification = "<br><br><h5 style='color: red;'>Patient MID or Name does NOT exist! Please renter a valid patient MID or Name</h3>";
		}
		// Main component of the web page
		StringBuffer result = new StringBuffer(searchStringResultNotification);

		if(isAudit){
			result.append("<table class='fTable' width=80%><tr><th width=10%>MID</th><th width=20%>First Name</th><th width=20%>Last Name</th><th width=30%>Status</th><th width=20%>Action</th></tr>");
			for(PatientBean p : search){
				boolean isActivated = p.getDateOfDeactivationStr() == null || p.getDateOfDeactivationStr().isEmpty();
				String change = isActivated ? "Deactivate" : "Activate";
				result.append("<tr>");
				result.append("<td>" + p.getMID() + "</td>");
				result.append("<td>" + p.getFirstName() + "</td>");
				result.append("<td>" + p.getLastName() + "</td>");
				if(isActivated){
					result.append("<td>" + p.getFirstName() + " " + p.getLastName() + " is activated.</td>");
				} else {
					result.append("<td>" + p.getFirstName() + " " + p.getLastName() + " deactivated on: " + p.getDateOfDeactivationStr() + "</td>");
				}
				result.append("<td>");
				result.append("<input type='button' style='width:100px;' onclick=\"parent.location.href='getPatientID.jsp?UID_PATIENTID=" + StringEscapeUtils.escapeHtml("" + p.getMID()) + "&forward=" + StringEscapeUtils.escapeHtml("" + forward ) + "';\" value=" + StringEscapeUtils.escapeHtml("" + change) + " />");
				result.append("</td></tr>");
			}
			result.append("<table>");
		} else {
			// if from patient information dropdown
			boolean isForPatientInfo = patientObstetricInfo != null;

			String htmlTableString;
			// only show obstetric status column in the table for Patient Information dropdown menu && only when the HCP is of OB or GYN speciality.
			htmlTableString = (isForPatientInfo && hcpIsOBGYN) ?
					"<table class='fTable' width=100%><tr><th width=20%>MID</th><th width=30%>First Name</th><th width=30%>Last Name</th><th width=40%>Obstetric Status</th></tr>"
					: "<table class='fTable' width=80%><tr><th width=20%>MID</th><th width=40%>First Name</th><th width=40%>Last Name</th></tr>";

			result.append(htmlTableString);

			String patientMIDButtonString = "";
			for(PatientBean p : search){
				String htmlLinkForSettingObstetric;

				result.append("<tr>");
				result.append("<td>");



				/*   Patient MID button with certain actions   */
				// For obstetric care dropdown menu  --> initialization
				if (obstetricSearch != null && obstetricSearch.equals("YES")) {
					patientMIDButtonString = "<input type='button' style='width:100px;' onclick=\"parent.location.href='obstetricHistory.jsp?UID_PATIENTID=" + StringEscapeUtils.escapeHtml("" + p.getMID())  + "';\" value=" + StringEscapeUtils.escapeHtml("" + p.getMID()) + " />";
				} else { // The original one
					patientMIDButtonString = "<input type='button' style='width:100px;color:white;background-color:black;' onclick=\"parent.location.href='getPatientID.jsp?UID_PATIENTID=" + StringEscapeUtils.escapeHtml("" + p.getMID()) + "&forward=" + StringEscapeUtils.escapeHtml("" + forward ) +"';\" value=" + StringEscapeUtils.escapeHtml("" + p.getMID()) + " />";
				}
				result.append(patientMIDButtonString);



				result.append("</td>");
				result.append("<td>" + p.getFirstName() + "</td>");
				result.append("<td>" + p.getLastName()  + " </td>");

				// New Column to add for patient information for whether or not they are an obstetric patient (Add hyper link to make them obstetric based on AJAX)
				// (only when the HCP is of OB or GYN speciality)
				if (isForPatientInfo && hcpIsOBGYN) {
					if (p.getObstetricEligible().equals("1")) {
						// htmlLinkForSettingObstetric = "Obstetric Patient";
						htmlLinkForSettingObstetric = "<input class='unsetObstetric' type='button' style='width:150px; color: red;' value='Cancel Obstetric' id=" + StringEscapeUtils.escapeHtml("" + p.getMID()) + ">";
					} else {
						htmlLinkForSettingObstetric = "<input class='setObstetric' type='button' style='width:150px; color: blue;' value='Set Obstetric' id=" + StringEscapeUtils.escapeHtml("" + p.getMID()) + ">";
					}
					result.append("<td>" + htmlLinkForSettingObstetric + " </td>");
				}
				result.append("</tr>");
			}
			result.append("</table>");
		}
		// Add into the javascript for the buttons of Making a patient eligible for obstetric care
		String javaScriptCodeSettingObstetric = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" +
				"<script type = 'text/javascript'>\n" +
				"    var searchBarValue = document.getElementById(\"searchBox\");" +
				"    $(document).ready(function() {\n" +
				"        $(\".setObstetric\").click(function(){\n" +
				"            var id = $(this).attr(\"id\");\n" +


				"$.ajax({\n" +

				"             url : \"PatientSearchServlet\",\n" +

				"             data : {\n" +

				"q : searchBarValue.value," +
				"id : id," +
				"patientObstetricInfo : \"TRUE\"," +
				"setPatientObstetricStatus : \"TRUE\"," +
				"loggedInMID :" + loggedInMID +
				"             },\n" +
				"             success : function(e){\n" +
				"                 $(\"#searchTarget\").html(e);\n" +
				"             }\n" +

				"         });" +
				"        });\n" +
				"    });\n" +
				"</script>";

		result.append(javaScriptCodeSettingObstetric);

		String javaScriptCodeUnsetObstetric = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" +
				"<script type = 'text/javascript'>\n" +
				"    var searchBarValue = document.getElementById(\"searchBox\");" +
				"    $(document).ready(function() {\n" +
				"        $(\".unsetObstetric\").click(function(){\n" +
				"            var id = $(this).attr(\"id\");\n" +

				"$.ajax({\n" +

				"             url : \"PatientSearchServlet\",\n" +

				"             data : {\n" +

				"q : searchBarValue.value," +
				"id : id," +
				"patientObstetricInfo : \"TRUE\"," +
				"setPatientObstetricStatus : \"FALSE\"," +
				"loggedInMID : " + loggedInMID +
				"             },\n" +
				"             success : function(e){\n" +
				"                 $(\"#searchTarget\").html(e);\n" +
				"             }\n" +

				"         });" +
				"        });\n" +
				"    });\n" +
				"</script>";

		result.append(javaScriptCodeUnsetObstetric);

		response.setContentType("text/plain");
		PrintWriter resp = response.getWriter();
		resp.write(result.toString());
	}

}
