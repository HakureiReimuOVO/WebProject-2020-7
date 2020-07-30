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

@WebServlet("/LoginService")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            UserDAO dao = new UserDAO();
            HttpSession session = req.getSession();
            String name = req.getParameter("name");
            String password = req.getParameter("password");
            Timestamp date = Utils.getCurrentTimestamp();
            String code = req.getParameter("code");
            User user = dao.searchUser("SELECT * FROM traveluser WHERE (UserName = ? OR Email = ?) AND Password = ?", name, name, password);
            if (req.getSession().getAttribute("Code").equals(code)) {
                if (user.getUID() != 0) {
                    dao.updateDatabase("UPDATE traveluser SET DateLastModified = ? WHERE UID = ?", date, user.getUID());
                    session.setAttribute("User", user);
                    String URL;
                    if (session.getAttribute("LastPage") == null) URL = req.getContextPath() + "/index";
                    else URL = (String) session.getAttribute("LastPage");
                    resp.sendRedirect(URL);
                } else {
                    req.getSession().setAttribute("Message", "Username or password is wrong!");
                    req.getSession().setAttribute("Name", name);
                    resp.sendRedirect(req.getContextPath() + "/login");
                }
            } else {
                req.getSession().setAttribute("Message", "Verification code is wrong!");
                req.getSession().setAttribute("Name", name);
                resp.sendRedirect(req.getContextPath() + "/login");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
