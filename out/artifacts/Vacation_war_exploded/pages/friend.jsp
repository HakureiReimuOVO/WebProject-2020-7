<%@ page import="bean.User" %>
<%@ page import="java.util.List" %>
<%@ page import="utils.Utils" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>Friend</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/css/bootstrap.min.css">
    <script src="<%=request.getContextPath()%>/src/jquery-3.5.1/jquery-3.5.1.min.js"></script>
    <script src="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/CSS/friend.css">
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
<%
    List<User> requestFriends;
    if (!(requestFriends = (List<User>) request.getAttribute("RequestFriends")).isEmpty()) {

%>
<section>
    <h4 class="strong">New Friend</h4>
    <div class="dropdown-divider"></div>
    <%
        for (User requestFriend : requestFriends) {
    %>
    <div class="friend-container">
        <div><strong>Name:</strong> <%=requestFriend.getUserName()%>
        </div>
        <div><strong>UID:</strong> <%=requestFriend.getUID()%>
        </div>
        <div><strong>Email:</strong> <%=requestFriend.getEmail()%>
        </div>
        <div><strong>Last Active
            Time:</strong> <%=Utils.modifyTimestamp(requestFriend.getDateLastModified(), "yyyy-MM-dd HH:mm")%>
        </div>
        <div><strong>Register
            Time:</strong> <%=Utils.modifyTimestamp(requestFriend.getDateJoined(), "yyyy-MM-dd HH:mm")%>
        </div>
        <form action="<%=request.getContextPath()%>/FriendService?method=accept" method="post">
            <input type="submit" value="Accept" class="btn btn-outline-success">
            <input type="hidden" name="uid" value="<%=requestFriend.getUID()%>">
        </form>
        <form action="<%=request.getContextPath()%>/FriendService?method=delete" method="post">
            <input type="submit" value="Refuse" class="btn btn-outline-danger">
            <input type="hidden" name="uid" value="<%=requestFriend.getUID()%>">
        </form>
    </div>
    <%
            }
        }
    %>
</section>
<section>
    <h4 class="strong">Add Friend</h4>
    <div class="dropdown-divider"></div>
    <form class="friend-add" action="<%=request.getContextPath()%>/friend" method="post">
        Enter <strong>UserName:</strong><input type="text" name="name" class="form-control" required>
        <input type="submit" value="Search" class="btn btn-outline-success">
    </form>
    <%
        List<User> newFriends;
        if ((newFriends = (List<User>) request.getAttribute("NewFriends")) != null) {
            if (!newFriends.isEmpty()) {
                out.print("<br><br>");
                for (User newFriend : (List<User>) request.getAttribute("NewFriends")) {
    %>
    <div class="friend-container">
        <div><strong>Name:</strong> <%=newFriend.getUserName()%>
        </div>
        <div><strong>UID:</strong> <%=newFriend.getUID()%>
        </div>
        <div><strong>Email:</strong> <%=newFriend.getEmail()%>
        </div>
        <div><strong>Last Active
            Time:</strong> <%=Utils.modifyTimestamp(newFriend.getDateLastModified(), "yyyy-MM-dd HH:mm")%>
        </div>
        <div><strong>Register Time:</strong> <%=Utils.modifyTimestamp(newFriend.getDateJoined(), "yyyy-MM-dd HH:mm")%>
        </div>
        <form action="<%=request.getContextPath()%>/FriendService?method=add" method="post">
            <input type="submit" value="ADD" class="btn btn-outline-danger">
            <input type="hidden" name="uid" value="<%=newFriend.getUID()%>">
        </form>
    </div>
    <%
        }
    } else {
    %>
    <h3 style="text-align: center; margin-top: 20px;">No user has been found.</h3>
    <%
            }
        }
    %>
</section>
<section>
    <h4 class="strong">My Friend</h4>
    <div class="dropdown-divider"></div>
    <%
        List<User> friends = (List<User>) request.getAttribute("Friends");
        if (!friends.isEmpty())
            for (User friend : friends) {
    %>
    <div class="friend-container">
        <div><strong>Name:</strong> <%=friend.getUserName()%>
        </div>
        <div><strong>UID:</strong> <%=friend.getUID()%>
        </div>
        <div><strong>Email:</strong> <%=friend.getEmail()%>
        </div>
        <div><strong>Last Active
            Time:</strong> <%=Utils.modifyTimestamp(friend.getDateLastModified(), "yyyy-MM-dd HH:mm")%>
        </div>
        <div><strong>Register Time:</strong> <%=Utils.modifyTimestamp(friend.getDateJoined(), "yyyy-MM-dd HH:mm")%>
        </div>
        <form action="<%=request.getContextPath()%>/favor" method="post">
            <input type="submit" value="View" class="btn btn-outline-success">
            <input type="hidden" name="uid" value="<%=friend.getUID()%>">
        </form>
        <form action="<%=request.getContextPath()%>/chat" method="post">
            <input type="submit" value="Chat" class="btn btn-outline-info">
            <input type="hidden" name="uid" value="<%=friend.getUID()%>">
        </form>
        <form action="<%=request.getContextPath()%>/FriendService?method=delete" method="post">
            <input type="submit" value="Delete" class="btn btn-outline-danger">
            <input type="hidden" name="uid" value="<%=friend.getUID()%>">
        </form>
    </div>
    <%
        }
    else {
    %>
    <h2 style="text-align: center; margin-top: 50px;">You haven't add any friend.</h2>
    <%
        }
    %>
</section>
<section>
    <h4 class="strong">Hide Favor</h4>
    <div class="dropdown-divider"></div>
    <form action="<%=request.getContextPath()%>/HideFavorService" method="post">
        <input type="hidden" name="ifHideFavor" value="true">
        <input type="submit" value="YES"
               class="btn btn-<%=((Boolean)request.getAttribute("IfHideFavor"))?"":"outline-"%>success">
    </form>
    <form action="<%=request.getContextPath()%>/HideFavorService" method="post">
        <input type="hidden" name="ifHideFavor" value="false">
        <input type="submit" value="NO"
               class="btn btn-<%=((Boolean)request.getAttribute("IfHideFavor"))?"outline-":""%>danger">
    </form>
</section>
</body>
</html>