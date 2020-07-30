<%@ page import="bean.User" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/css/bootstrap.min.css">
    <script src="<%=request.getContextPath()%>/src/jquery-3.5.1/jquery-3.5.1.min.js"></script>
    <script src="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/js/bootstrap.min.js"></script>
    <script src="<%=request.getContextPath()%>/src/JavaScript/md5.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/CSS/login.css">
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
<div id="information-container">
    <%
        String name = null;
        if (session.getAttribute("Name") != null) {
            name = (String) session.getAttribute("Name");
            session.removeAttribute("Name");
        }
        if (session.getAttribute("Message") != null) {
    %>
    <div class="alert alert-danger alert-dismissible fade show" style="width: 50%; margin: 10px auto 10px auto">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
        <%=session.getAttribute("Message")%>
    </div>
    <%
            session.removeAttribute("Message");
        }
    %>
</div>
<section>
    <h4 class="strong">Login</h4>
    <div class="dropdown-divider"></div>
    <form action="<%=request.getContextPath()%>/LoginService" method="post" onsubmit="return checkForm();">
        <div>
            Username or E-mail<br>
            <input type="text" name="name" class="form-control input-text" value="<%=(name == null)? "" : name %>">
        </div>
        <div>
            Password<br>
            <input type="password" name="password" class="form-control input-text">
        </div>
        <div>
            <img src="<%=request.getContextPath()%>/CodeService" onclick="changeCode(this);">
            <input type="text" name="code" class="form-control input-code">
        </div>
        <input type="submit" value="Login" class="btn btn-outline-info">
        <a href="<%=request.getContextPath()%>/register"><input type="button" value="Sign Up"
                                                                class="btn btn-outline-success"></a>
    </form>
</section>
<script>
    function changeCode(img) {
        img.src = img.src + "?" + new Date().getTime();
    }

    function alertMessage(message) {
        informationContainer.innerHTML += "<div class=\"alert alert-danger alert-dismissible fade show\" " +
            "style=\"width: 50%; margin: 10px auto 10px auto \"><button type=\"button\" class=\"close\" data-dismiss=\"alert\">&times;</button>"
            + message + "</div>";
    }

    function checkForm() {
        informationContainer.innerHTML = "";
        let ifValid = true;
        if (nameOrMail.value === "") {
            alertMessage("Please enter your username or email!");
            ifValid = false;
        }
        if (password.value === "") {
            alertMessage("Please enter your password!");
            ifValid = false;
        }
        if (code.value === "") {
            alertMessage("Please enter the verification code!");
            ifValid = false;
        }
        if (ifValid) password.value = md5(password.value).toUpperCase();
        return ifValid;
    }

    var nameOrMail = document.getElementsByName("name").item(0);
    var password = document.getElementsByName("password").item(0);
    var code = document.getElementsByName("code").item(0);
    var informationContainer = document.getElementById("information-container");
</script>
</body>
</html>