<%--
  Created by IntelliJ IDEA.
  User: jaewooklee
  Date: 11/16/18
  Time: 3:00 AM
  To change this template use File | Settings | File Templates.
--%>
<%@taglib prefix="itrust" uri="/WEB-INF/tags.tld" %>
<%@page errorPage="/auth/exceptionHandler.jsp" %>

<%@include file="/global.jsp" %>

<%
    pageTitle = "iTrust - Add Travel History";
%>
<%@include file="/header.jsp" %>
<itrust:patientNav thisTitle="Add Travel History" />
<br />
<%
    String pidString = request.getParameter("patientMID");
%>
<form method="post" action="addTravelHistoryToDB.jsp?patientMID=<%=pidString%>">
    Starting Date(Format: "yyyy-MM-dd"):<br>
    <input type="date" name="startDate">
    <br>
    Ending Date(Format: "yyyy-MM-dd"):<br>
    <input type="date" name="endDate">
    <br>
    Travelled Cities(Format: "city,country & city,country & ..."):<br>
    <input type="text" name="travelledCities">
    <br><br>
    <div align="center">
        <input type="submit" value="Add Travel History">
    </div>

</form>
<br />
<br />
<itrust:patientNav thisTitle="Add Travel History" />
<%@include file="/footer.jsp" %>