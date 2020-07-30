<%@ page import="bean.Photo" %>
<%@ page import="java.util.List" %>
<%@ page import="bean.User" %>
<%@ page import="utils.Utils" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>Index</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/css/bootstrap.min.css">
    <script src="<%=request.getContextPath()%>/src/jquery-3.5.1/jquery-3.5.1.min.js"></script>
    <script src="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/CSS/index.css">
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
            <li class="nav-item active">
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
<div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
    <ol class="carousel-indicators">
        <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
        <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
        <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
        <li data-target="#carouselExampleIndicators" data-slide-to="3"></li>
        <li data-target="#carouselExampleIndicators" data-slide-to="4"></li>
    </ol>
    <div class="carousel-inner">
        <%
            for (Photo popularPhoto : (List<Photo>) request.getAttribute("PopularPhotos")) {
        %>
        <div class="carousel-item img-container">
            <a href="<%=request.getContextPath()%>/details?id=<%=popularPhoto.getImageID()%>">
                <img src="<%=request.getContextPath()%>/src/images/travel-images/large/<%=popularPhoto.getPath()%>"
                     class="d-block w-100" alt="...">
            </a>
        </div>
        <%
            }
        %>
    </div>
    <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
    </a>
    <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
    </a>
</div>
<div class="container-center">
    <h4>Newly Realeased Photo</h4>
    <%
        for (Photo newPhoto : (List<Photo>) request.getAttribute("NewPhotos")) {
    %>
    <div class="picture">
        <a href="<%=request.getContextPath()%>/details?id=<%=newPhoto.getImageID()%>">
            <div class="img-container">
                <img src="<%=request.getContextPath()%>/src/images/travel-images/medium/<%=newPhoto.getPath()%>">
            </div>
        </a>
        <p class="title h4 text-uppercase"><%=newPhoto.getTitle()%>
        </p>
        <p class="uploader"><%=newPhoto.getUserName()%> <%=Utils.modifyTimestamp(newPhoto.getDateLastModified(), "yyyy-MM-dd")%>
        </p>
        <div class="dropdown-divider"></div>
        <p class="description"><%=newPhoto.getDescription()%>
        </p>
    </div>
    <%
        }
    %>
</div>
<footer>Copyright © 2020 QQD All Rights Reserved</footer>
</body>
<script>
    var activePicture = document.getElementsByClassName("carousel-item").item(0);
    activePicture.classList.add("active");
</script>
</html>