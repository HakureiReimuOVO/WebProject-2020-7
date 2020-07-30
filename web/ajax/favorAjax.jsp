<%@ page import="bean.Photo" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    int startPage = (Integer) request.getAttribute("StartPage");
    int endPage = (Integer)request.getAttribute("EndPage");
    int currentPage = (Integer)request.getAttribute("CurrentPage");
    int totalPage = (Integer)request.getAttribute("TotalPage");
    boolean ifFriend = request.getAttribute("ifFriend").equals("true");
    List<Photo> photos = (List<Photo>) request.getAttribute("Photos");
    for (Photo photo:photos) {
%>
<%

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
        <p class="picture-description" <%=(ifFriend) ? "style=\"-webkit-line-clamp: 4; height: 120px;\"" : ""%>><%=photo.getDescription()%>
        </p>
        <%
            if (!ifFriend) {
        %>
        <form action="<%=request.getContextPath()%>/FavorService" method="post">
            <input type="hidden" name="id" value="<%=photo.getImageID()%>">
            <input type="submit" value="Delete" class="btn btn-danger">
        </form>
        <%
            }
        %>
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