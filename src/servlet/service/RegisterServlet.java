package servlet.service;

import DAO.UserDAO;
import bean.User;
import utils.Utils;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Timestamp;

@WebServlet("/RegisterService")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            UserDAO dao = new UserDAO();
            HttpSession session = req.getSession();
            String userName = req.getParameter("username");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            Timestamp date = Utils.getCurrentTimestamp();
            String code = req.getParameter("code");
            boolean ifHideFavor = false;
            if (req.getSession().getAttribute("Code").equals(code)) {
                if (dao.searchResult("SELECT * FROM traveluser WHERE UserName = ?", userName).isEmpty()) {
                    dao.updateDatabase("INSERT INTO traveluser (UserName, Email, Password, DateJoined, DateLastModified, IfHideFavor) VALUES (? ,? ,? ,? ,? ,?)",
                            userName, email, password, date, date, ifHideFavor);
                    User user = dao.searchUser("SELECT * FROM traveluser WHERE (UserName = ? OR Email = ?) AND Password = ?", userName, email, password);
                    session.setAttribute("User", user);
                    String URL;
                    if (session.getAttribute("LastPage") == null) URL = req.getContextPath() + "/index";
                    else URL = (String) session.getAttribute("LastPage");
                    resp.sendRedirect(URL);
                } else {
                    req.getSession().setAttribute("Message", "Duplicated username!");
                    req.getSession().setAttribute("UserName", userName);
                    req.getSession().setAttribute("Email", email);
                    resp.sendRedirect(req.getContextPath() + "/register");
                }
            } else {
                req.getSession().setAttribute("Message", "Verification code is wrong!");
                req.getSession().setAttribute("UserName", userName);
                req.getSession().setAttribute("Email", email);
                resp.sendRedirect(req.getContextPath() + "/register");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
