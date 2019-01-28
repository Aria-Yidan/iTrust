<%--
  Created by IntelliJ IDEA.
  User: jaewooklee
  Date: 11/16/18
  Time: 3:25 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="edu.ncsu.csc.itrust.model.old.validate.TravelHistoryBeanValidator" %>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.TravelHistoryBean" %>
<%@page import="java.util.Date" %>
<%@page import="edu.ncsu.csc.itrust.DateUtil" %>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.TravelHistoryDAO" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="edu.ncsu.csc.itrust.exception.FormValidationException" %>
<%@include file="/global.jsp" %>
<%
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");
    String travelledCities = request.getParameter("travelledCities");
    Date start = null;
    Date end = null;
    try {
        start = DateUtil.stringToDate(startDate);
        end = DateUtil.stringToDate(endDate);
    } catch (ParseException e) {
        e.printStackTrace();
    }

    String pidString = request.getParameter("patientMID");
    TravelHistoryBean newTravelHistory = new TravelHistoryBean(Long.parseLong(pidString), new java.sql.Date(start.getTime()), new java.sql.Date(end.getTime()), travelledCities);
    TravelHistoryBeanValidator validator = new TravelHistoryBeanValidator();
    try {
        validator.validate(newTravelHistory);
    } catch (FormValidationException e) {
        e.printStackTrace();
    }

    TravelHistoryDAO action = new TravelHistoryDAO(prodDAO);
    action.addTravelHistory(newTravelHistory);

%>
<div align="center">
    <span style="color::green; font-size: 16pt; font-weight: bold;">Succesfully Added</span><br>
    <a href="addTravelHistory.jsp?patientMID=<%=pidString%>" style="font-size: 16pt; font-weight: bold;">Add More Travel History</a><br>
    <a href="editTravelHistory.jsp?patientMID=<%=pidString%>" style="font-size: 16pt; font-weight: bold;">Back to Patient Travel History</a><br>

</div>
