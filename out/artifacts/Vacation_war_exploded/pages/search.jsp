<%@ page import="bean.User" %>
<%@ page import="java.util.List" %>
<%@ page import="bean.Photo" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>Search</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/css/bootstrap.min.css">
    <script src="<%=request.getContextPath()%>/src/jquery-3.5.1/jquery-3.5.1.min.js"></script>
    <script src="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/CSS/search.css">
    <script>
        var ajaxStatement = "<%=request.getAttribute("AjaxStatement")%>";
    </script>
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
            <li class="nav-item active">
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
<div id="search_section">
    <form action="<%=request.getContextPath()%>/search" method="post">
        <h4 class="strong">Search</h4>
        <div class="dropdown-divider"></div>
        <span>Search By</span>
        <input type="radio" value="title" name="searchType" class="custom-radio" required> Title
        <input type="radio" value="content" name="searchType" class="custom-radio" required> Content<br>
        <span>Order By</span>
        <input type="radio" value="date" name="orderType" class="custom-radio" required> Date
        <input type="radio" value="popularity" name="orderType" class="custom-radio" required> Popularity<br>
        <textarea name="searchContent" class="form-control" rows="5" required></textarea>
        <input type="submit" class="btn btn-outline-success" value="Search">
    </form>
</div>
<%
    if (request.getAttribute("Photos") != null) {
        int startPage = (Integer) request.getAttribute("StartPage");
        int endPage = (Integer)request.getAttribute("EndPage");
        int currentPage = (Integer)request.getAttribute("CurrentPage");
        int totalPage = (Integer)request.getAttribute("TotalPage");
        List<Photo> photos = (List<Photo>) request.getAttribute("Photos");
%>
<section>
    <h4 class="strong">Result</h4>
    <div class="dropdown-divider"></div>
    <div id="ajax-response">
        <%
            if (photos.isEmpty()) {
        %>
        <h2 style="text-align: center; margin-top: 50px;">No photo has been found.</h2>
        <%
        } else {
            for (Photo photo : photos) {
        %>
        <div class="photo_section">
            <a href="<%=request.getContextPath()%>/details?id=<%=photo.getImageID()%>" class="photo_picture">
                <div class="img-container">
                    <img src="<%=request.getContextPath()%>/src/images/travel-images/medium/<%=photo.getPath()%>">
                </div>
            </a>
            <div class="photo_detail">
                <p class="picture-title"><%=photo.getTitle()%>
                </p>
                <p class="picture-description"><%=photo.getDescription()%>
                </p>
            </div>
        </div>
        <%
            }
        %>
        <div id="page">
            <%
                if (currentPage != 1) {
            %>
            <span onclick="toPage(1)"><</span>
            <%
                }
                if (startPage > 1) {
            %>
            ...
            <%
                }
                for (int i = startPage; i <= endPage; i++) {
            %>
            <span onclick="toPage(<%=i%>)"<%=(i==currentPage)?" id=\"current\"":""%>><%=i%></span>
            <%
                }
                if (endPage < totalPage) {
            %>
            ...
            <%
                }
                if (currentPage != totalPage) {
            %>
            <span onclick="toPage(<%=totalPage%>)">></span>
            <%
                }
            %>
        </div>
        <%
            }
        %>
    </div>
</section>
<%
    }
%>
<script>
    var ajaxResponse = document.getElementById("ajax-response");

    function toPage(targetPage) {
        var request = ajaxFunction();
        request.open("POST", "<%=request.getContextPath()%>/search", true);
        request.onreadystatechange = function () {
            if (request.readyState == 4 && request.status == 200) {
                ajaxResponse.innerHTML = request.responseText;
            }
        };
        request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        request.send(ajaxStatement + "&page=" + targetPage);
    }

    function ajaxFunction() {
        var xmlHttp;
        if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();
        else xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        return xmlHttp;
    }
</script>
</body>
</html>