<%@page errorPage="/auth/exceptionHandler.jsp"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="edu.ncsu.csc.itrust.action.EditApptTypeAction"%>
<%@page import="edu.ncsu.csc.itrust.action.ViewMyApptsAction"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.ApptBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.ApptTypeDAO"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.DAOFactory"%>

<%@include file="/global.jsp" %>

<%
pageTitle = "iTrust - View My Messages";
%>

<%@include file="/header.jsp" %>

<head>
    <script src="../add-to-calendar-buttons/ouical.js"></script>
    <link rel="stylesheet" href="../add-to-calendar-buttons/main.css">
    <title>OuiCal Example</title>
</head>

<div align=center>
	<h2>My Appointments</h2>
<%
	loggingAction.logEvent(TransactionType.APPOINTMENT_ALL_VIEW, loggedInMID.longValue(), 0, "");
	
	ViewMyApptsAction action = new ViewMyApptsAction(prodDAO, loggedInMID.longValue());
	EditApptTypeAction types = new EditApptTypeAction(prodDAO, loggedInMID.longValue());
	ApptTypeDAO apptTypeDAO = prodDAO.getApptTypeDAO();
	List<ApptBean> appts = action.getMyAppointments();
	session.setAttribute("appts", appts);
	if (appts.size() > 0) {
%>
	<table class="fancyTable">
		<tr>
			<th>Patient</th>
			<th>Appointment Type</th>
			<th>Appointment Date/Time</th>
			<th>Duration</th>
			<th></th>
            <th></th>
		</tr>
<%		 
		

		List<ApptBean>conflicts = action.getAllConflicts(loggedInMID.longValue());

		int index = 0;
		for(ApptBean a : appts) {
		    // s7
//            long c = System.currentTimeMillis();
//            long du = apptTypeDAO.getApptType(a.getApptType()).getDuration() * 60 * 1000;
//			if (a.getApptType().equals("Ultrasound")
//                    && c >= a.getDate().getTime() + du) {
//                System.out.println(a.getPatient());
//            }

            String comment = "";
            if(a.getComment() == null)
                comment = "No Comment";
            else
                comment = "<a href='viewAppt.jsp?apt=" + a.getApptID() + "'>Read Comment</a>";

            Date d = new Date(a.getDate().getTime());
            DateFormat format = new SimpleDateFormat("MM/dd/yyyy hh:mm a");

            String row = "";
            if(conflicts.contains(a))
                row = "<tr style='font-weight: bold;'";
            else
                row = "<tr";
%>
            <%=row+" "+((index%2 == 1)?"class=\"alt\"":"")+">"%>
                <td><%= StringEscapeUtils.escapeHtml("" + ( action.getName(a.getHcp()) )) %></td>
                <td><%= StringEscapeUtils.escapeHtml("" + ( a.getApptType() )) %></td>
                <td><%= StringEscapeUtils.escapeHtml("" + ( format.format(d) )) %></td>
                <td><%= StringEscapeUtils.escapeHtml("" + ( apptTypeDAO.getApptType(a.getApptType()).getDuration()+" minutes" )) %></td>
                <td><%= comment %></td>
                <td class="new-cal<%=index%>" />
                <script>
                    var myCalendar = createCalendar({
                            options: {
                                class: 'my-class'                         // Notice how this one does not have a preset ID
                            },
                            data: {
                                title: "<%= a.getApptType() %> appointment",
                                start: new Date("<%= d %>"),
                                duration: "<%= apptTypeDAO.getApptType(a.getApptType()).getDuration() %>"
                            }
                        });
                    document.querySelector("td.new-cal<%=index%>").appendChild(myCalendar);
                </script>
            </tr>
            <% index ++; %>
	<%	} %>
	</table>
<%	} else { %>
	<div>
		<i>You have no Appointments</i>
	</div>
<%	} %>	
	<br />
</div>

<%@include file="/footer.jsp" %>
