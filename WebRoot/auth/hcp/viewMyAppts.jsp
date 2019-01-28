
<%@page errorPage="/auth/exceptionHandler.jsp"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Calendar"%>
<%@page import="edu.ncsu.csc.itrust.action.EditApptTypeAction"%>
<%@page import="edu.ncsu.csc.itrust.action.ViewMyApptsAction"%>
<%@page import="edu.ncsu.csc.itrust.action.AddApptAction"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.ApptBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.ApptTypeDAO"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.DAOFactory"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.OfficeVisitRecordDAO"%>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.TransactionType"%>
<%@page import="edu.ncsu.csc.itrust.logger.TransactionLogger"%>

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
	ViewMyApptsAction action = new ViewMyApptsAction(prodDAO, loggedInMID.longValue());
	ApptTypeDAO apptTypeDAO = prodDAO.getApptTypeDAO();
	List<ApptBean> appts = action.getAllMyAppointments();
	session.setAttribute("appts", appts);
	if (action.getMyAppointments().size() > 0) { %>
	<table class="fTable">
		<tr>
			<th>Patient</th>
			<th>Appointment Type</th>
			<th>Appointment Date/Time</th>
			<th>Duration</th>
			<th>Comments</th>
			<th>Change</th>
            <th></th>
		</tr>
<%		 
		List<ApptBean>conflicts = action.getAllConflicts(loggedInMID.longValue());
		int index = 0;
		for (int i = 0; i < appts.size(); i++) {
		    ApptBean a = appts.get(i);

            // s7
            long c = System.currentTimeMillis();
            long du = apptTypeDAO.getApptType(a.getApptType()).getDuration() * 60 * 1000;
            if (a.getApptType().equals("Ultrasound")
                    && c >= a.getDate().getTime() + du) {
                // check that no newer appointment exists
                boolean shouldAdd = true;
                for (int j = i + 1; j < appts.size(); j++) {
                    ApptBean b = appts.get(j);
                    if (b.getApptType().equals("Ultrasound")
                            && b.getPatient() == a.getPatient()) {
                        shouldAdd = false;
                        break;
                    }
                }
                if (shouldAdd) {
                    OfficeVisitRecordDAO officeVisitRecord = new OfficeVisitRecordDAO(prodDAO);
                    System.out.println(a.getPatient());
                    int weeksOfPregnant = Integer.parseInt(officeVisitRecord.getPatientOfficeVisitRecord(a.getPatient()).get(0).getWeeksOfPregnant().substring(0, 2));
                    boolean isChildbirth = false;

                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new Date(a.getDate().getTime()));

                    int days = 0;

                    if (weeksOfPregnant <= 13) {
                        // 0 - 13 weeks pregnant: Monthly appointments (every 4 weeks)
                        System.out.println("0-13");
                        days = 20;
                    } else if (weeksOfPregnant <= 28) {
                        // 14 - 28 weeks pregnant: Appointments every 2 weeks
                        System.out.println("14-28");
                        days = 10;
                    } else if (weeksOfPregnant <= 40) {
                        // 29 - 40 weeks pregnant: Appointments weekly
                        System.out.println("29-40");
                        days = 5;
                    } else if (weeksOfPregnant <= 42) {
                        // 40 - 42 weeks pregnant: appointments every other weekday [E8]
                        System.out.println("40-42");
                        days = 2;
                    } else {
                        // [E8] If the patient reaches 42 weeks pregnant, the next visit is a Childbirth Hospital Visit
                        // (UC96)
                        isChildbirth = true;
                    }
                    for (int j = 0; j < days || (new Timestamp(calendar.getTimeInMillis())).before(new Date()); ) {
                        calendar.add(Calendar.DAY_OF_MONTH, 1);
                        if (calendar.get(Calendar.DAY_OF_WEEK) <= 5) {
                            j++;
                        }
                    }
                    ApptBean e = new ApptBean();
                    e.setPrice(a.getPrice());
                    if (isChildbirth) {
                        e.setApptType("Child Birth");
                    } else {
                        e.setApptType("Ultrasound");
                    }
                    e.setPatient(a.getPatient());
                    e.setHcp(a.getHcp());
                    e.setComment(a.getComment());
                    e.setDate(new Timestamp(calendar.getTimeInMillis()));
                    AddApptAction addAction = new AddApptAction(prodDAO, loggedInMID.longValue());
                    addAction.addAppt(e, true);
                    if (isChildbirth) {
                        TransactionLogger.getInstance().logTransaction(TransactionType.CHILDBIRTH_ADD,
                                e.getHcp(), e.getPatient(),
                                String.valueOf(a.getApptID()) + ", " + String.valueOf(e.getApptID()));
                    } else {
                        TransactionLogger.getInstance().logTransaction(TransactionType.NEXT_OFFICE_VISIT_RECORD_ADD,
                                e.getHcp(), e.getPatient(),
                                String.valueOf(a.getApptID()) + ", " + String.valueOf(e.getApptID()));
                    }
                }
            }

            // new filter
            if (!a.getDate().before(new Date())) {
                String comment = "No Comment";
                if(a.getComment() != null)
                    comment = "<a href='viewAppt.jsp?apt=" + a.getApptID() + "'>Read Comment</a>";

                Date d = new Date(a.getDate().getTime());
                Date now = new Date();
                DateFormat format = new SimpleDateFormat("MM/dd/yyyy hh:mm a");

                String row = "<tr";
                if(conflicts.contains(a))
                    row += " style='font-weight: bold;'";
    %>
                <%=row+" "+((index%2 == 1)?"class=\"alt\"":"")+">"%>
                    <td><%= StringEscapeUtils.escapeHtml("" + ( action.getName(a.getPatient()) )) %></td>
                    <td><%= StringEscapeUtils.escapeHtml("" + ( a.getApptType() )) %></td>
                    <td><%= StringEscapeUtils.escapeHtml("" + ( format.format(d) )) %></td>
                    <td><%= StringEscapeUtils.escapeHtml("" + ( apptTypeDAO.getApptType(a.getApptType()).getDuration()+" minutes" )) %></td>
                    <td><%= comment %></td>
                    <td><% if(d.after(now)){ %><a href="editAppt.jsp?apt=<%=a.getApptID() %>">Edit/Remove</a> <% } %></td>
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
        <%
                index ++;
            }
		}
	%>
	</table>
<%	} else { %>
	<div>
		<i>You have no Appointments</i>
	</div>
<%	} %>	
	<br />
</div>

<%@include file="/footer.jsp" %>
