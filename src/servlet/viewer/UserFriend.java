package servlet.viewer;

import DAO.UserDAO;
import bean.User;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@WebServlet("/friend")
public class UserFriend extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) {
        try {
            if (req.getSession().getAttribute("User") != null) {
                req.getSession().setAttribute("LastPage", req.getContextPath() + "/friend");
                UserDAO userDAO = new UserDAO();
                int UID = ((User) req.getSession().getAttribute("User")).getUID();
                List<User> friends = userDAO.searchUsers("SELECT * FROM traveluser LEFT JOIN (SELECT FromUID, ToUID, IfAccept FROM traveluserfriend WHERE FromUID = ? OR ToUID = ?) " +
                                "AS tb ON tb.FromUID = traveluser.UID OR tb.ToUID = traveluser.UID WHERE (traveluser.UID = tb.FromUID OR traveluser.UID = tb.ToUID) AND traveluser.UID != ? AND IfAccept = true",
                        UID, UID, UID);
                List<User> requestFriends = userDAO.searchUsers("SELECT * FROM traveluser LEFT JOIN (SELECT FromUID, ToUID, IfAccept FROM traveluserfriend WHERE ToUID = ?) " +
                        "AS tb ON tb.FromUID = traveluser.UID OR tb.ToUID = traveluser.UID WHERE traveluser.UID = tb.FromUID AND IfAccept = false", UID);
                req.setAttribute("Friends", friends);
                req.setAttribute("RequestFriends", requestFriends);
                req.setAttribute("IfHideFavor", ((User) req.getSession().getAttribute("User")).isIfHideFavor());
                req.getRequestDispatcher("/pages/friend.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/index");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            UserDAO userDAO = new UserDAO();
            int UID = ((User) req.getSession().getAttribute("User")).getUID();
            String userName = req.getParameter("name");
            List<User> friends = userDAO.searchUsers("SELECT * FROM traveluser LEFT JOIN (SELECT FromUID, ToUID, IfAccept FROM traveluserfriend WHERE FromUID = ? OR ToUID = ?) " +
                            "AS tb ON tb.FromUID = traveluser.UID OR tb.ToUID = traveluser.UID WHERE (traveluser.UID = tb.FromUID OR traveluser.UID = tb.ToUID) AND traveluser.UID != ? AND IfAccept = true",
                    UID, UID, UID);
            List<User> requestFriends = userDAO.searchUsers("SELECT * FROM traveluser LEFT JOIN (SELECT FromUID, ToUID, IfAccept FROM traveluserfriend WHERE ToUID = ?) " +
                    "AS tb ON tb.FromUID = traveluser.UID OR tb.ToUID = traveluser.UID WHERE traveluser.UID = tb.FromUID AND IfAccept = false", UID);
            List<User> newFriends = userDAO.searchUsers("SELECT * FROM traveluser WHERE UserName LIKE ? AND UID != ?", "%" + userName + "%", UID);
            req.setAttribute("RequestFriends", requestFriends);
            req.setAttribute("NewFriends", newFriends.subList(0, Math.min(newFriends.size(), 50)));
            req.setAttribute("Friends", friends);
            req.setAttribute("IfHideFavor", ((User) req.getSession().getAttribute("User")).isIfHideFavor());
            req.getRequestDispatcher("/pages/friend.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
