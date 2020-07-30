package servlet.service;

import DAO.DAO;
import bean.User;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

@WebServlet("/FavorService")
public class FavorServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            DAO dao = new DAO();
            String imageID = req.getParameter("id");
            int UID = ((User) req.getSession().getAttribute("User")).getUID();
            Map<String, Object> result = dao.searchResult("SELECT * FROM travelimagefavor WHERE UID = ? AND ImageID = ?", UID, imageID);
            if (result.isEmpty()) {
                dao.updateDatabase("INSERT INTO travelimagefavor (UID, ImageID) VALUES (?, ?)", UID, imageID);
            } else {
                dao.updateDatabase("DELETE FROM travelimagefavor WHERE UID = ? AND ImageID = ?", UID, imageID);
            }
            String URL = req.getHeader("Referer");
            resp.sendRedirect(URL);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}