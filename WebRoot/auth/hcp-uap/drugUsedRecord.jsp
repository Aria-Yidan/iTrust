<%@page import="java.text.ParseException"%>
<%@page errorPage="/auth/exceptionHandler.jsp"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.ApptBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.ApptTypeBean"%>
<%@page import="edu.ncsu.csc.itrust.action.AddApptAction"%>
<%@page import="edu.ncsu.csc.itrust.action.EditApptTypeAction"%>
<%@page import="edu.ncsu.csc.itrust.action.ViewMyApptsAction"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.PatientDAO"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.ApptTypeDAO"%>
<%@page import="edu.ncsu.csc.itrust.exception.ITrustException"%>
<%@page import="edu.ncsu.csc.itrust.exception.FormValidationException"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.DAOFactory"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.PatientBean"%>
<%@page import="edu.ncsu.csc.itrust.action.EditPatientAction"%>

<%@include file="/global.jsp" %>

<%
	pageTitle = "iTrust - Drug Used Record";

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
				response.sendRedirect("/iTrust/auth/getPatientID.jsp?forward=hcp-uap/drugUsedRecord.jsp");
			} else if(isDead){
				%>
				<div align=center>
					<span class="iTrustError">Cannot schedule appointment. This patient is deceased. Please return and select a different patient.</span>
					<br />
					<a href="/iTrust/auth/getPatientID.jsp?forward=hcp/drugUsedRecord.jsp">Back</a>		</div>
				<%	
			}
			

%>

<div align="left" <%=hidden %> id="apptDiv">

	<h4><%= StringEscapeUtils.escapeHtml("" + ( action.getName(patientID) )) %> (<a href="/iTrust/auth/getPatientID.jsp?forward=hcp-uap/drugUsedRecord.jsp">Search for other patient</a>):</h4>

</div>

<%
    //pull data from database
	String pidString = (String) session.getAttribute("pid");
	PatientDAO PatientDAO = prodDAO.getPatientDAO();
	PatientBean p = PatientDAO.getPatient(patientID);
	Boolean Pitocin_db = p.getPitocin();
	Boolean Nitrous_db = p.getNitrous_oxide();
	Boolean Pethidine_db = p.getPethidine();
	Boolean Epidural_db = p.getEpidural_anaesthesia();
	Boolean Magnesium_db = p.getMagnesium_sulfate();
	Boolean RH_db = p.getRH_immune_globulin();

	String  update =(String)request.getParameter("update");

	//update drugs using data from web server
	if(update != null){
		String Pitocin =(String)request.getParameter("Pitocin");
		String Nitrous_oxide =(String)request.getParameter("Nitrous oxide");
		String Pethidine =(String)request.getParameter("Pethidine");
		String Epidural_anaesthesia =(String)request.getParameter("Epidural anaesthesia");
		String Magnesium_sulfate =(String)request.getParameter("Magnesium sulfate");
		String RH =(String)request.getParameter("RH immune globulin");

		Pitocin_db = (Pitocin == null) ? false : true;
		Nitrous_db = (Nitrous_oxide == null) ? false : true;
		Pethidine_db = (Pethidine == null) ? false : true;
		Epidural_db = (Epidural_anaesthesia == null) ? false : true;
		Magnesium_db = (Magnesium_sulfate == null) ? false : true;
		RH_db = (RH == null) ? false : true;
		try {
		    //set the drug and try to update the database
			p.setPitocin(Pitocin_db);
			p.setNitrous_oxide(Nitrous_db);
			p.setPethidine(Pethidine_db);
			p.setEpidural_anaesthesia(Epidural_db);
			p.setMagnesium_sulfate(Magnesium_db);
			p.setRH_immune_globulin(RH_db);

			EditPatientAction edit = new EditPatientAction(prodDAO, loggedInMID.longValue(), pidString);
			edit.updateInformation(p);
%>
<br />
<div align=center>
	<span class="iTrustMessage">Information Successfully Updated</span>
</div>
<br />
<%
            //log the transcation
            loggingAction.logEvent(TransactionType.ADD_CHILDBIRTH_DRUG, loggedInMID.longValue(), p.getMID(), "");
		} catch (FormValidationException e) { }
	}
%>

<p>Please select used drug Record: </p>

<form>
	<div>
	<input type="checkbox" name="Pitocin" id="Pitocin" value="Pitocin" <%=Pitocin_db ? "checked" : ""%>>
	<label for="Pitocin">Pitocin</label>
		<br />
	<input type="checkbox" name="Nitrous oxide" id="Nitrous oxide" value="Nitrous oxide" <%=Nitrous_db ? "checked" : ""%>>
	<label for="Nitrous oxide">Nitrous oxide</label>
		<br />
	<input type="checkbox" name="Pethidine" id="Pethidine" value="Pethidine" <%=Pethidine_db ? "checked" : ""%>>
	<label for="Pethidine">Pethidine</label>
		<br />
	<input type="checkbox" name="Epidural anaesthesia" id="Epidural anaesthesia" value="Epidural anaesthesia" <%=Epidural_db ? "checked" : ""%>>
	<label for="Epidural anaesthesia">Epidural anaesthesia</label>
		<br />
	<input type="checkbox" name="Magnesium sulfate" id="Magnesium sulfate" value="Magnesium sulfate" <%=Magnesium_db ? "checked" : ""%>>
	<label for="Magnesium sulfate">Magnesium sulfate</label>
		<br />
	<input type="checkbox" name="RH immune globulin" id="RH immune globulin" value="RH immune globulin" <%=RH_db ? "checked" : ""%>>
	<label for="RH immune globulin">RH immune globulin</label>
		<br />
	</div>
	<div>
		<button type="submit" name = "update">Update</button>
	</div>
</form>

<%@include file="/footer.jsp" %>