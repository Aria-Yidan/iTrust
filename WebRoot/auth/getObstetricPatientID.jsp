<%--
  Created by IntelliJ IDEA.
  User: roger
  Date: 11/9/18
  Time: 10:25 AM
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
    // session.setAttribute("pid", uid_pid);
//    if (null != uid_pid && !"".equals(uid_pid)) {
//        response.sendRedirect(request.getParameter("forward"));
//    }

    String firstName = request.getParameter("FIRST_NAME");
    String lastName = request.getParameter("LAST_NAME");
    if(firstName == null)
        firstName = "";
    if(lastName == null)
        lastName = "";


    // boolean isAudit = request.getParameter("forward") != null && request.getParameter("forward").contains("hcp/auditPage.jsp");
%>

<%@include file="/util/getUserFrame.jsp"%>


<script type="text/javascript">
    $(function(){

        $("#searchBox").keyup(function(){
            $this = $(this);
            var q = $this.val();
            $.ajax({
                url : "PatientSearchServlet",
                data : {
                    q : q,
                    forward : "<%= StringEscapeUtils.escapeHtml(request.getParameter("forward")) %>",
                    <%--isAudit : <%= isAudit %>,--%>
                    <%--allowDeactivated : $("#allowDeactivated").attr("checked"),--%>
                    obstetric : "YES",
                },
                success : function(e){
                    $("#searchTarget").html(e);
                }
            });
        });
        <%--$("#allowDeactivated").click(function(){--%>
            <%--var q = $("#searchBox").val();--%>
            <%--$.ajax({--%>
                <%--url : "PatientSearchServlet",--%>
                <%--data : {--%>
                    <%--q : q,--%>
                    <%--forward : "<%= StringEscapeUtils.escapeHtml(request.getParameter("forward")) %>",--%>
                    <%--&lt;%&ndash;isAudit : <%= isAudit %>,&ndash;%&gt;--%>
                    <%--&lt;%&ndash;allowDeactivated : $("#allowDeactivated").attr("checked")&ndash;%&gt;--%>
                <%--},--%>
                <%--success : function(e){--%>
                    <%--$("#searchTarget").html(e);--%>
                <%--}--%>
            <%--});--%>
        <%--});--%>
        $("#oldSearch").hide();

    });
</script>
<h2> Select a Patient</h2>
<b>Search by name or MID:</b><br/>
<%--<%--%>
    <%--if(isAudit){--%>
<%--%>--%>
<%--<div style="border: 1px solid Gray; padding:5px;float:left;">--%>
    <%--<input id="searchBox" style="width: 250px;" type="text" value="<%= StringEscapeUtils.escapeHtml("" + ( firstName )) %>" />--%>
    <%--<br />--%>
    <%--<input id="allowDeactivated" type="checkbox" />--%>
    <%--Show deactivated patients--%>
<%--</div>--%>
<%--<%}--%>
<%--else--%>
<%--{ %>--%>
<div style="border: 1px solid Gray; padding:5px;float:left;">
    <input id="searchBox" style="width: 250px;" type="text" value="<%= StringEscapeUtils.escapeHtml("" + ( firstName )) %>" />
    <br />
</div>
<%--<%}%>--%>

<!-- <iframe id="userSearch" style="width:100%;min-height:600px;border:none;"></iframe> -->

<div id="searchTarget"></div>

<%@include file="/footer.jsp" %>