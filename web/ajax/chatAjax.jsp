<%@ page import="bean.Message" %>
<%@ page import="java.util.List" %>
<%@ page import="bean.User" %>
<%@ page import="utils.Utils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="message-container">
    <%
        List<Message> messages = (List<Message>) request.getAttribute("Messages");
        int UID = ((User) session.getAttribute("User")).getUID();
        if (!messages.isEmpty()) {
            for (Message message : messages) {
    %>
    <div class="message" <%=(message.getFromID() == UID) ? "style=\"text-align: right\"" : ""%>>
        <div class="message-header">
            <span class="name"><%=message.getFromName()%></span>
            <span class="time"><%=Utils.modifyTimestamp(message.getDateSent(), "yyyy-MM-dd HH:mm:ss")%></span>
        </div>
        <div class="message-content">
            <%=message.getContent()%>
        </div>
    </div>
    <%
        }
    } else {
    %>
    <h3 style="text-align: center; margin: 20px 0 20px 0;">No message yet.</h3>
    <%
        }
    %>
</div>