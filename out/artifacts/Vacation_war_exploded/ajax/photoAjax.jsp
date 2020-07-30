<%@ page import="bean.Photo" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    int startPage = (Integer) request.getAttribute("StartPage");
    int endPage = (Integer) request.getAttribute("EndPage");
    int currentPage = (Integer) request.getAttribute("CurrentPage");
    int totalPage = (Integer) request.getAttribute("TotalPage");
    List<Photo> photos = (List<Photo>) request.getAttribute("Photos");
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