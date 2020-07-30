<%@ page import="bean.User" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>Chat</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/css/bootstrap.min.css">
    <script src="<%=request.getContextPath()%>/src/jquery-3.5.1/jquery-3.5.1.min.js"></script>
    <script src="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/CSS/chat.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand" href="#"><img src="<%=request.getContextPath()%>/src/images/html-images/logo.png" width="35"
                                          height="35" alt="logo"/></a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/index">Home</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/search">Search</a>
            </li>
        </ul>
        <ul class="navbar-nav ml-auto">
            <%
                if (session.getAttribute("User") == null) {
            %>
            <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/login">Login</a>
            </li>
            <%
            } else {
            %>
            <li class="dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown"
                   aria-haspopup="true" aria-expanded="false"><%=((User) session.getAttribute("User")).getUserName()%>
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="<%=request.getContextPath()%>/favor">Favor</a>
                    <a class="dropdown-item" href="<%=request.getContextPath()%>/photo">Photo</a>
                    <a class="dropdown-item" href="<%=request.getContextPath()%>/friend">Friend</a>
                    <a class="dropdown-item" href="<%=request.getContextPath()%>/upload">Upload</a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="<%=request.getContextPath()%>/LogoutService">Logout</a>
                </div>
            </li>
            <%
                }
            %>
        </ul>
    </div>
</nav>
<section>
    <h4 class="strong">Chat With <%=request.getAttribute("ToUserName")%>
    </h4>
    <div class="dropdown-divider"></div>
    <div id="ajax-response"></div>
    <div class="dropdown-divider"></div>
    <div class="message-send">
        Enter <strong>Message:</strong>
        <input type="text" name="content" class="form-control" id="message-send">
        <input type="button" value="Send" class="btn btn-outline-success" id="button-send">
    </div>
</section>
</body>
<script>
    var ajaxStatement = "<%=request.getAttribute("AjaxStatement")%>";
    var ajaxResponse = document.getElementById("ajax-response");
    var message = document.getElementById("message-send");
    var button = document.getElementById("button-send");
    button.onclick = sendMessage;
    window.onload = refreshMessage;
    window.setInterval("refreshMessage();", 10000);

    function refreshMessage() {
        var request = ajaxFunction();
        request.open("POST", "<%=request.getContextPath()%>/ChatService", true);
        request.onreadystatechange = function () {
            if (request.readyState == 4 && request.status == 200) {
                ajaxResponse.innerHTML = request.responseText;
                var container = document.getElementsByClassName("message-container").item(0);
                container.scrollTop = container.scrollHeight;
            }
        };
        request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        request.send(ajaxStatement);
    }

    function sendMessage() {
        if (message.value !== "") {
            var request = ajaxFunction();
            request.open("POST", "<%=request.getContextPath()%>/ChatService", true);
            request.onreadystatechange = function () {
                if (request.readyState == 4 && request.status == 200) {
                    ajaxResponse.innerHTML = request.responseText;
                    var container = document.getElementsByClassName("message-container").item(0);
                    container.scrollTop = container.scrollHeight;
                }
            };
            request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            request.send(ajaxStatement + "&method=send&content=" + message.value);
            message.value = "";
        }
    }

    function ajaxFunction() {
        var xmlHttp;
        if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();
        else xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        return xmlHttp;
    }
</script>
</html>