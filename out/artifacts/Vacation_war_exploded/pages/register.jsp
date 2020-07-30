<%@ page import="bean.User" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/css/bootstrap.min.css">
    <script src="<%=request.getContextPath()%>/src/jquery-3.5.1/jquery-3.5.1.min.js"></script>
    <script src="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/js/bootstrap.min.js"></script>
    <script src="<%=request.getContextPath()%>/src/JavaScript/md5.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/CSS/register.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand" href="#"><img src="<%=request.getContextPath()%>/src/images/html-images/logo.png" width="35" height="35" alt="logo"/></a>
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
                   aria-haspopup="true" aria-expanded="false"><%=((User)session.getAttribute("User")).getUserName()%></a>
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
        String userName = null;
        String email = null;
        if (session.getAttribute("UserName") != null) {
            userName = (String) session.getAttribute("UserName");
            session.removeAttribute("UserName");
        }
        if (session.getAttribute("Email") != null) {
            email = (String) session.getAttribute("Email");
            session.removeAttribute("Email");
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
    <h4 class="strong">Register</h4>
    <div class="dropdown-divider"></div>
    <form action="<%=request.getContextPath()%>/RegisterService" method="post" onsubmit="return checkForm();">
        <div>
            Username<br>
            <input type="text" name="username" class="form-control input-text" value="<%=(userName == null)? "" : userName %>">
        </div>
        <div>
            Email<br>
            <input type="text" name="email" class="form-control input-text" value="<%=(email == null)? "" : email %>">
        </div>
        <div>
            Password<br>
            <input type="password" name="password" class="form-control input-text">
        </div>
        <div>
            Confirm your Password<br>
            <input type="password" name="checkedPassword" class="form-control input-text">
        </div>
        <div>
            <img src="<%=request.getContextPath()%>/CodeService" onclick="changeCode(this);">
            <input type="text" name="code" class="form-control input-code">
        </div>
        <input type="submit" value="Register" class="btn btn-outline-success">
        <a href="<%=request.getContextPath()%>/login"><input type="button" value="Cancel" class="btn btn-outline-secondary"></a>
    </form>
</section>
<script>
    function changeCode(img) {
        img.src = img.src + "?" + new Date().getTime();
    }

    function setDangerStyle(element) {
        removeStyle(element);
        element.classList.add("border-danger");
    }

    function setWarningStyle(element) {
        removeStyle(element);
        element.classList.add("border-warning");
    }

    function setInfoStyle(element) {
        removeStyle(element);
        element.classList.add("border-info");
    }

    function setSuccessStyle(element) {
        removeStyle(element);
        element.classList.add("border-success");
    }

    function removeStyle(element) {
        element.classList.remove("border-danger");
        element.classList.remove("border-warning");
        element.classList.remove("border-info");
        element.classList.remove("border-success");
    }

    function checkPassword(password) {
        let level = 0;
        if (password.length < 6 || password.length > 12) return level;
        if (/\d/.test(password)) level++;
        if (/[a-z]/.test(password)) level++;
        if (/[A-Z]/.test(password)) level++;
        return level;
    }

    function alertMessage(message) {
        informationContainer.innerHTML += "<div class=\"alert alert-danger alert-dismissible fade show\" " +
            "style=\"width: 50%; margin: 10px auto 10px auto \"><button type=\"button\" class=\"close\" data-dismiss=\"alert\">&times;</button>"
            + message + "</div>";
    }

    function checkForm() {
        informationContainer.innerHTML = "";
        let ifValid = true;
        if (!pattern_username.test(userName.value)) {
            alertMessage("Please check your username!");
            ifValid = false;
        }
        if (!pattern_email.test(email.value)) {
            alertMessage("Please check your email!");
            ifValid = false;
        }
        let level = checkPassword(password.value);
        switch (level) {
            case 0:
                alertMessage("Your password is too long or too short!");
                ifValid = false;
                break;
            case 1:
                alertMessage("Your password is too simple!");
                ifValid = false;
        }
        if (password.value !== checkedPassword.value) {
            alertMessage("The two passwords aren't consistent!");
            ifValid = false;
        }
        if (code.value === "") {
            alertMessage("Please enter the verification code!");
            ifValid = false;
        }
        if (ifValid) password.value = md5(password.value).toUpperCase();
        return ifValid;
    }

    const pattern_username = /^[\w]{4,15}$/;
    const pattern_email = /^[\w-_.]+@[\w-_.]+(\.[\w-_]+)+$/;
    var userName = document.getElementsByName("username").item(0);
    var email = document.getElementsByName("email").item(0);
    var password = document.getElementsByName("password").item(0);
    var checkedPassword = document.getElementsByName("checkedPassword").item(0);
    var code = document.getElementsByName("code").item(0);
    var submit = document.getElementById("submit");
    var informationContainer = document.getElementById("information-container");

    userName.onkeyup = function () {
        if (pattern_username.test(userName.value)) setSuccessStyle(userName);
        else setDangerStyle(userName);
    };

    email.onkeyup = function () {
        if (pattern_email.test(email.value)) setSuccessStyle(email);
        else setDangerStyle(email);
    };

    password.onkeyup = function () {
        let level = checkPassword(password.value);
        switch (level) {
            case 0:
                setDangerStyle(password);
                break;
            case 1:
                setWarningStyle(password);
                break;
            case 2:
                setInfoStyle(password);
                break;
            case 3:
                setSuccessStyle(password);
        }
        checkedPassword.onkeyup();
    };

    checkedPassword.onkeyup = function () {
        if (checkedPassword.value !== "")
            if (checkedPassword.value === password.value) setSuccessStyle(checkedPassword);
            else setDangerStyle(checkedPassword);
    };
</script>
</body>
</html>