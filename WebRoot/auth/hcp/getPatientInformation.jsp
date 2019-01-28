<%--
  Created by IntelliJ IDEA.
  User: roger
  Date: 11/15/18
  Time: 9:46 PM
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

<%@include file="/global.jsp"%>

<%
    pageTitle = "iTrust - All patient info";
%>

<%@include file="/header.jsp"%>
<itrust:patientNav thisTitle="Demographics" />
<%
    /* Require a Patient ID first */
    String pidString = (String) session.getAttribute("pid");


    if (pidString == null || pidString.equals("") || 1 > pidString.length() || pidString != null) {
        out.println("pidstring is null");
        response.sendRedirect("/iTrust/auth/getPatientInfo.jsp?forward=hcp/getPatientInfo.jsp"); //
        return;
    }
%>
<itrust:patientNav thisTitle="Demographics" />

<%@include file="/footer.jsp"%>


