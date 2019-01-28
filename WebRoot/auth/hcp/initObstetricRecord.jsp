<%--
  Created by IntelliJ IDEA.
  User: roger
  Date: 11/14/18
  Time: 10:24 PM
  To change this template use File | Settings | File Templates.
--%>
<%@taglib prefix="itrust" uri="/WEB-INF/tags.tld"%>
<%@page errorPage="/auth/exceptionHandler.jsp"%>

<%@page import="edu.ncsu.csc.itrust.model.old.dao.DAOFactory"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.PatientBean"%>
<%@page import="edu.ncsu.csc.itrust.action.EditPatientAction"%>
<%@page import="edu.ncsu.csc.itrust.BeanBuilder"%>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.Ethnicity"%>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.BloodType"%>
<%@page import="edu.ncsu.csc.itrust.exception.FormValidationException"%>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.Gender"%>

<%@page import="java.util.List" %>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.DAOFactory" %>
<%@page import="edu.ncsu.csc.itrust.action.SearchUsersAction" %>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.PatientBean" %>

<%@page import="edu.ncsu.csc.itrust.model.old.beans.PregnancyBean" %>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.PregnancyDAO" %>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.ObstetricsInitRecordBean" %>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.ObstetricsInitRecordDAO" %>
<%@page import="edu.ncsu.csc.itrust.model.old.validate.ObstetricsInitRecordBeanValidator" %>

<%@page import="edu.ncsu.csc.itrust.model.old.beans.loaders.ObstetricsInitRecordBeanLoader" %>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.loaders.PregnancyBeanLoader" %>
<%@page import="edu.ncsu.csc.itrust.action.ObstetricHistoryAction" %>

<%@page import="java.time.format.DateTimeFormatter" %>
<%@page import="java.time.LocalDateTime" %>
<%@page import="java.time.LocalDate" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="java.time.temporal.ChronoUnit" %>


<%@include file="/global.jsp"%>

<%
    pageTitle = "iTrust - Initialize Obstetric Patient Obstetric Record";
%>

<%@include file="/header.jsp"%>
<itrust:patientNav thisTitle="Demographics" />
<%
    /* Require a Patient ID first */
    String pidString = (String) session.getAttribute("pid");
    // For reloading -> Calling the same page of itself recursively when needed
    String LMPDateString = request.getParameter("dateOfBirthStr");


    boolean LMPDateStringIsNull = LMPDateString == null;


    // count of form submits to pass to itself recursively when calling this page after each form submission
    String clickCount = request.getParameter("submitCount");
    System.out.println("+++++++++" + clickCount + "++++++++++");
    int count;
    if (clickCount == null) {
        count = 0;
    } else {
        count = Integer.parseInt(clickCount);
    }
    count++;



    StringBuilder FormSubmitAction = new StringBuilder("initObstetricRecord.jsp?submitCount=");
    FormSubmitAction.append(Integer.toString(count));

    System.out.println(FormSubmitAction.toString() + "___________");


    Long pid = pidString == null ? null : Long.parseLong(pidString);

    if (pidString == null || pidString.equals("") || 1 > pidString.length()) {
        out.println("pidstring is null");
        response.sendRedirect("/iTrust/auth/getPatientInfo.jsp?forward=hcp/getPatientInfo.jsp"); //
        return;
    }


    /* Now take care of updating information */

    boolean formIsFilled = request.getParameter("formIsFilled") != null
            && request.getParameter("formIsFilled").equals("true");


    // Updating obstetric history through ObstetricHistoryAction //
    ObstetricHistoryAction oba = new ObstetricHistoryAction(DAOFactory.getProductionInstance());


    // Accessing latest preganancy history data for display in the prepopulated form
    List<PregnancyBean> pregnancyHistoryList = oba.getAllPregnancy(pid);
    PregnancyBean mostRecentPregnancy = null;
    if (pregnancyHistoryList.size() > 0) {
        mostRecentPregnancy = pregnancyHistoryList.get(0);
    }

%>

<p style="text-align: center;">After submission, record would be updated in the database <br>
    <span style="color:blue">Server will redirect back to patient's (MID: <%=pidString%>) obstetric record history shortly in 2 seconds...</span></p>
<form id="editForm" action="<%=FormSubmitAction.toString()%>" method="post"><input type="hidden" action="<%=FormSubmitAction.toString()%>"
                                                                  name="formIsFilled" value="true"> <br />
    <table cellspacing=0 align=center cellpadding=0>
        <tr>
            <td width="15px">&nbsp;</td>
            <td valign=top>

                <table class="fTable" align=center style="width: 350px;">
                    <tr>
                        <th colspan=2>Obstetric Initialize Information</th>
                    </tr>
                    <%
                        // Time and Date related!
                        // Java 8 approach
                        DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("MM/dd/yyyy");

                        LocalDate todaysDate = LocalDate.now();

                        String formattedTodaysDate = todaysDate.format(DATE_FORMAT);

                    %>
                    <tr>
                        <td class="subHeaderVertical">LMP:</td>
                            <td>
                                <input type=text name="dateOfBirthStr" maxlength="10"
                                       size="10" id="LMPvalue"
                                        <% String LMPValue = LMPDateStringIsNull ? formattedTodaysDate : LMPDateString; %>
                                       value="<%= StringEscapeUtils.escapeHtml("" + LMPValue) %>">
                                <input
                                        type=button value="Select Date"
                                        onclick="displayDatePicker('dateOfBirthStr');">
                                <a href="" onclick="location.href = $(this).attr('href')+'?dateOfBirthStr=' + document.getElementById('LMPvalue').value;return false;">Update EDD</a>
                            </td>
                    </tr>
                    <%
                        LocalDate LMPDate;
                        if (LMPDateStringIsNull) {
                            LMPDate = LocalDate.now();
                        } else {
                            // LMP date is passed back as string and parsed from string into LocalDate type for further calculation
                            DateTimeFormatter DATE_FORMAT_INPUT = DateTimeFormatter.ofPattern("MM/dd/yyyy");
                            LMPDate = LocalDate.parse(LMPDateString, DATE_FORMAT_INPUT);
                        }

                        LocalDate EDD = LMPDate.plusDays(280);
                        String formattedEDD = EDD.format(DATE_FORMAT);
                    %>
                    <tr>
                        <td class="subHeaderVertical">EDD:</td>
                        <td>
                            <input name="EDD"
                                   value="<%=formattedEDD%>" type="text" size="12" maxlength="12">
                        </td>
                    </tr>
                    <%

                        Long totalDaysOfPregnancy = ChronoUnit.DAYS.between(LMPDate, todaysDate);
                        Long weeks = totalDaysOfPregnancy / 7;
                        Long  days = totalDaysOfPregnancy % 7;
                    %>
                    <tr>
                        <td class="subHeaderVertical">Weeks Pregnant:</td>
                        <td>
                            <input name="weeksPregnant"
                                   <% String weeksPregnant = weeks.toString() + "-" + days.toString(); %>
                                   value="<%=weeksPregnant%>" type="text" size="12" maxlength="12">
                        </td>
                    </tr>
                    <tr>
                        <td class="subHeaderVertical">Record Created Date:</td>
                        <td>
                            <input name="recordeCreatedDate"
                                   value="<%=todaysDate%>" type="text" size="12" maxlength="12">
                        </td>

                    </tr>
                </table>

                <br />

                <table class="fTable" align=center style="width: 350px;">
                    <tr>
                        <th colspan=2>Pregnancy Information</th>
                    </tr>

                    <tr>
                        <td class="subHeaderVertical">Year of Conception:</td>
                        <td><input name="yearOfConception"
                                   <%String yearOfConception = mostRecentPregnancy == null ? "" : Integer.toString(mostRecentPregnancy.getYearOfConception()); %>
                                   value="<%= yearOfConception %>" type="text"></td>
                    </tr>
                    <tr>
                        <td class="subHeaderVertical">Weeks of Pregnancy:</td>
                        <td>
                        <%String weekOfPregnancy = mostRecentPregnancy == null ? "" : mostRecentPregnancy.getWeeksOfPregnant(); %>
                        <%
                            String week = "";
                            String day = "";
                            if (!weekOfPregnancy.equals("")) {
                                String[] weekDayStringArray = weekOfPregnancy.split("-");
                                week = weekDayStringArray[0];
                                day = weekDayStringArray[1];
                            }
                        %>
                            <select name="weeksOfPregnancy">
                                <% if (!weekOfPregnancy.equals("")) { %>
                                    <option value="<%=week%>"><%=week%></option>
                                    <% for (int i = 0; i <= 42; i++) { %>
                                        <option value="<%=Integer.toString(i)%>"><%=i%></option>
                                    <%}%>
                                <%} else {%>
                                    <option value="">Select:</option>
                                    <% for (int i = 0; i <= 42; i++) { %>
                                        <option value="<%=Integer.toString(i)%>"><%=i%></option>
                                    <%}%>
                                <%}%>
                            </select>
                            -
                            <select name="daysOfPregnancy">
                                <% if (!day.equals("")) { %>
                                    <option value="<%=day%>"><%=day%></option>
                                    <% for (int i = 0; i <= 6; i++) { %>
                                        <option value="<%=Integer.toString(i)%>"><%=i%></option>
                                    <%}%>
                                <%} else {%>
                                    <option value="">Select:</option>
                                    <% for (int i = 0; i <= 6; i++) { %>
                                        <option value="<%=Integer.toString(i)%>"><%=i%></option>
                                    <%}%>
                                <%}%>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="subHeaderVertical">Hours In Labor:</td>
                        <td>
                            <input name="hoursInLabor"
                                    <%String hoursInLabor = mostRecentPregnancy == null ? "" : Double.toString(mostRecentPregnancy.getHoursInLabor()); %>
                                   value="<%= hoursInLabor %>" type="text" size="12" maxlength="12">
                        </td>
                    </tr>
                    <tr>
                        <td class="subHeaderVertical">Weight Gain:</td>
                        <td>
                            <input name="weightGain"
                                    <%String weightGain = mostRecentPregnancy == null ? "" : Double.toString(mostRecentPregnancy.getWeightGain()); %>
                                   value="<%= weightGain %>" type="text" size="12" maxlength="12">
                        </td>
                    </tr>
                    <tr>
                        <td class="subHeaderVertical">Delivery Type:</td>
                        <%String deliveryType = mostRecentPregnancy == null ? "" : mostRecentPregnancy.getDeliveryType(); %>
                        <td>
                            <select name="deliveryType">
                                <% if (!deliveryType.equals("")) { %>
                                    <option value="<%=deliveryType%>"><%=deliveryType%></option>
                                    <option value="vaginal delivery">Vaginal Delivery</option>
                                    <option value="vaginal delivery vacuum assist">Vaginal Delivery Vacuum Assist</option>
                                    <option value="vaginal delivery forceps assist">Vaginal Delivery Forceps Assist</option>
                                    <option value="caesarean section">Caesarean Section</option>
                                    <option value="miscarriage">Miscarriage</option>
                                <%} else {%>
                                <option value="">Select:</option>
                                <option value="vaginal delivery">Vaginal Delivery</option>
                                <option value="vaginal delivery vacuum assist">Vaginal Delivery Vacuum Assist</option>
                                <option value="vaginal delivery forceps assist">Vaginal Delivery Forceps Assist</option>
                                <option value="caesarean section">Caesarean Section</option>
                                <option value="miscarriage">Miscarriage</option>
                                <%}%>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="subHeaderVertical">Pregnancy Numer:</td>
                        <td>
                            <input name="pregnancyNumber"
                                <%String pregnancyNumber = mostRecentPregnancy == null ? "" : Integer.toString(mostRecentPregnancy.getPregnancyNumber()); %>
                                   value="<%= pregnancyNumber %>" type="text" size="12" maxlength="12">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <br />

    <div align=center>
        <input type="submit" name="action" style="font-size: 16pt; font-weight: bold;" value="Edit Patient Record">
        <%
            if (formIsFilled) {
%>
                <div align=center>
                    <span class="iTrustMessage">Obstetric Initialized for Patient MID : <%=pidString%></span> <br>
                    <span style="color:blue">Server will redirect back to patient obstetric record history shortly in 2 seconds...</span>
                    </div>
                <br />
<%
                int initializationRecord = oba.initializationObstetricRecord(pidString, LMPValue, formattedEDD, weeksPregnant);
                if (initializationRecord != -1) {
                    System.out.println("Init Record Success~!");
                }

                yearOfConception = request.getParameter("yearOfConception");
                String weekString = request.getParameter("weeksOfPregnancy");
                String dayString = request.getParameter("daysOfPregnancy");
                weekOfPregnancy = weekString + "-" + dayString;



                hoursInLabor = request.getParameter("hoursInLabor");
                weightGain = request.getParameter("weightGain");
                deliveryType = request.getParameter("deliveryType");

                pregnancyNumber = request.getParameter("pregnancyNumber");


                int addPregnanacyInfo = oba.addPregnancyInformation(pidString, yearOfConception, weekOfPregnancy, hoursInLabor, weightGain, deliveryType, pregnancyNumber);


                if (addPregnanacyInfo != -1) {
                    System.out.println("Pregnancy record Success!");
                }
            }
        %>
    </div>
</form>


<br />
<br />

<itrust:patientNav thisTitle="Demographics" />

<%@include file="/footer.jsp"%>
<%
            if (count > 1) {
                // Obtain the page of the current MID patient's obstetric history view URL
                String requestURI = request.getRequestURI();
                System.out.println(requestURI);
                String currentURL = javax.servlet.http.HttpUtils.getRequestURL(request).toString();
                System.out.println(currentURL);
                int serverSubstringEndIndex = currentURL.indexOf(requestURI);

                String serverURI = currentURL.substring(0, serverSubstringEndIndex);

                StringBuilder linkURLSB = new StringBuilder(serverURI);
                linkURLSB.append("/iTrust/auth/obstetricHistory.jsp?UID_PATIENTID=").append(pidString);
                // log action into transactionlog database table
                loggingAction.logEvent(TransactionType.CREATE_INITIAL_OBSTETRICS_RECORD,loggedInMID ,pid, "Created obstetric initialized record for patient, EDD, Patient Viewable=YES");
                System.out.println("Logged In" + loggedInMID + " CREATED INITOBSTETRIC!");


                // After successfully update, wait for 2 seconds before redirecting back to the patient's obstetric history list
                Thread.sleep(1500); // sleep 1.5 seconds
                String redirectURL = linkURLSB.toString();
                response.sendRedirect(redirectURL);
            }
%>



