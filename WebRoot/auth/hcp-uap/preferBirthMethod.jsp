<%@page import="java.text.ParseException"%>
<%@page errorPage="/auth/exceptionHandler.jsp"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.ApptBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.ApptTypeBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.PatientBean"%>

<%@page import="edu.ncsu.csc.itrust.action.AddApptAction"%>
<%@page import="edu.ncsu.csc.itrust.action.EditApptTypeAction"%>
<%@page import="edu.ncsu.csc.itrust.action.ViewMyApptsAction"%>
<%@page import="edu.ncsu.csc.itrust.action.EditPatientAction"%>

<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.PatientDAO"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.ApptTypeDAO"%>
<%@page import="edu.ncsu.csc.itrust.exception.ITrustException"%>
<%@page import="edu.ncsu.csc.itrust.exception.FormValidationException"%>

<%@page import="edu.ncsu.csc.itrust.model.old.dao.DAOFactory"%>


<%@include file="/global.jsp" %>

<%
	pageTitle = "iTrust - Prefer Childbirth Method";

%>

<%@include file="/header.jsp" %>

<%
			AddApptAction action = new AddApptAction(prodDAO, loggedInMID.longValue());

			long patientID = 0L;
			String hidden = "";

			boolean isDead = false;
			String pid = (String) session.getAttribute("pid");
			if (pid == null || pid.equals("") || 1 > pid.length()) {
				out.println("pidstring is null");		
				response.sendRedirect("/iTrust/auth/getPatientID.jsp?forward=hcp-uap/preferBirthMethod.jsp");
				return;
			}
			
			if (session.getAttribute("pid") != null) {
				String pidString = (String) session.getAttribute("pid");
				patientID = Long.parseLong(pidString);
				try {
			action.getName(patientID);
				} catch (ITrustException ite) {
			patientID = 0L;
				}

			}
			else {
				session.removeAttribute("pid");
			}

			if (patientID == 0L) {
				response.sendRedirect("/iTrust/auth/getPatientID.jsp?forward=hcp-uap/preferBirthMethod.jsp");
			} else if(isDead){
				%>
				<div align=center>
					<span class="iTrustError">Cannot schedule appointment. This patient is deceased. Please return and select a different patient.</span>
					<br />
					<a href="/iTrust/auth/getPatientID.jsp?forward=hcp/preferBirthMethod.jsp">Back</a>		</div>
				<%
			}


%>

<div align="left" <%=hidden %> id="apptDiv">
	<h4><%= StringEscapeUtils.escapeHtml("" + ( action.getName(patientID) )) %> (<a href="/iTrust/auth/getPatientID.jsp?forward=hcp-uap/preferBirthMethod.jsp">Search for other patient</a>):</h4>

	<%
		//get the method from database
		String databaseperfm;
		String display;
		String perfm=(String)request.getParameter("Perfermethod");
		String pidString = (String) session.getAttribute("pid");

		//get the patinent information
		PatientDAO PatientDAO = prodDAO.getPatientDAO();
		PatientBean p = PatientDAO.getPatient(patientID);
		databaseperfm = p.getPreferMethod();
		if (databaseperfm.isEmpty()){
			databaseperfm = "No";
		}
		//try to update the data base with selected childbirth method
		if (perfm != null){
			databaseperfm = perfm;
			try {
				p.setPreferMethod(perfm);
				EditPatientAction edit = new EditPatientAction(prodDAO, loggedInMID.longValue(), pidString);
				edit.updateInformation(p);
	%>
	<br />
	<div align=center>
		<span class="iTrustMessage">Information Successfully Updated</span>
	</div>
	<br />
	<%
		} catch (FormValidationException e) { }
	}
	%>
	<div><span class="iTrustMessage">Current prefered childbirth method: <%=databaseperfm%></span></div>

	<p>Please select prefered Childbirth Method:</p>
	<form>
	<div>
		<input type="radio" id="Perfermethod" name="Perfermethod" value="vaginal delivery">
		<label for="vaginal_delivery">vaginal delivery</label>
	</div>

	<div>
		<input type="radio" id="Perfermethod" name="Perfermethod" value="vaginal delivery vacuum assist">
		<label for="vaginal_delivery_vacuum_assist">vaginal delivery vacuum assist</label>
	</div>

	<div>
		<input type="radio" id="Perfermethod" name="Perfermethod" value="vaginal delivery forceps assist">
		<label for="vaginal_delivery_forceps_assist">vaginal delivery forceps assist</label>
	</div>
    <div>
        <input type="radio" id="Perfermethod" name="Perfermethod" value="caesarean section">
        <label for="caesarean_section">caesarean section</label>
    </div>
    <div>
        <input type="radio" id="Perfermethod" name="Perfermethod" value="miscarriage">
        <label for="miscarriage">miscarriage</label>
    </div>
    <div>
        <button type="submit">Submit</button>
    </div>
    </form>

</div>

<%@include file="/footer.jsp" %>
