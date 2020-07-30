<%@ page import="bean.User" %>
<%@ page import="bean.Photo" %>
<%@ page import="utils.Utils" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>Details</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/css/bootstrap.min.css">
    <script src="<%=request.getContextPath()%>/src/jquery-3.5.1/jquery-3.5.1.min.js"></script>
    <script src="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/CSS/detail.css">
    <style>
        #navbarDropdown {
            min-width: 140px;
            text-align: right;
        }

        .strong {
            font-weight: bold;
        }

        section {
            margin: 40px;
        }

        section p {
            font-weight: bold;
            margin-bottom: 5px;
        }

        #title {
            font-weight: bolder;
            font-size: 23pt;
        }

        #detail {
            font-size: 10pt;
            color: gray;
        }

        #content {
            text-align: center;
        }

        #content_picture {
            display: inline-block;
            vertical-align: middle;
            width: 49%;
            min-width: 400px;
        }

        #content_picture img {
            width: 100%;
            border-radius: 15px;
            min-width: 300px;
        }

        #content_aside {
            display: inline-block;
            vertical-align: middle;
            text-align: center;
            width: 49%;
            min-width: 300px;
        }

        #content_bottom {
            margin: 30px 0 30px 0;
            line-height: 33px;
        }

        .btn {
            margin-top: 20px;
            width: 300px;
        }

        .limit-width {
            width: 300px;
            display: inline-block;
        }

        #small-picture {
            width: 100%;
            border-radius: 15px;
            min-width: 300px;
        }

        #big-picture {
            width: 100%;
            position: relative;
        }

        #zoom-picture {
            position: absolute;
            top: 200px;
            left: 200px;
            width: 250px;
            height: 250px;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
            display: none;
        }

        #zoom {
            position: absolute;
            width: 70px;
            height: 70px;
            border-radius: 15px;
            background-color: rgba(255, 255, 255, 0.10);
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
            display: none;
        }
    </style>
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
    <h4 class="strong">Details</h4>
    <div class="dropdown-divider"></div>
    <div id="content">
        <div id="content_picture">
            <%
                Photo photo = (Photo) request.getAttribute("Photo");
                boolean ifModified = !photo.getDateLastModified().equals(photo.getDateUploaded());
            %>
            <img id="small-picture" src="<%=request.getContextPath()%>/src/images/travel-images/large/<%=photo.getPath()%>">
            <div id="zoom"></div>
        </div>
        <div id="zoom-picture"><img id="big-picture" src="<%=request.getContextPath()%>/src/images/travel-images/large/<%=photo.getPath()%>"></div>
        <div id="content_aside">
            <div id="title"><%=photo.getTitle()%>
            </div>
            <div id="detail">By <%=photo.getUserName()%> (UID:<%=photo.getUID()%>)<br>Uploaded
                On <%=Utils.modifyTimestamp(photo.getDateUploaded(),"yyyy-MM-dd HH:mm")%>
                <%
                    if (ifModified) {
                %><br>Last Modified On <%=Utils.modifyTimestamp(photo.getDateLastModified(),"yyyy-MM-dd HH:mm")%>
                <%
                    }
                %>
            </div>
            <div class="dropdown-divider limit-width"></div>
            <div id="like_number">
                <p class="title">Favor Number</p>
                <span><%=photo.getFavorNumber()%></span>
            </div>
            <div class="dropdown-divider limit-width"></div>
            <div id="image_details">
                <p class="title">Photo Details</p>
                <span>Content: <%=photo.getContent()%><br>
                Country: <%=photo.getCountryName()%><br>
                City: <%=photo.getCityName()%><br>
                </span>
            </div>
            <form action="<%=request.getContextPath()%>/FavorService" method="post">
                <%
                    if (session.getAttribute("User") == null) {
                %>
                <a href="<%=request.getContextPath()%>/login">
                    <input type="button" value="LOGIN" class="btn btn-outline-secondary">
                </a>
                <%
                } else if ((Boolean) request.getAttribute("IfFavor")) {
                %>
                <input type="hidden" name="id" value="<%=photo.getImageID()%>">
                <input type="submit" value="FAVORED" class="btn btn-outline-success">
                <%
                } else {
                %>
                <input type="hidden" name="id" value="<%=photo.getImageID()%>">
                <input type="submit" value="FAVOR" class="btn btn-outline-danger">
                <%
                    }
                %>
            </form>
        </div>
    </div>
    <div id="content_bottom">
        <%=photo.getDescription()%>
    </div>
</section>
<script>
    var zoom = document.getElementById("zoom");
    var content = document.getElementById("content_picture");
    var zoomPicture = document.getElementById("zoom-picture");
    var bigPicture = document.getElementById("big-picture");
    var smallPicture = document.getElementById("small-picture");

    content.onmouseenter = function () {
        bigPicture.style.width = smallPicture.clientWidth * 250 / 70 + "px";
        zoomPicture.style.display = "initial";
        zoom.style.display = "initial";
    };

    content.onmouseleave = function () {
        zoomPicture.style.display = "none";
        zoom.style.display = "none";
    };

    content.onmousemove = function (e) {
        let left, top;
        if (e.pageX < content.offsetLeft + 35) left = content.offsetLeft;
        else if (e.pageX > content.offsetLeft + content.offsetWidth - 35) left = content.offsetLeft + content.offsetWidth - 70;
        else left = e.pageX - 35;
        if (e.pageY < content.offsetTop + 35) top = content.offsetTop;
        else if (e.pageY > content.offsetTop + content.offsetHeight - 35) top = content.offsetTop + content.offsetHeight - 70;
        else top = e.pageY - 35;
        zoom.style.left = left + "px";
        zoom.style.top = top + "px";
        zoomPicture.style.left = left + 85 + "px";
        zoomPicture.style.top = top - 90 + "px";
        bigPicture.style.top = -25 / 7 * (top - content.offsetTop) + "px";
        bigPicture.style.left = -25 / 7 * (left - content.offsetLeft) + "px";
    };
</script>
</body>
</html>