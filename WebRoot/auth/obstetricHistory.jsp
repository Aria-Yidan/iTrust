<%--
  Created by IntelliJ IDEA.
  User: roger
  Date: 11/13/18
  Time: 9:09 PM
  To change this template use File | Settings | File Templates.
--%>
<%@include file="/global.jsp" %>
<%@page import="javax.servlet.http.HttpServletRequest" %>
<%@page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="javax.servlet.http.HttpUtils.*" %>


<%@page import="java.util.List" %>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.DAOFactory" %>
<%@page import="edu.ncsu.csc.itrust.action.SearchUsersAction" %>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.PatientBean" %>

<%@page import="edu.ncsu.csc.itrust.model.old.beans.PregnancyBean" %>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.PregnancyDAO" %>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.ObstetricsInitRecordBean" %>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.ObstetricsInitRecordDAO" %>

<%@page import="edu.ncsu.csc.itrust.model.old.beans.loaders.ObstetricsInitRecordBeanLoader" %>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.loaders.PregnancyBeanLoader" %>
<%@page import="edu.ncsu.csc.itrust.action.ObstetricHistoryAction" %>






<%
    pageTitle = "iTrust - Please Select a Patient";
%>

<%@include file="/header.jsp" %>

<%
    String uid_pid = request.getParameter("UID_PATIENTID");
    Long pid = uid_pid == null ? null : Long.parseLong(uid_pid);

    // Log in view obstetric action
    // TransactionType type, long loggedInMID, long secondaryMID, String addedInfo
    loggingAction.logEvent(TransactionType.VIEW_INITIAL_OBSTETRICS_RECORD,loggedInMID ,pid, "Viewed obstetric initialized record, EDD, Patient Viewable=YES");
    System.out.println("Logged In MID:" + loggedInMID + "- VIEWED INITOBSTETRIC!");


    session.setAttribute("pid", uid_pid);

    String firstName = request.getParameter("FIRST_NAME");
    String lastName = request.getParameter("LAST_NAME");
    if(firstName == null)
        firstName = "";
    if(lastName == null)
        lastName = "";

    // used to identify if HCP is of OB or GYN -> To create buttons for creation of Obstetric Initializations
    SearchUsersAction sua = new SearchUsersAction(DAOFactory.getProductionInstance(), -1);
    boolean hcpIsOBGYN = loggedInMID != null ? sua.isOBGYNHCP(loggedInMID) : false;



    ObstetricHistoryAction oba = new ObstetricHistoryAction(DAOFactory.getProductionInstance());
    List<ObstetricsInitRecordBean> obstetricInitHistoryList = oba.getPatientObstericsInitRecords(pid);

    List<PregnancyBean> pregnancyHistoryList = oba.getAllPregnancy(pid);
%>
<div>

    <div>
        <h1>
        Patient Maid: <%= uid_pid %>
    </h1>
        <p>
            <% if (obstetricInitHistoryList.size() == 0) { %>
            <span style="color: orangered">There are <bold><em>0</em></bold> records</span>
            <% } else { %>
            Total Obstetric Initialize Records: <%=obstetricInitHistoryList.size()%> <br>
            Total Pregnancy Records: <%=pregnancyHistoryList.size()%>
            <% } %>
        </p>

        <% if (hcpIsOBGYN) { // button of obstetric initialize records will appear if the hcp is of OB/GYN speciality
            String requestURI = request.getRequestURI();
            String currentURL = javax.servlet.http.HttpUtils.getRequestURL(request).toString();

            int serverSubstringEndIndex = currentURL.indexOf(requestURI);

            String serverURI = currentURL.substring(0, serverSubstringEndIndex);

            StringBuilder linkURLSB = new StringBuilder(serverURI);
            linkURLSB.append("/iTrust/auth/hcp/initObstetricRecord.jsp");

        %>

            <div>
                <input type='button' style='width:250px;' onclick="location.href='<%= linkURLSB.toString() %>'" value="Initialize Obstetric Record">
            </div>

        <% } %>
    </div>
</div>

<div id="obstetricInitRecord" style="float:left">
    <table style="width:50%">
        <tr>
            <th colspan="4"  style="text-align:center; color:blue">Obstetric Init Record</th>
        </tr>
        <tr>
            <th>&nbsp&nbsp</th>
            <th>LMP</th>
            <th>EDD</th>
            <th>Weeks of Pregnancy</th>
            <th>Time of Record</th>
        </tr>


<%
    for (int i = 0; i < obstetricInitHistoryList.size(); i++) {
        ObstetricsInitRecordBean b = obstetricInitHistoryList.get(i);
%>
        <tr>
            <td><%=i + 1%>.</td>
            <td><%= b.getLMP() %></td>
            <td><%= b.getEDD() %></td>
            <td><%= b.getWeeksOfPregnant() %></td>
            <td><%= StringEscapeUtils.escapeHtml("" + b.getRecordCreatedTime()) %></td>
        </tr>
<%
    }
%>
    </table>
</div>

<div id="pregnancyRecord" style="float:left">
    <table style="width:50%">
        <tr>
            <th colspan="4"  style="text-align:center; color:palevioletred">Pregnancy Record</th>
        </tr>
        <tr>
            <th>&nbsp&nbsp</th>
            <th>Conception Year</th>
            <th>Pregnancy Weeks</th>
            <th>Labor Hours</th>
            <th>Weight Gain</th>
            <th>Delivery Type</th>
            <th>Pregnancy Number</th>
            <th>Is Multiple Pregnancy</th>
        </tr>
        <%
            for (int i = 0; i < pregnancyHistoryList.size(); i++) {
                PregnancyBean p = pregnancyHistoryList.get(i);
        %>
            <tr>
                <td><%=i + 1%>.</td>
                <td><%= p.getYearOfConception() %></td>
                <td><%= p.getWeeksOfPregnant() %></td>
                <td><%= p.getHoursInLabor() %></td>
                <td><%= p.getWeightGain() %></td>
                <td><%= p.getDeliveryType() %></td>
                <td><%= p.getPregnancyNumber() %></td>
                <%
                boolean hasMultiplePregnancy = p.getPregnancyNumber() > 1;
                %>
                <td><%= hasMultiplePregnancy %></td>
            </tr>
        <%
            }
        %>


    </table>
</div>

<%@include file="/footer.jsp" %>
