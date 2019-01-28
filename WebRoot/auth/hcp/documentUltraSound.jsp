<%@page import="java.text.ParseException"%>
<%@page errorPage="/auth/exceptionHandler.jsp"%>
<%@page import="java.lang.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.OfficeVisitRecordBean"%>
<%@page import="edu.ncsu.csc.itrust.model.old.beans.UltraSoundRecordBean"%>
<%@page import="edu.ncsu.csc.itrust.action.AddUltrasoundRecordAction"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.PatientDAO"%>
<%@page import="edu.ncsu.csc.itrust.model.old.dao.mysql.UltraSoundRecordDAO"%>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.BloodType"%>
<%@page import="edu.ncsu.csc.itrust.exception.ITrustException"%>
<%@page import="edu.ncsu.csc.itrust.exception.FormValidationException"%>
<%@ page import = "java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import = "javax.servlet.http.*" %>
<%@ page import = "org.apache.commons.fileupload.*" %>
<%@ page import = "org.apache.commons.fileupload.disk.*" %>
<%@ page import = "org.apache.commons.fileupload.servlet.*" %>
<%@ page import = "org.apache.commons.io.output.*" %>
<%@page import="edu.ncsu.csc.itrust.logger.TransactionLogger" %>
<%@page import="edu.ncsu.csc.itrust.model.old.enums.TransactionType" %>
<%@include file="/global.jsp" %>

<%
    pageTitle = "iTrust - Document an Ultra Sound";

    String headerMessage = "Please fill out the form properly - one ultra sound record for one fetus.";

%>

<%@include file="/header.jsp" %>

<form id="mainForm" method="post" action="documentUltraSound.jsp">
    <%
        AddUltrasoundRecordAction action = new AddUltrasoundRecordAction(prodDAO, loggedInMID.longValue());
        long officeVisitRecordID = 0L;
        boolean error = false;
        String officevisitString="";
        String ovid="";
        boolean exists = false;
        if (request.getParameter("apt") != null) {
            officevisitString = (String) request.getParameter("apt");
            System.out.println("officevisitrecord1:" + officevisitString);
        }
        if (request.getParameter("exists") != null) {
            exists = Boolean.parseBoolean(request.getParameter("exists"));
            System.out.println("exists:" + exists);
        }
        String crownRumpLength="";
        String biparietalDiameter="";
        String headCircumference="";
        String femurLength="";
        String abdominalCircumference="";
        String occipitofromtalDiameter="";
        String humerusLength="";
        String estimatedFetalWeight="";
        String image="image";
        String officevisitID="";
        UltraSoundRecordBean ul = null;

        if (exists) {
            ul = action.getUltrasoundRecord(Long.parseLong(officevisitString));
            crownRumpLength = Double.toString(ul.getCrownRumpLength());
            biparietalDiameter = Double.toString(ul.getBiparietalDiameter());
            headCircumference= Double.toString(ul.getHeadCircumference());
            femurLength= Double.toString(ul.getFemurLength());
            abdominalCircumference= Double.toString(ul.getAbdoCircumference());
            occipitofromtalDiameter= Double.toString(ul.getOcciFrontalDiameter());
            humerusLength= Double.toString(ul.getHumerusLength());
            estimatedFetalWeight= Double.toString(ul.getEstimatedFetalWeight());
        } else {
            if (request.getParameter("filepath") != null){
                image = request.getParameter("filepath");
                System.out.println("image path: " + image);
            }

            if (request.getParameter("ovid") != null){
                ovid = request.getParameter("ovid");
            }

            if(request.getParameter("officevisitID") != null){
                officevisitID= request.getParameter("officevisitID");
            }

            if (request.getParameter("ultraSoundRecord") != null ) {

                UltraSoundRecordBean ulrecord = new UltraSoundRecordBean();
                officeVisitRecordID = Long.parseLong(request.getParameter("ovID"));
                ulrecord.setOfficeVisitID(officeVisitRecordID);
                double crownRumpLengthD = 0;
                double biparietalDiameterD = 0;
                double headCircumferenceD = 0;
                double femurLengthD = 0;
                double abdominalCircumferenceD = 0;
                double occipitofromtalDiameterD = 0;
                double humerusLengthD = 0;
                double estimatedFetalWeightD = 0;
                if (request.getParameter("image") != null)
                    image = request.getParameter("image");

                try{
                    crownRumpLengthD = Double.parseDouble(request.getParameter("crownRumpLength"));
                    biparietalDiameterD = Double.parseDouble(request.getParameter("biparietalDiameter"));
                    headCircumferenceD = Double.parseDouble(request.getParameter("headCircumference"));
                    femurLengthD = Double.parseDouble(request.getParameter("femurLength"));
                    abdominalCircumferenceD = Double.parseDouble(request.getParameter("abdominalCircumference"));
                    occipitofromtalDiameterD = Double.parseDouble(request.getParameter("occipitofromtalDiameter"));
                    humerusLengthD = Double.parseDouble(request.getParameter("humerusLength"));
                    estimatedFetalWeightD = Double.parseDouble(request.getParameter("estimatedFetalWeight"));
                } catch (NumberFormatException nfe){
                    error = true;
                }
                if (error){
                    headerMessage = "Invalid Value!";

                }else{
                    ulrecord.setCrownRumpLength(crownRumpLengthD);
                    ulrecord.setBiparietalDiameter(biparietalDiameterD);
                    ulrecord.setHeadCircumference(headCircumferenceD);
                    ulrecord.setFemurLength(femurLengthD);
                    ulrecord.setAbdoCircumference(abdominalCircumferenceD);
                    ulrecord.setOcciFrontalDiameter(occipitofromtalDiameterD);
                    ulrecord.setHumerusLength(humerusLengthD);
                    ulrecord.setEstimatedFetalWeight(estimatedFetalWeightD);
                    ulrecord.setUltraSoundImage(image);
                    try{
                        headerMessage=action.addUltrasoundRecord(ulrecord, false);
                        if(headerMessage.startsWith("Success")){
                            TransactionLogger.getInstance().logTransaction(TransactionType.ULTRASOUND_RECORD_ADD,
                                    loggedInMID, ulrecord.getOfficeVisitID(),
                                    "" + ulrecord.getOfficeVisitID());
                            System.out.println(headerMessage);
                        }
                    } catch(FormValidationException e){
    %>
    <div align=center><span class="iTrustError"><%=StringEscapeUtils.escapeHtml(e.getMessage())%></span></div>
    <%
                    }
                }
            }
        }

    %>
    <div align="left" id="ultraSoundDiv">
        <h2>Document an Ultra Sound</h2>
        <span class="iTrustMessage"><%= StringEscapeUtils.escapeHtml("" + (headerMessage )) %></span><br /><br />
        <%
            if (!exists) {
          %><h5><a href="uploadUltraSoundRecord.jsp?ovID=<%=officevisitString%>">Upload UltraSound Record</a></h5> <%
        }
        %>
        <br />
        <span>Crown rump length: </span>
        <input style="width: 250px;" type="text" name="crownRumpLength" value="<%= StringEscapeUtils.escapeHtml("" + ( crownRumpLength)) %>" />
        <br /><br />
        <span>Biparietal diameter: </span>
        <input style="width: 250px;" type="text" name="biparietalDiameter" value="<%= StringEscapeUtils.escapeHtml("" + ( biparietalDiameter)) %>" />
        <br /><br />
        <span>Head circumference: </span>
        <input style="width: 250px;" type="text" name="headCircumference" value="<%= StringEscapeUtils.escapeHtml("" + ( headCircumference)) %>" />
        <br /><br />
        <span>Femur length: </span>
        <input style="width: 250px;" type="text" name="femurLength" value="<%= StringEscapeUtils.escapeHtml("" + ( femurLength)) %>" />
        <br /><br />
        <span>Occipitofrontal diameter: </span>
        <input style="width: 250px;" type="text" name="occipitofromtalDiameter" value="<%= StringEscapeUtils.escapeHtml("" + ( occipitofromtalDiameter)) %>" />
        <br /><br />
        <span>Abdominal circumference: </span>
        <input style="width: 250px;" type="text" name="abdominalCircumference" value="<%= StringEscapeUtils.escapeHtml("" + ( abdominalCircumference)) %>" />
        <br /><br />
        <span>Humerus length: </span>
        <input style="width: 250px;" type="text" name="humerusLength" value="<%= StringEscapeUtils.escapeHtml("" + ( humerusLength)) %>" />
        <br /><br />
        <span>Estimated fetal weight: </span>
        <input style="width: 250px;" type="text" name="estimatedFetalWeight" value="<%= StringEscapeUtils.escapeHtml("" + ( estimatedFetalWeight)) %>" />
        <br /><br />

        <% if(!exists) {
           %> <input type="submit" value="submit" name="ultraSoundRecordButton"/>
        <%}%>
        <input type="hidden" value="UltraSoundRecord" name="ultraSoundRecord"/>
        <input type="hidden" value="<%=image%>" name="image"/>
        <input type="hidden" value="<%=ovid%>" name="ovID"/>

        <br />
        <br />
    </div>
</form>
<%@include file="/footer.jsp" %>


