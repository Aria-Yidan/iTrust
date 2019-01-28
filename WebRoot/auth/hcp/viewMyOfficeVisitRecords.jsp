<%@page errorPage="/auth/exceptionHandler.jsp"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="edu.ncsu.csc.itrust.action.ViewMyOfficeVisitRecordsAction"%>
<%@page import="edu.ncsu.csc.itrust.action.AddUltrasoundRecordAction"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.OfficeVisitRecordBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.UltraSoundRecordBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.DAOFactory"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.PatientDAO"%>
<%@page import="edu.ncsu.csc.itrust.logger.TransactionLogger" %>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.TransactionType" %>

<%@include file="/global.jsp" %>

<%
    pageTitle = "iTrust - View My Messages";
%>

<%@include file="/header.jsp" %>

<div align=center>
    <h2>My Office Visit</h2>
    <%
        ViewMyOfficeVisitRecordsAction action = new ViewMyOfficeVisitRecordsAction(prodDAO, loggedInMID.longValue());
        TransactionLogger.getInstance().logTransaction(TransactionType.OFFICE_VISIT_RECORDS_VIEW, loggedInMID, 0L, "");
        AddUltrasoundRecordAction action1 = new AddUltrasoundRecordAction(prodDAO, loggedInMID.longValue());
        List<OfficeVisitRecordBean> officeVisitRecords = action.getMyOfficeVisitRecords();
        session.setAttribute("officeVisitRecords", officeVisitRecords);
        if (officeVisitRecords.size() > 0) { %>
    <table class="fTable">
        <tr>
            <th>Patient</th>
            <th>Weeks of Pregnancy</th>
            <th>Weight Gain</th>
            <th>High Blood Pressure</th>
            <th>Low Blood Pressure</th>
            <th>Fetal Heart Rate</th>
            <th>Number of Pregnancy</th>
            <th>Low Lying Placenta</th>
            <th>Change</th>
            <th>Add Ultrasound Record</th>
            <th>RH immune globulin shot needed</th>
        </tr>
        <%
            int index = 0;
            for(OfficeVisitRecordBean ov : officeVisitRecords) {

                String row = "<tr";
                PatientDAO patient = new PatientDAO(prodDAO);
                String bloodType = patient.getPatient(ov.getPatient()).getBloodType().getName();
        %>
        <%=row+" "+((index%2 == 1)?"class=\"alt\"":"")+">"%>
        <td><%= StringEscapeUtils.escapeHtml("" + ( action.getName(ov.getPatient()) )) %></td>
        <td><%= StringEscapeUtils.escapeHtml("" + ( ov.getWeeksOfPregnant() )) %></td>
        <td><%= StringEscapeUtils.escapeHtml("" + ( ov.getWeightGain() )) %></td>
        <td><%= StringEscapeUtils.escapeHtml("" + ( ov.getHighBloodPressure() )) %></td>
        <td><%= StringEscapeUtils.escapeHtml("" + ( ov.getLowBloodPressure() )) %></td>
        <td><%= StringEscapeUtils.escapeHtml("" + ( ov.getFetalHeartRate() )) %></td>
        <td><%= StringEscapeUtils.escapeHtml("" + ( ov.getNumberOfPregnancy() )) %></td>
        <td><%= StringEscapeUtils.escapeHtml("" + ( ov.getLowLyingPlacenta() )) %></td>
        <td><a href="editOfficeVisitRecord.jsp?apt=<%=ov.getOfficeVisitRecordID() %>">Edit</a></td>
        <%
            UltraSoundRecordBean ul = action1.getUltrasoundRecord(ov.getOfficeVisitRecordID());
            if (ul != null) {
                %>
                <td><a href="documentUltraSound.jsp?apt=<%=ov.getOfficeVisitRecordID()%>&exists=True">View</a></td> <%
            } else {
                %><td><a href="documentUltraSound.jsp?apt=<%=ov.getOfficeVisitRecordID()%>&exists=False">Add</a></td> <%
            }
        %>
        <td><%= bloodType != null && !bloodType.equals("") && bloodType.charAt(bloodType.length() - 1) == '-'
                && Integer.parseInt(ov.getWeeksOfPregnant().substring(0, 2)) >= 28 ? "Yes" : "No" %></td>
        </tr>
        <%
                index ++;
            }
        %>
    </table>
    <%	} else { %>
    <div>
        <i>You have no Office Visits</i>
    </div>
    <%	} %>
    <br />
</div>

<%@include file="/footer.jsp" %>
