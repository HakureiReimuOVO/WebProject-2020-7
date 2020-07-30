package servlet.viewer;

import DAO.DAO;
import bean.User;
import utils.Utils;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/chat")
public class UserChat extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/index");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            req.getSession().setAttribute("LastPage", req.getContextPath() + "/chat");
            DAO dao = new DAO();
            int fromUID = ((User) req.getSession().getAttribute("User")).getUID();
            int toUID = Integer.parseInt(req.getParameter("uid"));
            String toUserName = Utils.getUserName(dao,toUID);
            String ajaxStatement = "FromUID=" + fromUID + "&ToUID=" + toUID ;
            req.setAttribute("ToUserName", toUserName);
            req.setAttribute("AjaxStatement", ajaxStatement);
            req.getRequestDispatcher("/pages/chat.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
