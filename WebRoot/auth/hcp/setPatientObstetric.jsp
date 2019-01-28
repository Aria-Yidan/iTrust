<%--
  Created by IntelliJ IDEA.
  User: roger
  Date: 11/10/18
  Time: 1:55 AM
  To change this template use File | Settings | File Templates.
--%>
<%@include file="/global.jsp" %>
<%@page import="java.util.List" %>
<%@page import="edu.ncsu.csc.itrust.action.SearchUsersAction" %>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.PatientBean" %>

<%
    pageTitle = "iTrust - Please Select a Patient";
%>

<%@include file="/header.jsp" %>

<%
    String uid_pid = request.getParameter("UID_PATIENTID");
    session.setAttribute("pid", uid_pid);
    if (null != uid_pid && !"".equals(uid_pid)) {
        response.sendRedirect(request.getParameter("forward"));
    }

    String firstName = request.getParameter("FIRST_NAME");
    String lastName = request.getParameter("LAST_NAME");
    if(firstName == null)
        firstName = "";
    if(lastName == null)
        lastName = "";


    boolean isAudit = request.getParameter("forward") != null && request.getParameter("forward").contains("hcp/auditPage.jsp");
%>

<%@include file="/util/getUserFrame.jsp"%>
