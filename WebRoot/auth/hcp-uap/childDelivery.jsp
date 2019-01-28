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
<%@page import="edu.ncsu.csc.itrust.action.EditPatientAction"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.PatientDAO"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.ApptTypeDAO"%>
<%@page import="edu.ncsu.csc.itrust.exception.ITrustException"%>
<%@page import="edu.ncsu.csc.itrust.exception.FormValidationException"%>

<%@page import="edu.ncsu.csc.itrust.action.AddPatientAction"%>
<%@page import="edu.ncsu.csc.itrust.BeanBuilder"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.PatientBean"%>
<%@page import="edu.ncsu.csc.itrust.exception.FormValidationException"%>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.Gender"%>

<%@include file="/global.jsp" %>

<%
	pageTitle = "iTrust - Child Delivery";

String headerMessage = "Please fill out the form properly - comments are optional.";
%>

<%@include file="/header.jsp" %>
<%
	//This page is not actually a "page", it just adds a user and forwards.
	AddApptAction action = new AddApptAction(prodDAO, loggedInMID.longValue());
	
	long patientID = 0L;
	
	boolean isDead = false;
	
	String pid = (String) session.getAttribute("pid");
	if (pid == null || pid.equals("") || 1 > pid.length()) {
		out.println("pidstring is null");		
		response.sendRedirect("/iTrust/auth/getPatientID.jsp?forward=hcp-uap/childDelivery.jsp");
		return;
	}
	EditPatientAction parent_action = new EditPatientAction(prodDAO, loggedInMID.longValue(), pid);
	
	
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
		response.sendRedirect("/iTrust/auth/getPatientID.jsp?forward=hcp-uap/childDelivery.jsp");
	}

	
	PatientBean p;
	PatientBean parent;
	PatientDAO patientDAO = prodDAO.getPatientDAO();
	parent= patientDAO.getPatient(patientID);
	boolean formIsFilled = request.getParameter("formIsFilled") != null && request.getParameter("formIsFilled").equals("true");
	if (formIsFilled) {
		//This page is not actually a "page", it just adds a user and forwards.
		
		p = new PatientBean();
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String dateOfBirth = request.getParameter("dateOfBirthStr");
		String gender = request.getParameter("genderStr");
		String Time1 = request.getParameter("time1");
		String Time2 = request.getParameter("time2");
		String Time3 = request.getParameter("time3");
		String birthTime= Time1+":"+Time2+" "+Time3;
		String preferMethod = request.getParameter("delivery_method");
		String email = firstName+"."+lastName+"@gmail.com";
		
		p.setFirstName(firstName);
		p.setLastName(lastName);
		p.setDateOfBirthStr(dateOfBirth);
		p.setGenderStr(gender);
		p.setBirthTime(birthTime);
		p.setEmail(email);
		loggingAction.logEvent(TransactionType.CREATE_BABY_RECORD, loggedInMID.longValue(), p.getMID(), "");
		// p.getperferMethod(); //get prefer method
		parent.setPreferMethod(preferMethod); //set prefer method
		if (patientDAO.getPatient(patientID).getGender()==Gender.Male) {
			String fatherMidStr=Long.toString(patientDAO.getPatient(patientID).getMID());
			p.setFatherMID(fatherMidStr);
		}else if (patientDAO.getPatient(patientID).getGender()==Gender.Female) {
			String motherMidStr=Long.toString(patientDAO.getPatient(patientID).getMID());
			p.setMotherMID(motherMidStr);
		}
		
	     
		try{
			boolean isDependent = false;
			long representativeId = -1L;
			
			long newMID = 1L; 
			
			newMID = new AddPatientAction(prodDAO, loggedInMID.longValue()).addPatient(p, loggedInMID.longValue());
			parent_action.updateInformation(parent);
			session.setAttribute("pid", Long.toString(newMID));
			String fullname;
			String password;
			password = p.getPassword();
			fullname = p.getFullName();
	%>
		<div align=center>
			<span class="iTrustMessage">New patient <%= StringEscapeUtils.escapeHtml("" + (fullname)) %> successfully added!</span>
			<br />
			<table class="fTable">
				<tr>
					<th colspan=2>New Patient Information</th>
				</tr>
				<tr>
					<td class="subHeaderVertical">MID:</td>
					<td><%= StringEscapeUtils.escapeHtml("" + (newMID)) %></td>
				</tr>
				<tr>
					<td class="subHeaderVertical">Temporary Password:</td>
					<td><%= StringEscapeUtils.escapeHtml("" + (password)) %></td>
				</tr>
			</table>
			<br />Please get this information to <b><%= StringEscapeUtils.escapeHtml("" + (fullname)) %></b>! 
			<p>
				<a href = "/iTrust/auth/hcp-uap/editPatient.jsp">Continue to patient information.</a>
			</p>
		</div>
	<%
		} catch(FormValidationException e){
	%>
		<div align=center>
			<span class="iTrustError"><%=StringEscapeUtils.escapeHtml(e.getMessage()) %></span>
		</div>
	<%
		}
	}
%>


<form id="mainForm" method="post" action="childDelivery.jsp">
		<input type="hidden" name="formIsFilled" value="true"> <br />
<div align="left"  id="apptDiv">
	<h2>Child Birth Date and Time</h2>
	<h4>with <%= StringEscapeUtils.escapeHtml("" + ( action.getName(patientID) )) %> (<a href="/iTrust/auth/getPatientID.jsp?forward=hcp-uap/childDelivery.jsp">someone else</a>):</h4>
		
		<span>First Name:</span>
		<input name="firstName" type="text"><br/><br/>
		
		<span>Last Name:</span>
		<input name="lastName" type="text"><br/><br/>
		
		<Span>Gender:</Span>
		<select name="genderStr"><option value="Male">Male</option>
		<option value="Female">Female</option>
		</select><br /><br />
		
		
		<span>Birth Date: </span><input type=text name="dateOfBirthStr" maxlength="10"
					size="10"> <input
					type=button value="Select Date"
					onclick="displayDatePicker('dateOfBirthStr');">
		<br/><br/>
		<span>Birth Time: </span>
		<select name="time1">
			<%
				String hour = "";
				for(int i = 0; i <= 12; i++) {
					if(i < 10) hour = "0"+i;
					else hour = i+"";
					if(i==0) hour = " ";
					%>
						<option value="<%=hour%>"><%= StringEscapeUtils.escapeHtml("" + (hour)) %></option>
					<%
				}
			%>
		</select>:<select name="time2">
			<%
				String min = "";
				for(int i = 0; i < 60; i+=5) {
					if(i < 10) min = "0"+i;
					else min = i+"";
					if(i==0) {
						%>
						<option value="<%=min%>"><%= StringEscapeUtils.escapeHtml("" + (" ")) %></option>
					<%
						%>
						<option value="<%=min%>"><%= StringEscapeUtils.escapeHtml("" + (min)) %></option>
					<%
					}
						
					else{
					%>
						<option value="<%=min%>"><%= StringEscapeUtils.escapeHtml("" + (min)) %></option>
					<%
					}
				}
			%>
		</select>
		<select name="time3"><option value=""><%= StringEscapeUtils.escapeHtml("" + (" ")) %></option>
		<option  value="AM">AM</option
		><option   value="PM">PM</option></select><br /><br />
		
		<span>Delivery Method</span>
		<select name="delivery_method">
		<option value="">Select:</option>
		<option value="vaginal delivery" <%= StringEscapeUtils.escapeHtml("" + ( parent.getPreferMethod().equals("vaginal delivery") ? "selected" : "" )) %>>vaginal delivery</option>
		<option value="vaginal delivery vacuum assist"<%= StringEscapeUtils.escapeHtml("" + ( parent.getPreferMethod().equals("vaginal delivery vacuum assist") ? "selected" : "" )) %>>vaginal delivery vacuum assist</option>
		<option value="vaginal delivery forceps assist" <%= StringEscapeUtils.escapeHtml("" + ( parent.getPreferMethod().equals("vaginal delivery forceps assist") ? "selected" : "" )) %>>vaginal delivery forceps assist</option>
		<option value="caesarean section" <%= StringEscapeUtils.escapeHtml("" + ( parent.getPreferMethod().equals("caesarean section") ? "selected" : "" )) %>>caesarean section</option>
		<option value="miscarriage" <%= StringEscapeUtils.escapeHtml("" + ( parent.getPreferMethod().equals("miscarriage") ? "selected" : "" )) %>>miscarriage</option>
		
		</select><br /><br />
		
		<input type="submit" value="Confirm" name="scheduleButton"/>
		<!-- <input type="submit" style="font-size: 16pt; font-weight: bold;" value="Add patient"> -->
		<input type="hidden" value="Schedule" name="schedule"/>
		<input type="hidden" id="override" name="override" value="noignore"/>

	<br />
	<br />
</div>
	</form>

<%@include file="/footer.jsp" %>