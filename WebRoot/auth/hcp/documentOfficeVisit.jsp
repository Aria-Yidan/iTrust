<%@page import="java.text.ParseException"%>
<%@page errorPage="/auth/exceptionHandler.jsp"%>
<%@page import="java.lang.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.OfficeVisitRecordBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.PatientBean"%>
<%@page import="edu.ncsu.csc.itrust.action.AddOfficeVisitRecordAction"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.PatientDAO"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.PersonnelDAO"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.OfficeVisitRecordDAO"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.ObstetricsInitRecordDAO"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.ObstetricsInitRecordBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.BloodType"%>
<%@page import="edu.ncsu.csc.itrust.exception.ITrustException"%>
<%@page import="edu.ncsu.csc.itrust.exception.FormValidationException"%>
<%@page import="java.time.format.DateTimeFormatter" %>
<%@page import="java.time.LocalDateTime" %>
<%@page import="java.time.LocalDate" %>
<%@page import="java.time.temporal.ChronoUnit" %>
<%@page import="edu.ncsu.csc.itrust.logger.TransactionLogger" %>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.TransactionType" %>

<%@include file="/global.jsp" %>


<%
    pageTitle = "iTrust - Document an Office Visit";

    String headerMessage = "Please fill out the form properly - all entries are required.";

    String noticeMessage = "";
%>

<%@include file="/header.jsp" %>

<form id="mainForm" method="post" action="documentOfficeVisit.jsp">
<%
    AddOfficeVisitRecordAction action = new AddOfficeVisitRecordAction(prodDAO, loggedInMID.longValue());
    PatientDAO patientDAO = prodDAO.getPatientDAO();
    ObstetricsInitRecordDAO obstetricsInitRecordDAO = prodDAO.getObstetricsInitRecordDAO();
    PersonnelDAO personnelDAO = prodDAO.getPersonnelDAO();
    long patientID = 0L;
    boolean error = false;
    String weeksOfPregnant="20-01";
    boolean isObstetrics = false;
    String hidden = "";

    if (session.getAttribute("pid") != null) {
        String pidString = (String) session.getAttribute("pid");
        System.out.println("pid is: " + pidString);
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
        response.sendRedirect("/iTrust/auth/getPatientID.jsp?forward=hcp/documentOfficeVisit.jsp");
    } else {
        System.out.println("isOBGYNHCP:" + loggedInMID);
        System.out.println("personnelDAO.isOBGYNHCP(loggedInMID):" + personnelDAO.isOBGYNHCP(loggedInMID));
        if (!personnelDAO.isOBGYNHCP(loggedInMID)) {
%>
    <div align=center>
        <span class="iTrustError">Not a HCP with the OB/GYN specialization! Can only create a regular office visit!</span>
        <br />
        <a href="/iTrust/auth/getPatientID.jsp?forward=hcp/documentOfficeVisit.jsp">Back</a>		</div>
    <%
    } else {
        ObstetricsInitRecordBean ob = null;
        PatientBean patient = null;
        patient = patientDAO.getPatient(patientID);
        LocalDate currentDate;
        LocalDate cmpDate;
        LocalDate lmpDate;
        DateTimeFormatter DATE_FORMAT_INPUT = DateTimeFormatter.ofPattern("MM/dd/yyyy");
        Boolean eligible = Integer.parseInt(patient.getObstetricEligible()) == 1? true:false;
        if (eligible){
            if (!obstetricsInitRecordDAO.getAllObstetricsInitRecord(patientID).isEmpty()) {
                ob = obstetricsInitRecordDAO.getAllObstetricsInitRecord(patientID).get(0);
                String lmp = ob.getLMP();
                lmpDate = LocalDate.parse(lmp, DATE_FORMAT_INPUT);
                cmpDate = lmpDate.plusDays(343);
                currentDate = LocalDate.now();
                long daysBetween = ChronoUnit.DAYS.between(lmpDate, currentDate);
                long weeks = daysBetween / 7;
                long days = daysBetween % 7;
                weeksOfPregnant = Long.toString(weeks) + '-' + Long.toString(days);
                if (currentDate.compareTo(cmpDate) < 0) {
                    isObstetrics = true;
                }
            }
        }

        System.out.println("isObstetrics:" + isObstetrics);
        String weightGain="";
        String lowLyingPlacenta="";
        String highbloodPressure="";
        String lowbloodPressure="";
        String fetalHeartRate="";
        String numberOfPregnancy="";


        if(!isObstetrics){
    %>
    <div align=center>
        <span class="iTrustError">Not a current obstetrics patient! Please try again!</span>
        <br />
        <a href="/iTrust/auth/getPatientID.jsp?forward=hcp/documentOfficeVisit.jsp">Back and try again</a>		</div>
    <%
    }else{
            if (request.getParameter("officeVisitRecord") != null) {

            if(request.getParameter("weightGain").equals(""))
                headerMessage = "Please input weight gain.";

            else if(request.getParameter("lowLyingPlacenta").equals(""))
                headerMessage = "Please input Low Lying Placenta";
            else if(request.getParameter("highbloodPressure").equals(""))
                headerMessage = "Please input High Blood Pressure";
            else if(request.getParameter("lowbloodPressure").equals(""))
                headerMessage = "Please input Low Blood Pressure";
            else if(request.getParameter("fetalHeartRate").equals(""))
                headerMessage = "Please input Fetal Heart Rate";
            else if(request.getParameter("numberOfPregnancy").equals(""))
                headerMessage = "Please input Number Of Pregnancy";
            else {
                weightGain = request.getParameter("weightGain");
                lowLyingPlacenta = request.getParameter("lowLyingPlacenta");
                highbloodPressure = request.getParameter("highbloodPressure");
                lowbloodPressure = request.getParameter("lowbloodPressure");
                fetalHeartRate = request.getParameter("fetalHeartRate");
                numberOfPregnancy = request.getParameter("numberOfPregnancy");
                OfficeVisitRecordBean ovrecord = new OfficeVisitRecordBean();
                ovrecord.setHcp(loggedInMID);
                ovrecord.setPatient(patientID);
                ovrecord.setWeeksOfPregnant(weeksOfPregnant);
                Date date = new Date();
                ovrecord.setLowLyingPlacenta(Boolean.parseBoolean(lowLyingPlacenta));
                ovrecord.setCurrentDate(new Timestamp(date.getTime()));
                double weightGainD = 0;
                double highbloodPressureD = 0;
                double lowbloodPressureD = 0;
                double fetalHeartRateD = 0;
                int numberOfPregnancyI = 0;
                try{
                    weightGainD = Double.parseDouble(weightGain);
                    highbloodPressureD = Double.parseDouble(highbloodPressure);
                    lowbloodPressureD = Double.parseDouble(lowbloodPressure);
                    fetalHeartRateD = Double.parseDouble(fetalHeartRate);
                    numberOfPregnancyI = Integer.parseInt(numberOfPregnancy);
                } catch (NumberFormatException nfe){
                    error = true;
                }
                if (error){
                    headerMessage = "Invalid Value!";
                }else{
                    String bloodType = "";
                    ovrecord.setWeightGain(weightGainD);
                    ovrecord.setHighBloodPressure(highbloodPressureD);
                    ovrecord.setLowBloodPressure(lowbloodPressureD);
                    ovrecord.setFetalHeartRate(fetalHeartRateD);
                    ovrecord.setNumberOfPregnancy(numberOfPregnancyI);
                    try {
                        headerMessage = action.addOfficeVisitRecord(ovrecord, false);
                        if(headerMessage.startsWith("Success")) {
                            TransactionLogger.getInstance().logTransaction(TransactionType.OFFICE_VISIT_RECORD_ADD,
                                    loggedInMID, patientID, "" + ovrecord.getOfficeVisitRecordID());
                            bloodType = patientDAO.getPatient(patientID).getBloodType().toString();
                            int weeks = Integer.valueOf(weeksOfPregnant.split("-")[0]);
                            if(!bloodType.equals("N/S") && weeks > 28){
                                String symbol = bloodType.substring(bloodType.length() - 1);
                                if(symbol.equals("-"))
                                    noticeMessage =  "**** Needs RH immune globulin shot if not have yet! ****";
                            }
                            session.removeAttribute("pid");
                        }
                    } catch (FormValidationException e){
    %>
    <div align=center><span class="iTrustError"><%=StringEscapeUtils.escapeHtml(e.getMessage())%></span></div>
    <%
                            }
                        }
                    }
                }



%>
<div align="left" <%=hidden %> id="officeVisitDiv">
    <h2>Document an Office Visit</h2>
    <h4>with <%= StringEscapeUtils.escapeHtml("" + ( action.getName(patientID) )) %> (<a href="/iTrust/auth/getPatientID.jsp?forward=hcp/documentOfficeVisit.jsp">someone else</a>):</h4>
    <span class="iTrustMessage"><%= StringEscapeUtils.escapeHtml("" + (headerMessage )) %></span><br /><br />
    <span class="iTrustMessage"><%= StringEscapeUtils.escapeHtml("" + (noticeMessage )) %></span><br /><br />
    <span>Weight Gain: </span>
    <input style="width: 250px;" type="text" name="weightGain" value="<%= StringEscapeUtils.escapeHtml("" + ( weightGain)) %>" />
    <br /><br />
    <span>High Blood Pressure: </span>
    <input style="width: 250px;" type="text" name="highbloodPressure" value="<%= StringEscapeUtils.escapeHtml("" + ( highbloodPressure)) %>" />
    <br /><br />
    <span>Low Blood Pressure: </span>
    <input style="width: 250px;" type="text" name="lowbloodPressure" value="<%= StringEscapeUtils.escapeHtml("" + ( lowbloodPressure)) %>" />
    <br /><br />
    <span>Fetal Heart Rate: </span>
    <input style="width: 250px;" type="text" name="fetalHeartRate" value="<%= StringEscapeUtils.escapeHtml("" + ( fetalHeartRate)) %>" />
    <br /><br />
    <span>Number of Pregnancy: </span>
    <input style="width: 250px;" type="text" name="numberOfPregnancy" value="<%= StringEscapeUtils.escapeHtml("" + ( numberOfPregnancy)) %>" />
    <br /><br />
    <span>Low Lying Placenta: </span>
    <select name="lowLyingPlacenta">
        <%
            String LLP = "";
            for(int i = 0; i < 2; i++){
                if (i == 0)
                    LLP = "true";
                else
                    LLP = "false";
                %>
                    <option <% if(LLP.toString().equals(lowLyingPlacenta)) out.print("selected='selected'"); %> value="<%=LLP%>"><%= StringEscapeUtils.escapeHtml("" + (LLP)) %></option>
                <%
            }
        %>
    </select>
    <br /><br />
    <input type="submit" value="submit" name="officeVisitRecordButton"/>
    <input type="hidden" value="OfficeVisitRecord" name="officeVisitRecord"/>

    <br />
    <br />
</div>
</form>
<% } }
}
%>

<%@include file="/footer.jsp" %>


