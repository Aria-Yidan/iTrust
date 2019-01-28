<%--
  Created by IntelliJ IDEA.
  User: jaewooklee
  Date: 11/16/18
  Time: 3:00 AM
  To change this template use File | Settings | File Templates.
--%>
<%@taglib prefix="itrust" uri="/WEB-INF/tags.tld" %>
<%@page errorPage="/auth/exceptionHandler.jsp" %>

<%@page import="java.util.List"%>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.Role" %>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.TravelHistoryDAO" %>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.TravelHistoryBean" %>
<%@page import="edu.ncsu.csc.itrust.exception.DBException" %>
<%@page import="java.util.Date" %>
<%@page import="edu.ncsu.csc.itrust.DateUtil" %>
<%@page import="java.lang.StringBuilder"%>
<%@include file="/global.jsp" %>

<%
    pageTitle = "iTrust - Edit Travel History";
%>
<%@include file="/header.jsp" %>
<itrust:patientNav thisTitle="Edit Travel History" />
<br />
<%
    // Prompt User MID
    boolean active = false;
    String pidString = (String)session.getAttribute("pid");
    if (pidString == null || 1 > pidString.length()) {
        response.sendRedirect("/iTrust/auth/getPatientID.jsp?forward=hcp/editTravelHistory.jsp");
        return;
    }

    Role role = authDAO.getUserRole(Long.parseLong(pidString));
    if (role != Role.PATIENT) {
%>
<div align=center>
    <h3 class="iTrustError">
        Cannot Edit. <%=authDAO.getUserName(Long.parseLong(pidString))%> is not a patient.
    </h3>
</div>
<%
        return;
    }
    long MID = Long.parseLong(pidString);
    TravelHistoryDAO action = new TravelHistoryDAO(prodDAO);
    List<TravelHistoryBean> travelHistories = null;
    try {
        travelHistories = action.getTravelHistoriesByMID(MID);
    } catch (DBException e) {
%>
<div align=center>
    <span class="iTrustError"><%=StringEscapeUtils.escapeHtml(e.getMessage()) %></span>
</div>
<br />
<%
        return;
    }

    if (travelHistories.size() == 0) {
%>
<div align=center>
    <h1>No Travel History for <%=authDAO.getUserName(MID)%></h1>
</div>
<%
} else {
    Date startDate = null;
    Date endDate = null;
    String cities = null;
    int i = 1;
%>
<div align=center>
    <h1>Travel History for <%=authDAO.getUserName(MID)%></h1>
</div>

<table class="fTable" align="center">
    <tr class="subHeader">
        <td>#</td>
        <td>Start Date</td>
        <td>End Date</td>
        <td>Travelled Cities</td>
    </tr>
    <%
        for (TravelHistoryBean travelHistory : travelHistories) {
            startDate = travelHistory.getStartDate();
            endDate = travelHistory.getEndDate();
            cities = travelHistory.getTravelledCities();
            String[] splited = cities.split("&");
    %>
    <tr>
        <td><%=i++%></td>
        <th><%=DateUtil.dateToSimpleDate(startDate)%></th>
        <th><%=DateUtil.dateToSimpleDate(endDate)%></th>
        <th>
            <%
                for (String city : splited) {
            %>
            <%=city%>
            <br />
            <%
                }
            %>
        </th>
    </tr>
    <%
        }
    %>

</table>

<%
    }

%>
<br />
<div align=center>
    <%--<form method="get" action="addTravelHistory.jsp">--%>
    <%--<input type="submit" value="Add Travel History" style="font-size: 16pt; font-weight: bold;">--%>
    <%--</form>--%>
    <a href="addTravelHistory.jsp?patientMID=<%=pidString%>" style="font-size: 16pt; font-weight: bold;">Add Travel History</a>
</div>

<br />
<br />
<itrust:patientNav thisTitle="Edit Travel History" />
<%@include file="/footer.jsp" %>