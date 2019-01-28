<%@page errorPage="/auth/exceptionHandler.jsp"%>

<%@page import="edu.ncsu.csc.itrust.action.EditOfficeVisitRecordAction"%>
<%@page import="edu.ncsu.csc.itrust.action.ViewMyOfficeVisitRecordsAction"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.OfficeVisitRecordBean"%>
<%@page import="edu.ncsu.csc.itrust.exception.FormValidationException"%>
<%@page import="edu.ncsu.csc.itrust.exception.ITrustException"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>

<%@include file="/global.jsp" %>

<%
    pageTitle = "iTrust - Edit Office Visit";
%>

<%@include file="/header.jsp" %>

<%
    EditOfficeVisitRecordAction action = new EditOfficeVisitRecordAction(prodDAO, loggedInMID.longValue());
    ViewMyOfficeVisitRecordsAction viewAction = new ViewMyOfficeVisitRecordsAction(prodDAO, loggedInMID.longValue());
    OfficeVisitRecordBean original = null;
    String ovrParameter = "";
    if (request.getParameter("apt") != null) {
        ovrParameter = request.getParameter("apt");
        try {
            int officeVisitRecordID = Integer.parseInt(ovrParameter);
            original = action.getOfficeVisitRecord(officeVisitRecordID);
            if (original == null){
                response.sendRedirect("viewMyOfficeVisitRecords.jsp");
            } else {
                action.setOriginalOfficeVisitRecordID(original.getOfficeVisitRecordID());
                action.setOriginalPatient(original.getPatient());
            }
        } catch (NullPointerException npe) {
            response.sendRedirect("viewMyOfficeVisitRecords.jsp");
        } catch (NumberFormatException e) {
            // Handle Exception
            response.sendRedirect("viewMyOfficeVisitRecords.jsp");
        }
    } else {
        response.sendRedirect("viewMyOfficeVisitRecords.jsp");
    }

    // patientID
    Long patientID = 0L;
    if (session.getAttribute("pid") != null) {
        String pidString = (String) session.getAttribute("pid");
        patientID = Long.parseLong(pidString);
        try {
            action.getName(patientID);
        } catch (ITrustException ite) {
            patientID = 0L;
        }
    }

    boolean hideForm = false;

    String hidden = "";

    String lastWeeksOfPregnant = original.getWeeksOfPregnant();
    double lastWeightGain = original.getWeightGain();
    double lastHighBloodPressure = original.getHighBloodPressure();
    double lastLowBloodPressure = original.getLowBloodPressure();
    double lastFetalHeartRate = original.getFetalHeartRate();
    int lastNumberOfPregnancy = original.getNumberOfPregnancy();
    boolean lastLowLyingPlacenta = original.getLowLyingPlacenta();

    if (lastWeeksOfPregnant == null) {
        lastWeeksOfPregnant = "";
    }

    // Handle form submit here
    if (request.getParameter("editOfficeVisitRecord") != null && request.getParameter("officeVisitRecordID") != null) {
        String headerMessage = "";
        if (request.getParameter("editOfficeVisitRecord").equals("Change")) {
            // Change the appointment

//            lastWeeksOfPregnant = request.getParameter("weeksOfPregnant");
            lastWeightGain = Double.parseDouble(request.getParameter("weightGain"));
            lastHighBloodPressure = Double.parseDouble(request.getParameter("highbloodPressure"));
            lastLowBloodPressure = Double.parseDouble(request.getParameter("lowbloodPressure"));
            lastFetalHeartRate = Double.parseDouble(request.getParameter("fetalHeartRate"));
            lastNumberOfPregnancy = Integer.parseInt(request.getParameter("numberOfPregnancy"));
            lastLowLyingPlacenta = Boolean.parseBoolean(request.getParameter("lowLyingPlacenta"));

            OfficeVisitRecordBean officeVisitRecord = new OfficeVisitRecordBean();
            officeVisitRecord.setOfficeVisitRecordID(Integer.parseInt(request.getParameter("officeVisitRecordID")));
            officeVisitRecord.setPatient(patientID);
            officeVisitRecord.setHcp(loggedInMID);
            officeVisitRecord.setWeeksOfPregnant(lastWeeksOfPregnant);
            officeVisitRecord.setWeightGain(lastWeightGain);
            officeVisitRecord.setHighBloodPressure(lastHighBloodPressure);
            officeVisitRecord.setLowBloodPressure(lastLowBloodPressure);
            officeVisitRecord.setFetalHeartRate(lastFetalHeartRate);
            officeVisitRecord.setNumberOfPregnancy(lastNumberOfPregnancy);
            officeVisitRecord.setLowLyingPlacenta(lastLowLyingPlacenta);
            // currenteDate?

            // not changed yet
//            String comment = "";
//            if(request.getParameter("comment").equals("") || request.getParameter("comment").equals("No Comment"))
//                comment = null;
//            else
//                comment = request.getParameter("comment");
//            appt.setComment(comment);
            try {
                headerMessage = action.editOfficeVisitRecord(officeVisitRecord);
                if(headerMessage.startsWith("Success")) {
                    hideForm = true;
                    session.removeAttribute("pid");
%>
                    <div align=center>
                        <span class="iTrustMessage"><%=StringEscapeUtils.escapeHtml(headerMessage)%></span>
                    </div>
<%
                } else {
%>
                    <div align=center>
                        <span class="iTrustError"><%=StringEscapeUtils.escapeHtml(headerMessage)%></span>
                    </div>
<%
                }
            } catch (FormValidationException e){
%>
                <div align=center><span class="iTrustError"><%=StringEscapeUtils.escapeHtml(e.getMessage())%></span></div>
<%
            }
        }
    }
    if (original != null && !hideForm) {
        boolean selected = false;
%>
<form id="mainForm" <%=hidden %> method="post" action="editOfficeVisitRecord.jsp?apt=<%=ovrParameter %>&officeVisitRecordID=<%=original.getOfficeVisitRecordID() %>">
    <div>
        <table width="99%">
            <tr>
                <th>Office Visit Info</th>
            </tr>
            <tr>
                <td><b>Patient:</b> <%= StringEscapeUtils.escapeHtml("" + ( action.getName(original.getPatient()) )) %></td>
            </tr>
        </table>
    </div>

    <table width="99%">
        <tr><td>
            <b>Weight Gain: </b>
            <input type="text" name="weightGain" value="<%=StringEscapeUtils.escapeHtml("" + original.getWeightGain())%>" />
        </td></tr>
        <tr><td>
            <b>High Blood Pressure: </b>
            <input type="text" name="highbloodPressure" value="<%=StringEscapeUtils.escapeHtml("" + original.getHighBloodPressure())%>" />
        </td></tr>
        <tr><td>
            <b>Low Blood Pressure: </b>
            <input type="text" name="lowbloodPressure" value="<%=StringEscapeUtils.escapeHtml("" + original.getLowBloodPressure())%>" />
        </td></tr>
        <tr><td>
            <b>Fetal Heart Rate: </b>
            <input type="text" name="fetalHeartRate" value="<%=StringEscapeUtils.escapeHtml("" + original.getFetalHeartRate())%>" />
        </td></tr>
        <tr><td>
            <b>Number of Pregnancy: </b>
            <input type="text" name="numberOfPregnancy" value="<%=StringEscapeUtils.escapeHtml("" + original.getNumberOfPregnancy())%>" />
        </td></tr>
        <tr><td>
            <b>Low Lying Placenta: </b>
            <select name="lowLyingPlacenta">
<%
                String LLP = "";
                for (int i = 0; i < 2; i++) {
                    if (i == 0) {
                        LLP = "true";
                    } else {
                        LLP = "false";
                    }
                    selected = LLP.equals("true") ^ !original.getLowLyingPlacenta();
%>
                    <option <%=selected?"selected ":"" %>value="<%=LLP%>"><%= StringEscapeUtils.escapeHtml("" + LLP) %></option>
<%
                }
%>
            </select>
        </td></tr>
    </table>

    <input type="hidden" id="editOfficeVisitRecord" name="editOfficeVisitRecord" value=""/>
    <input type="submit" value="Change" name="editOfficeVisitRecordButton" id="changeButton" onClick="document.getElementById('editOfficeVisitRecord').value='Change'"/>

    <input type="hidden" id="override" name="override" value="noignore"/>
</form>
<%
    }
%>

<%@include file="/footer.jsp" %>
