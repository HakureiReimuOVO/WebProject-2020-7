package servlet.service;

import DAO.DAO;
import bean.User;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/HideFavorService")
public class HideFavorServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            DAO dao = new DAO();
            int UID = ((User) req.getSession().getAttribute("User")).getUID();
            boolean ifHideFavor = req.getParameter("ifHideFavor").equals("true");
            ((User) req.getSession().getAttribute("User")).setIfHideFavor(ifHideFavor);
            dao.updateDatabase("UPDATE traveluser SET IfHideFavor = ? WHERE UID = ?", ifHideFavor, UID);
            resp.sendRedirect(req.getContextPath() + "/friend");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}