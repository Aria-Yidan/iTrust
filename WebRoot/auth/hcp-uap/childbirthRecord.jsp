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

<%@page import="edu.ncsu.csc.itrust.action.EditApptAction"%>
<%@page import="edu.ncsu.csc.itrust.action.EditApptTypeAction"%>
<%@page import="edu.ncsu.csc.itrust.action.ViewMyApptsAction"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.ApptBean"%>
<%@page import="edu.ncsu.csc.itrust.exception.DBException"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.ApptDAO"%>

<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.PatientDAO"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.PatientBean"%>

<%@include file="/global.jsp" %>

<%
	pageTitle = "iTrust - Childbirth Record";

%>

<%@include file="/header.jsp" %>
		
<%
			AddApptAction action = new AddApptAction(prodDAO, loggedInMID.longValue());
			PatientDAO patientDAO = prodDAO.getPatientDAO();	
			


			long patientID = 0L;
			String hidden = ""; 
			
			boolean isDead = false;
			
			String pid = (String) session.getAttribute("pid");
			if (pid == null || pid.equals("") || 1 > pid.length()) {
				out.println("pidstring is null");		
				response.sendRedirect("/iTrust/auth/getPatientID.jsp?forward=hcp-uap/childbirthRecord.jsp");
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
				response.sendRedirect("/iTrust/auth/getPatientID.jsp?forward=hcp-uap/childbirthRecord.jsp");
			} else if(isDead){
				%>
				<div align=center>
					<span class="iTrustError">Cannot schedule appointment. This patient is deceased. Please return and select a different patient.</span>
					<br />
					<a href="/iTrust/auth/getPatientID.jsp?forward=hcp/childbirthRecord.jsp">Back</a>		</div>
				<%	
			}
			
			ViewMyApptsAction view_action = new ViewMyApptsAction(prodDAO, loggedInMID.longValue());
			Long MID = patientDAO.getPatient(patientID).getMID();
			
			ApptDAO apptDAO = prodDAO.getApptDAO();
			List<ApptBean> appts = apptDAO.getAllApptsFor(MID); 
			PatientBean p = patientDAO.getPatient(patientID);
			loggingAction.logEvent(TransactionType.EDIT_CHILDBIRTH_VISIT, loggedInMID.longValue(), p.getMID(), "");

%>

<div align="left" <%=hidden %> id="apptDiv">
	<h2><%= StringEscapeUtils.escapeHtml("" + ( action.getName(patientID) )) %></h2>
	<table class="fTable" width="99%">
	<tr>
        <th>Appointment Type</th>
        <th>Date</th>
        <th>Price</th>
        <th>Comment</th>
    </tr>
	<%
	if (appts!=null) {

		for (ApptBean it:appts) {
			%>
			<tr>
			<td><%= StringEscapeUtils.escapeHtml("" + it.getApptType()) %></td>
			<td><%= StringEscapeUtils.escapeHtml("" + it.getDate()) %></td>
			<td><%= StringEscapeUtils.escapeHtml("" + it.getPrice()) %></td>
			<td><%= StringEscapeUtils.escapeHtml("" + it.getComment()) %></td>
			</tr><%
		}
		
	}else {
		
		%><h2>null</h2><%
	}
	
	%>
	<table>
	<h4> <a href="/iTrust/auth/getPatientID.jsp?forward=hcp-uap/childbirthRecord.jsp">Search for other patient</a></h4>
</div>

<%@include file="/footer.jsp" %>