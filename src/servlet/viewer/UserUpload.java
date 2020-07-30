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

@WebServlet("/upload")
public class UserUpload extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (req.getSession().getAttribute("User") != null) {
            req.getSession().setAttribute("LastPage", req.getContextPath() + "/upload");
            req.getRequestDispatcher("/pages/upload.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/index");
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            req.getSession().setAttribute("LastPage", req.getContextPath() + "/upload");
            PhotoDAO photoDAO = new PhotoDAO();
            Photo photo = photoDAO.searchPhoto("SELECT * FROM travelimage WHERE ImageID = ?", req.getParameter("id"));
            String description = photoDAO.searchItem("SELECT Description FROM travelimage WHERE ImageID = ?", req.getParameter("id"));
            photo.setDescription(description);
            photo.setCityName(Utils.getCityName(photoDAO, photo.getCityCode()));
            photo.setCountryName(Utils.getCountryName(photoDAO, photo.getCountryCode()));
            req.setAttribute("Photo", photo);
            req.getRequestDispatcher("/pages/upload.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}