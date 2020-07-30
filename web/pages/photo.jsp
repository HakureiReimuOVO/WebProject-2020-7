<%@ page import="bean.User" %>
<%@ page import="bean.Photo" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>Photo</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/css/bootstrap.min.css">
    <script src="<%=request.getContextPath()%>/src/jquery-3.5.1/jquery-3.5.1.min.js"></script>
    <script src="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/CSS/photo.css">
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
    <h4 class="strong">My Photo</h4>
    <div class="dropdown-divider"></div>
    <div id="ajax-response">
        <%
            int startPage = (Integer) request.getAttribute("StartPage");
            int endPage = (Integer) request.getAttribute("EndPage");
            int currentPage = (Integer) request.getAttribute("CurrentPage");
            int totalPage = (Integer) request.getAttribute("TotalPage");
            List<Photo> photos = (List<Photo>) request.getAttribute("Photos");
            if (photos.isEmpty()) {
        %>
        <h2 style="text-align: center; margin-top: 50px;">You haven't uploaded any photo.</h2>
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
                <form action="<%=request.getContextPath()%>/upload" method="post">
                    <input type="hidden" name="id" value="<%=photo.getImageID()%>">
                    <input type="submit" value="Modify" class="btn btn-secondary">
                </form>
                <input type="button" value="Delete" class="btn btn-danger" data-toggle="modal"
                       data-target="#image_<%=photo.getImageID()%>" data-whatever="@mdo">
            </div>
        </div>
        <div class="modal fade" id="image_<%=photo.getImageID()%>" tabindex="-1" role="dialog"
             aria-labelledby="exampleModalLabel">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-body">
                        Are you sure to delete <strong><%=photo.getTitle()%>
                    </strong>?
                    </div>
                    <div class="modal-footer">
                        <input type="button" value="Cancel" class="btn btn-outline-primary btn-confirm"
                               data-dismiss="modal">
                        <form action="<%=request.getContextPath()%>/DeleteService" method="post">
                            <input type="hidden" name="id" value="<%=photo.getImageID()%>">
                            <input type="submit" value="Yes" class="btn btn-outline-danger btn-confirm">
                        </form>
                    </div>
                </div>
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
            <span onclick="toPage(<%=i%>)"<%=(i == currentPage) ? " id=\"current\"" : ""%>><%=i%></span>
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
<script>
    var ajaxResponse = document.getElementById("ajax-response");

    function toPage(targetPage) {
        var request = ajaxFunction();
        request.open("POST", "<%=request.getContextPath()%>/photo", true);
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