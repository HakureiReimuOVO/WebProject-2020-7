package servlet.viewer;

import DAO.PhotoDAO;
import bean.Photo;
import utils.Utils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/index")
public class Index extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.getSession().setAttribute("LastPage", req.getContextPath() + "/index");
            PhotoDAO photoDAO = new PhotoDAO();
            List<Photo> popularPhotos = photoDAO.searchPhotos("SELECT * FROM travelimage LEFT JOIN (SELECT COUNT(1),ImageID AS ID FROM travelimagefavor GROUP BY ID) " +
                    "AS tb ON tb.ID = travelimage.ImageID ORDER BY `COUNT(1)` DESC LIMIT 5");
            List<Photo> newPhotos = photoDAO.searchPhotos("SELECT * FROM travelimage ORDER BY DateLastModified DESC LIMIT 8");
            for (Photo newPhoto : newPhotos) {
                newPhoto.setUserName(Utils.getUserName(photoDAO, newPhoto.getUID()));
            }
            req.setAttribute("PopularPhotos", popularPhotos);
            req.setAttribute("NewPhotos", newPhotos);
            req.getRequestDispatcher("/pages/index.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
