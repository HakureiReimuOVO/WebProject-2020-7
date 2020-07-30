package servlet.service;

import DAO.DAO;
import bean.User;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/FriendService")
public class FriendServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            if (req.getParameter("method").equals("add")) {
                DAO dao = new DAO();
                int fromUID = ((User) req.getSession().getAttribute("User")).getUID();
                int toUID = Integer.parseInt(req.getParameter("uid"));
                if (dao.searchResult("SELECT * FROM traveluserfriend WHERE (FromUID = ? AND ToUID = ?) OR (FromUID = ? AND ToUID = ?)", fromUID, toUID, toUID, fromUID).isEmpty()) {
                    dao.updateDatabase("INSERT INTO traveluserfriend (FromUID, ToUID, IfAccept) VALUES (?, ?, ?)", fromUID, toUID, false);
                    resp.sendRedirect(req.getContextPath() + "/friend");
                } else {
                    req.getSession().setAttribute("Message","You have already added this user!");
                    resp.sendRedirect(req.getContextPath() + "/friend");
                }
            } else if (req.getParameter("method").equals("accept")) {
                DAO dao = new DAO();
                int fromUID = ((User) req.getSession().getAttribute("User")).getUID();
                int toUID = Integer.parseInt(req.getParameter("uid"));
                dao.updateDatabase("UPDATE traveluserfriend SET IfAccept = ? WHERE (FromUID = ? AND ToUID = ?) OR (FromUID = ? AND ToUID = ?)", true, fromUID, toUID, toUID, fromUID);
                resp.sendRedirect(req.getContextPath() + "/friend");
            } else {
                DAO dao = new DAO();
                int UID = ((User) req.getSession().getAttribute("User")).getUID();
                int targetUID = Integer.parseInt(req.getParameter("uid"));
                dao.updateDatabase("DELETE FROM traveluserfriend WHERE (FromUID = ? AND ToUID = ?) OR (FromUID = ? AND ToUID = ?)", UID, targetUID, targetUID, UID);
                resp.sendRedirect(req.getContextPath() + "/friend");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}